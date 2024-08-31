package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"sync"
	"time"

	"github.com/gorilla/mux"
  "github.com/spf13/pflag"
  "github.com/spf13/viper"
)

var CONFIG_FILE string
var config ConfigStructure
var chats []Chat

// Interfaces with the internal API to encrypt a message and return it in a
// Communication struct (see types.go). This should be called after a
// response has been received from the internal API for the AI, but before
// sending a HTTP response to the client.
func encryptMessage(response string) Communication {
	encryptedMessage := Communication{}
	msgToEncrypt := Communication{}
	msgToEncrypt.Communication = response
	msgToEncrypt.Hash = ""
	j, err := json.Marshal(msgToEncrypt)
	if err != nil {
		msgToEncrypt.Communication = ""
		return msgToEncrypt
	}
	buf := strings.NewReader(string(j))

	resp, err := http.Post("http://localhost:1113/encrypt", "application/json", buf)
	if err != nil {
		encryptedMessage.Communication = "Error connecting to internal auth API."
		return encryptedMessage
	}
	defer resp.Body.Close()

	// Decode the JSON response into a temporary struct
	var responseData struct {
		Communication string `json:"communication"`
		Hash          string `json:"hash"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		encryptedMessage.Communication = "Error decoding JSON response from internal auth API."
		return encryptedMessage
	}

	// Extract the desired fields and assign them to Communication struct
	encryptedMessage.Communication = responseData.Communication
	encryptedMessage.Hash = responseData.Hash

	return encryptedMessage
}

// Interfaces with the internal API to decrypt a message and return the prompt
// as a string.
// TODO: Allow for additional fields for the client, ie. streaming, model, etc.
func decryptMessage(comm Communication) Communication {
	j, err := json.Marshal(comm)
	if err != nil {
		return Communication{}
	}
	buf := strings.NewReader(string(j))

	resp, err := http.Post("http://localhost:1113/decrypt", "application/json", buf)
	if err != nil {
		return Communication{}
	}
	defer resp.Body.Close()

	// Decode the JSON response into a temporary struct
	var responseData struct {
		Filetype      string `json:"filetype"`
		Communication string `json:"communication"`
		Hash          string `json:"hash"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return Communication{}
	}

	return responseData
}

func sendError(w http.ResponseWriter, msg string) {
	w.WriteHeader(http.StatusBadRequest)
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, msg)
}

func sendResponse(w http.ResponseWriter, encryptedMessage Communication) {
	encryptedResponse, err := json.Marshal(encryptedMessage)
	if err != nil {
		sendError(w, "Error marshalling JSON of encrypted message.")
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, string(encryptedResponse))
}

// User HTTP GET request has the prompt decrypted and verified with a SHA-1 checksum.
// If there's been no data corruption, re-construct user prompt for ollama
// TODO: Eventually, add additional logic that will allow for re-direction and contextual awareness (pre-processing)
func chat(w http.ResponseWriter, r *http.Request) {
		model := "qwen:0.5b" // qwen:0.5b used for testing while hosting from my laptop. llama3 seems to be the best to use normally.

	input, err := io.ReadAll(r.Body)
	if err != nil {
		return
	}

	defer r.Body.Close()
	prompt := Communication{}
	json.Unmarshal(input, &prompt)
	prompt = decryptMessage(prompt)

	// TODO: Add support for dynamically changing models.
	switch prompt.Filetype {
	case "txt":
		model = "qwen:0.5b"
	case "img":
		model = "llava"
	case "doc":
		model = "omniparser"
	}

	newChat := Chat{}
	newChat.Role = true
	newChat.Content = prompt.Communication

	if len(chats) == 0 {
		chats = []Chat{newChat}
	} else {
		chats = append(chats, newChat)
	}

	apiCall := PromptWHistory{}
	apiCall.Model = model
	apiCall.Messages = chats

	// TODO: Allow for this as a user setting...
	apiCall.Stream = false

	j, err := json.Marshal(apiCall)
	buf := strings.NewReader(string(j))

	// Port 11434 corresponds to Ollama. Direct access to Ollama is restricted.
	resp, err := http.Post("http://localhost:11434/api/chat", "application/json", buf)
	if err != nil {
		sendError(w, "Error connecting to local process.")
		return
	}

	output, err := io.ReadAll(resp.Body)
	if err != nil {
		sendError(w, "Error reading local process communication.")
		return
	}
	defer r.Body.Close()

	response := ResponseWHistory{}
	json.Unmarshal(output, &response)
	sendResponse(w, encryptMessage(response.Message.Content))
}

