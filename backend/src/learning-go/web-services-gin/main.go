package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha1"
	"encoding/base64"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"io"
	"net/http"
	"strconv"
	"strings"
)

// TEST VALUES:
// KEY: passphrasewhichneedstobe32bytes! // TODO: Test with 256 bits
// INPUT: The ultimate question: of life, the universe, of everything!
// SHA-1 HASH: 0c6ca28f5607d86e5426b46795e0fa827f1627d6
// BASE64 HASH: string DGyij1YH2G5UJrRnleD6gn8WJ9Y=
// AES OUTPUT: []uint8{104, 215, 184, 35, 194, 120, 115, 112, 133, 21, 160, 158, 11, 136, 201, 160, 233, 3, 12, 29, 133, 211, 207, 98, 35, 199, 89, 31, 203, 230, 39, 210, 225, 99, 96, 101, 3, 5, 198, 82, 243, 179, 176, 217, 8, 4, 63, 22, 134, 184, 68, 102, 255, 183, 176, 172, 6, 176, 249, 28, 127, 120, 235, 135, 73, 235, 249, 118, 194, 4, 137, 27, 158, 190, 134, 68, 21, 105, 26, 134, 10, 224, 233, 115, 28, 0, 153, 209}
// HEX AES: "68 D7 B8 23 C2 78 73 70 85 15 A0 9E B 88 C9 A0 E9 3 C 1D 85 D3 CF 62 23 C7 59 1F CB E6 27 D2 E1 63 60 65 3 5 C6 52 F3 B3 B0 D9 8 4 3F 16 86 B8 44 66 FF B7 B0 AC 6 B0 F9 1C 7F 78 EB 87 49 EB F9 76 C2 4 89 1B 9E BE 86 44 15 69 1A 86 A E0 E9 73 1C 0 99 D1"

var rawHash = "DGyij1YH2G5UJrRnleD6gn8WJ9Y="

type request struct {
	//UserID    string `json:"id"`
	Prompt string `json:"prompt"`
	Sum    string `json:"sum"`
}

var requests []request

// TODO: Test if 256 bit key works.
// TODO: Dynamically get key? Need to research best way to store private keys between two devices.
var key = []byte("passphrasewhichneedstobe32bytes!")

func encrypt() {
	text := []byte("The ultimate question: of life, the universe, of everything!")

	// generate a new aes cipher using our 32 byte long key
	c, err := aes.NewCipher(key)
	// if there are any errors, handle them
	if err != nil {
		fmt.Println(err)
	}

	// gcm or Galois/Counter Mode, is a mode of operation
	// for symmetric key cryptographic block ciphers
	// - https://en.wikipedia.org/wiki/Galois/Counter_Mode
	gcm, err := cipher.NewGCM(c)
	// if any error generating new GCM
	// handle them
	if err != nil {
		fmt.Println(err)
	}

	// creates a new byte array the size of the nonce
	// which must be passed to Seal
	nonce := make([]byte, gcm.NonceSize())
	// populates our nonce with a cryptographically secure
	// random sequence
	if _, err = io.ReadFull(rand.Reader, nonce); err != nil {
		fmt.Println(err)
	}

	// here we encrypt our text using the Seal function
	// Seal encrypts and authenticates plaintext, authenticates the
	// additional data and appends the result to dst, returning the updated
	// slice. The nonce must be NonceSize() bytes long and unique for all
	// time, for a given key.
	fmt.Println(gcm.Seal(nonce, nonce, text, nil))

	//// the WriteFile method returns an error if unsuccessful
	//err = ioutil.WriteFile("myfile", gcm.Seal(nonce, nonce, text, nil), 0777)
	//// handle this error
	//if err != nil {
	//	// print it out
	//	fmt.Println(err)
	//}
}

func convertHexToBytes(hexString *string) ([]uint8, error) {
	// Handle nil pointer case
	if hexString == nil {
		return nil, errors.New("nil pointer provided for hex string")
	}

	// Split the hex string by spaces
	hexBytes := strings.Fields(*hexString)

	// Initialize an empty slice for uint8
	data := make([]uint8, len(hexBytes))

	// Iterate and convert each hex byte
	for i, hexByte := range hexBytes {
		// Convert each hex string to a uint8 value (handling errors)
		value, err := strconv.ParseUint(hexByte, 16, 8)
		if err != nil {
			return nil, fmt.Errorf("error parsing hex byte '%s': %w", hexByte, err)
		}

		// Assign the converted value to the slice
		data[i] = uint8(value)
	}

	// Return the slice of uint8 and any errors encountered
	return data, nil
}

func decrypt(input *request) bool {
	//ciphertext, err := ioutil.ReadFile("myfile")
	ciphertext, err := convertHexToBytes(&input.Prompt)

	// if our program was unable to read the file
	// print out the reason why it can't
	if err != nil {
		fmt.Println(err)
	}

	c, err := aes.NewCipher(key)
	if err != nil {
		fmt.Println(err)
	}

	gcm, err := cipher.NewGCM(c)
	if err != nil {
		fmt.Println(err)
	}

	nonceSize := gcm.NonceSize()
	if len(ciphertext) < nonceSize {
		fmt.Println(err)
	}

	nonce, ciphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		fmt.Println(err)
	}
	s := string(plaintext)
	if validateHash(s) {
		input.Prompt = s
		return true
	}
	input.Prompt = "DATA CORRUPTED OR TAMPERED"
	return false
}

// Validate there's no tampering with SHA-1 sum. The decrypted hash and the transmitted hash should be identical.
func validateHash(decrypted string) bool {
	// Calculate the SHA256 sum of the decrypted request
	hasher := sha1.New()
	hasher.Write([]byte(decrypted))
	decryptedHashString := base64.URLEncoding.EncodeToString(hasher.Sum(nil))

	// TODO: Add error handling if hash doesn't match.
	return decryptedHashString == rawHash
}

// User HTTP GET request has the prompt decrypted and verified with a SHA-1 checksum.
// If there's been no data corruption, re-construct user prompt for ollama
// TODO: Eventually, add additional logic that will allow for re-direction and contextual awareness (pre-processing)
func postRequest(c *gin.Context) {
	var newInput request

	//Call BindJSON to bind the received JSON to
	if err := c.BindJSON(&newInput); err != nil {
		return
	}

	if decrypt(&newInput) {
		requests = append(requests, newInput)
		c.IndentedJSON(http.StatusCreated, newInput) // TODO: Formulate prompt and transfer to AI layer to formulate new JSON response back
	} else {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Failed checksum. Presumably data corrupted."})

	}
}

func main() {
	router := gin.Default()
	router.POST("/prompts", postRequest)

	err := router.Run("localhost:8080")
	if err != nil {
		return
	}
}
