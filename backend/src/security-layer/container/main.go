package main

import (
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"io"
	"net/http"

	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha1"

	"errors"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

type Communication struct {
	Communication string `json:"communication"`
	Hash          string `json:"hash"`
}

var requests []Communication

// TODO: Test if 256 bit key works.
// TODO: Dynamically get key? Need to research best way to store private keys between two devices.
var key = []byte("passphrasewhichneedstobe32bytes!")

func hash(text string) string {
	hasher := sha1.New()
	hasher.Write([]byte(text))
	return base64.URLEncoding.EncodeToString(hasher.Sum(nil))
}

func encrypt(gc *gin.Context) {
	var newCommunication Communication
	if err := gc.BindJSON(&newCommunication); err != nil {
		gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
		return
	}

	text := []byte(newCommunication.Communication)

	c, err := aes.NewCipher(key)
	if err != nil {
		gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	gcm, err := cipher.NewGCM(c)
	if err != nil {
		gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err = io.ReadFull(rand.Reader, nonce); err != nil {
		gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	var b []byte = gcm.Seal(nonce, nonce, text, nil)
	hex, err := convertBytesToHex(b)
	if(err != nil) {
		fmt.Println(err)
	}
	var test string = "{data: " + hex + ", hash: " + hash(string(text)) + "}"

	gc.IndentedJSON(http.StatusCreated, gin.H{"message": test})
}

func convertBytesToHex(b []byte) (string, error) {
	// Handle nil pointer case
	if b == nil {
		return "", errors.New("nil pointer provided for hex string")
	}

	// Split the hex string by spaces
	var h string = hex.EncodeToString(b)
	var builder strings.Builder
  for i := 0; i < len(h); i += 2 {
  	end := i + 2
    if end > len(h) {
        end = len(h)
    }
    chunk := h[i:end]
    builder.WriteString(chunk)
    if end < len(h) {
        builder.WriteString(" ")
    }
	}

	// Return the slice of uint8 and any errors encountered
	return builder.String(), nil
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

func decrypt(input *Communication) bool {
	//ciphertext, err := ioutil.ReadFile("myfile")
	ciphertext, err := convertHexToBytes(&input.Communication)

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
	if validateHash(s, input.Hash) {
		input.Communication = s
		return true
	}
	input.Communication = "DATA CORRUPTED OR TAMPERED"
	return false
}

// Validate there's no tampering with SHA-1 sum. The decrypted hash and the transmitted hash should be identical.
func validateHash(decrypted string, hash string) bool {
	// Calculate the SHA256 sum of the decrypted request
	hasher := sha1.New()
	hasher.Write([]byte(decrypted))
	decryptedHashString := base64.URLEncoding.EncodeToString(hasher.Sum(nil))

	// TODO: Add error handling if hash doesn't match.
	return decryptedHashString == hash
}

// User HTTP GET request has the prompt decrypted and verified with a SHA-1 checksum.
// If there's been no data corruption, re-construct user prompt for ollama
// TODO: Eventually, add additional logic that will allow for re-direction and contextual awareness (pre-processing)
func request(c *gin.Context) {
	var newInput Communication

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
	router.POST("/request", request)
	router.POST("/encrypt", encrypt)

	err := router.Run("0.0.0.0:8000")
	if err != nil {
		return
	}
}
