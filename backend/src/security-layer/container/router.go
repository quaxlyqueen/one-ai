package main

import (
	"context"
	"crypto/aes"
	"crypto/cipher"
	"sync"

	"crypto/rand"
	"crypto/sha1"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"

	"io"
	"log"
	"net/http"

	"os"
	"os/signal"
	"strconv"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/gorilla/mux"
)

type Communication struct {
	Communication string `json:"communication"`
	Hash          string `json:"hash"`
}

type Response struct {
	Model         string `json:"model"`
	CreatedAt     string `json:"created_at"`
	Response      string `json:"response"`
	Done          bool   `json:"done"`
	DoneReason    string `json:"done_reason"`
	Context       []int  `json:"context"`
	TotalDuration int    `json:"total_duration"`
	LoadDuration  int    `json:"load_duration"`
	PromptEC      int    `json:"prompt_eval_count"`
	PromptED      int    `json:"prompt_eval_duration"`
	EvalCount     int    `json:"eval_count"`
	EvalDuration  int    `json:"eval_duration"`
}

// Chats are updated once the content is decrypted. Since this is never leaving
// the server once decrypted, and possibly will not be saved (depending on user
// settings), it will remain decrypted until it's time to transform into a
// Communication JSON object, which is the HTTP response that is re-encrypted.

// TODO: If the user has enabled conversation history, then save the encrypted
// chats to the server's drive. Additionally, only accept incoming additional
// messages from the user, rather than having the client re-send Chats already
// stored on the server.
type Chat struct {
	Role    bool   `json:"role"`
	Content string `json:"content"`
}

type PromptWHistory struct {
	Model    string `json:"model"`
	Messages []Chat `json:"messages"`
	Stream   bool   `json:"stream"`
}

type ResponseWHistory struct {
	Model         string `json:"model"`
	CreatedAt     string `json:"created_at"`
	Message       Chat   `json:"message"`
	Done          bool   `json:"done"`
	DoneReason    string `json:"done_reason"`
	Context       []int  `json:"context"`
	TotalDuration int    `json:"total_duration"`
	LoadDuration  int    `json:"load_duration"`
	PromptEC      int    `json:"prompt_eval_count"`
	PromptED      int    `json:"prompt_eval_duration"`
	EvalCount     int    `json:"eval_count"`
	EvalDuration  int    `json:"eval_duration"`
}

var chats []Chat

// TODO: Test if 256 bit key works.
// TODO: Dynamically get key? Need to research best way to store private keys between two devices.
var key = []byte("passphrasewhichneedstobe32bytes!")

func createToken(username string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256,
			jwt.MapClaims {
			"username": username,
			"exp": time.Now().Add(time.Hour * 24).Unix(),
			})

	jwtToken, err := token.SignedString(key)
	if err != nil {
		return "Error creating JWT.", err
	}
	return jwtToken, nil
}

func verifyToken(tokenString string) error {
   token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
      return secretKey, nil
   })
  
   if err != nil {
      return err
   }
  
   if !token.Valid {
      return fmt.Errorf("invalid token")
   }
  
   return nil
}

func hash(text string) string {
	hasher := sha1.New()
	hasher.Write([]byte(text))
	return base64.URLEncoding.EncodeToString(hasher.Sum(nil))
}