func generate(w http.ResponseWriter, r *http.Request) {
	model := "qwen:0.5b" // qwen:0.5b used for testing while hosting from my laptop. llama3 seems to be the best to use normally.
	input, err := io.ReadAll(r.Body)
	if err != nil {
		sendError(w, "Error reading request.")
		return
	}

	defer r.Body.Close()
	prompt := Communication{}
	err = json.Unmarshal(input, &prompt)
	if err != nil {
		sendError(w, "Error unmarshaling JSON.")
		return
	}

	prompt = decryptMessage(prompt)

	// TODO: Add support for dynamically changing models.
	switch prompt.Filetype {
	case "txt":
		model = "qwen:0.5b"
	case "img":
		model = "llava"
	case "doc":
		model = "omniparser"
	}

	apicall := "{\"model\": \""
	apicall = apicall + model
	apicall = apicall + "\", \"prompt\": \""
	apicall = apicall + prompt.Communication
	apicall = apicall + "\", \"stream\": false }"

	buf := strings.NewReader(apicall)

	resp, err := http.Post("http://localhost:11434/api/generate", "application/json", buf)
	if err != nil {
		sendError(w, "Error connecting to local process.")
		return
	}

	output, err := io.ReadAll(resp.Body)
	if err != nil {
		sendError(w, "Error reading local process communication.")
		return
	}
	defer resp.Body.Close()

	response := Response{}
	err = json.Unmarshal(output, &response)
	if err != nil {
		sendError(w, "Error unmarshaling local process JSON.")
		return
	}
	sendResponse(w, encryptMessage(response.Response))
}

func serve() {
	// TODO: Authenticate user credentials to verify they are allowed to even access
	var wg sync.WaitGroup

	endpoint := []string{
		"/generate",
		"/chat",
	}

	function := []func(http.ResponseWriter, *http.Request){
		generate,
		chat,
	}

	r := mux.NewRouter()
 	//for _, webpage := range config.Webpages {
	//}
  ServePage(r, config.WebpageDir, "/", string(config.WebpagePort))
	ServeApi(r, config.API, endpoint, function, string(config.APIPort))
	ServeAuthentication(r, string(config.AuthPort))
	addr := "0.0.0.0:" + string(config.RouterPort)

	srv := &http.Server{
		Addr: addr,
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

	log.Println("Router is running on port ", config.RouterPort)

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
	// Optionally, you could run srv.Shutdown in a goroutine and block on
	// <-ctx.Done() if your application should wait for other services
	// to finalize based on context cancellation.
	log.Println("shutting down")
	wg.Wait()
	os.Exit(0)
}

func parseCLI() {
  // Define CLI option, shorthand, default value, and description
  // TODO: Dynamically obtain default config location from environment variables.
  pflag.StringP("config", "c", "/home/violet/.config/one-ai/default.json", "Configuration file used in initializing One AI.")
  //pflag.StringP("help", "h", "false", "Display information about using the One AI CLI.")

  pflag.Parse()
  viper.BindPFlags(pflag.CommandLine)

  // Retrieve CLI argument, either the default value or the user provided value.
  CONFIG_FILE = viper.GetString("config")
}

func parseConfig() {
  viper.SetConfigType("json")
  viper.SetConfigFile(CONFIG_FILE)
  viper.ReadInConfig()

  // TODO: Handle error
  viper.Unmarshal(&config)
}

func main() {
  parseCLI()
  parseConfig()
  serve()
}
