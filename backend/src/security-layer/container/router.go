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
		return
	}
}

func request(w http.ResponseWriter, r *http.Request) {
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

func serve() {

}

func init() {
	var wg sync.WaitGroup

	r := mux.NewRouter()
	portfolioDir := "/home/violet/documents/development/portfolio/public_html/"
	servePage(r, portfolioDir, "/", 1112)

	srv := &http.Server{
		Addr: "0.0.0.0:1111",
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

	log.Println("Router is running on port 1111")

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

func main() {
	// TODO: Authenticate user credentials to verify they are allowed to even access
	serve()
}
