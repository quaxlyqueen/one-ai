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

	"github.com/quaxlyqueen/services"
)

type WebpagesStructure struct {
  Domain          string                `mapstructure:"domain"`
  WebpageDir      string                `mapstructure:"webpage_dir"`
  WebpagePort     string                `mapstructure:"webpage_port"`
}

type ConfigStructure struct {
  TextModel       string                `mapstructure:"text_model"`
  ImageModel      string                `mapstructure:"image_model"`
  VideoModel      string                `mapstructure:"video_model"`
  DocModel        string                `mapstructure:"doc_model"`
  ResponseStream  string                `mapstructure:"response_stream"`

  Domain          string                `mapstructure:"domain"`
  RouterPort      string                `mapstructure:"router_port"`
  API             string                `mapstructure:"api"`
  APIPort         string                `mapstructure:"api_port"`
  Webpages        WebpagesStructure     `mapstructure:"webpages"`
}

var CONFIG_DIR string
var config ConfigStructure
var chats []services.Chat

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
	prompt := services.Communication{}
	json.Unmarshal(input, &prompt)

	newChat := services.Chat{}
	newChat.Role = true
	newChat.Content = prompt.Communication

	if services.decrypt(&prompt, &newChat) {
		chats = append(chats, newChat)

		apiCall := services.PromptWHistory{}
		apiCall.Model = model
		apiCall.Messages = chats
		apiCall.Stream = viper.Get("response_stream") 
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
		response := services.ResponseWHistory{}
		json.Unmarshal(output, &response)
		log.Println(response)

	} else {
		return
	}
}

func generate(w http.ResponseWriter, r *http.Request) {
	input, err := io.ReadAll(r.Body)
	if err != nil {
		return
	}

	defer r.Body.Close()
	prompt := services.Communication{}
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
	response := services.Response{}
	json.Unmarshal(output, &response)

	fmt.Println(response.Response) // Print the body as a string
	// TODO: Encrypt response.Response and send back as a Communication JSON object.
	//c.IndentedJSON(http.StatusCreated, resp)
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
	services.servePage(r, viper.Get("webpage_dir"), "/", viper.Get("webpage_port"))
	services.serveApi(r, viper.Get("api"), endpoint, function, viper.Get("api_port"))
	addr := "0.0.0.0:", viper.Get("router_port")

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

	log.Println("Router is running on port ", viper.Get("router_port"))

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

  pflag.Parse()
  viper.BindPFlags(pflag.CommandLine)

  // Retrieve CLI argument, either the default value or the user provided value.
  CONFIG_DIR = viper.GetString("config")
}

func parseConfig() {
  viper.SetConfigType("json")
  viper.SetConfigFile(CONFIG)
  viper.ReadInConfig()

  err := viper.Unmarshal(&config)
  if err != nil {
  	fmt.Println("error unmarshalling config file")
  	return
  } else {
  	fmt.Println(config)
  }
}

func main() {
  parseCLI()
  parseConfig()
  //serve()
}