func encrypt() {
	var newCommunication Communication

	text := []byte(newCommunication.Communication)

	c, err := aes.NewCipher(key)
	if err != nil {
		return
		//gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	gcm, err := cipher.NewGCM(c)
	if err != nil {
		return
		//gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err = io.ReadFull(rand.Reader, nonce); err != nil {
		return
		//gc.IndentedJSON(http.StatusBadRequest, gin.H{"message": err})
	}

	var b []byte = gcm.Seal(nonce, nonce, text, nil)
	hex, err := convertBytesToHex(b)
	if err != nil {
		fmt.Println(err)
	}
	var test string = "{data: " + hex + ", hash: " + hash(string(text)) + "}"
	log.Println("encrypted string:" + test)
	//gc.IndentedJSON(http.StatusCreated, gin.H{"message": test})
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

func decrypt(input *Communication, output *Chat) bool {
	// TODO: Add testing flag for easier manipulation.
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
		output.Content = s
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
func request(w http.ResponseWriter, r *http.Request) {
	model := "qwen:0.5b" // qwen:0.5b used for testing while hosting from my laptop. llama3 seems to be the best to use normally.

	input, err := io.ReadAll(r.Body)
	if err != nil {
		return
	}

	defer r.Body.Close()
	prompt := Communication{}
	json.Unmarshal(input, &prompt)

	newChat := Chat{}
	newChat.Role = true
	newChat.Content = prompt.Communication

	if decrypt(&prompt, &newChat) {
		chats = append(chats, newChat)

		apiCall := PromptWHistory{}
		apiCall.Model = model
		apiCall.Messages = chats
		apiCall.Stream = false // TODO: Allow for this as a user setting...
		log.Print("Pre-JSON ification: ")
		log.Println(apiCall)

		j, err := json.Marshal(apiCall)
		buf := strings.NewReader(string(j))
		log.Print("Post-JSON ification: ")
		log.Println(string(j))

		// Port 11434 corresponds to Ollama. Direct access to Ollama is restricted.
		resp, err := http.Post("http://localhost:11434/api/chat", "application/json", buf)
		if err != nil {
			return
		}

		output, err := io.ReadAll(resp.Body)
		if err != nil {
			return
		}

		defer r.Body.Close()
		response := ResponseWHistory{}
		json.Unmarshal(output, &response)

		log.Println(response)

	} else {
		http.Error(w, "Decryption/Hash failed.", 401)
		return
	}
}

func chat(w http.ResponseWriter, r *http.Request) {
	input, err := io.ReadAll(r.Body)
	if err != nil {
		return
	}

	defer r.Body.Close()
	prompt := Communication{}
	json.Unmarshal(input, &prompt)

	// TODO: Add support for dynamically changing models.
	model := "qwen:0.5b" // qwen:0.5b used for testing while hosting from my laptop. llama3 seems to be the best to use normally.

	apicall := "{\"model\": \""
	apicall = apicall + model
	apicall = apicall + "\", \"prompt\": \""
	apicall = apicall + prompt.Communication
	apicall = apicall + "\", \"stream\": false }"

	buf := strings.NewReader(apicall)

	// Port 11434 corresponds to Ollama. Direct access to Ollama is restricted.
	resp, err := http.Post("http://localhost:11434/api/generate", "application/json", buf)
	if err != nil {
		return
	}

	output, err := io.ReadAll(resp.Body)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	defer r.Body.Close()
	response := Response{}
	json.Unmarshal(output, &response)

	fmt.Println(response.Response) // Print the body as a string
	// TODO: Encrypt response.Response and send back as a Communication JSON object.
	//c.IndentedJSON(http.StatusCreated, resp)
}

func main() {
	var wg sync.WaitGroup

	r := mux.NewRouter()
	portfolioDir := "/Users/ashton/Documents/Development/portfolio/public_html/" // MacBook dir
	//portfolioDir := "/home/violet/documents/development/portfolio/public_html/" // ThinkPad dir
	r.PathPrefix("/").Handler(http.FileServer(http.Dir(portfolioDir)))

	srv := &http.Server{
		Addr: "0.0.0.0:8080",
		// Good practice to set timeouts to avoid Slowloris attacks.
		WriteTimeout: time.Second * 15,
		ReadTimeout:  time.Second * 15,
		IdleTimeout:  time.Second * 60,
		Handler:      r, // Pass our instance of gorilla/mux in.
	}

	// Run our server in a goroutine so that it doesn't block.
	wg.Add(1)
	go func() {
		defer wg.Done()
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Println(err)
		}
	}()

	log.Println("Portfolio server is running on port 8080")

	// Routing for AI web app and API
	apiR := r.Host("ai.joshashton.dev").Subrouter()
	apiR.HandleFunc("/request", chat)
	apiR.PathPrefix("/").Handler(http.FileServer(http.Dir("/home/violet/templates/construction/")))

	apiSrv := &http.Server{
		Addr: "0.0.0.0:8081",
		// Good practice to set timeouts to avoid Slowloris attacks.
		WriteTimeout: time.Second * 15,
		ReadTimeout:  time.Second * 15,
		IdleTimeout:  time.Second * 60,
		Handler:      apiR, // Pass our instance of gorilla/mux in.
	}

	// Run our server in a goroutine so that it doesn't block.
	wg.Add(1)
	go func() {
		defer wg.Done()
		if err := apiSrv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Println(err)
		}
	}()

	log.Println("API server is running on port 8081")

	c := make(chan os.Signal, 1)
	// We'll accept graceful shutdowns when quit via SIGINT (Ctrl+Shift+C)
	signal.Notify(c, os.Interrupt)

	// Block until we receive our signal.
	<-c

	// Create a deadline to wait for.
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(30))
	defer cancel()
	// Doesn't block if no connections, but will otherwise wait
	// until the timeout deadline.
	srv.Shutdown(ctx)
	apiSrv.Shutdown(ctx)
	// Optionally, you could run srv.Shutdown in a goroutine and block on
	// <-ctx.Done() if your application should wait for other services
	// to finalize based on context cancellation.
	log.Println("shutting down")
	wg.Wait()
	os.Exit(0)
}
