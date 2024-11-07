One AI - Name TBD, this is just the shortest name I could think of.
Also, user beware, this project is scuffed. Very early WIP.

INSTALLATION:

1. Install and configure dependencies. On Arch Linux, run the following:
    ```
    # Install dependencies
    sudo pacman -S ollama go cloudflared docker
    yay -S flutter-bin
    
    # Configure ollama
    ollama pull llama3
    #ollama pull qwen:0.5b # Use this if hosting on older hardware.

    # Configure cloudflared
    cloudflared tunnel login

    # Configure Docker
    systemctl start docker
    #systemctl enable docker

    ```

2. Run the installation script. This will create, configure, and start the
   Cloudflare Tunnel via cloudflared and create the initial configuration
   file for One AI;

3. Start the server via Docker or plain Golang:
   a) Go to ./backend/src/security-layer/ and run `./init`.
        
   b) Go to ./backend/src/security-layer/container and run `go run router.go`.

   By default, this will expose 4 ports: the router at port 1111, the API on
   1112, Auth/Session Management on 1113, and a static webpage on 1114. The
   ports and webpage directory are configurable through
   `~/.config/one-ai/test.json`.
   
CONFIGURATION:

The primary configuration file is located at `~/.config/one-ai/`. It is 
recommended to keep two files, `test.json` and `live.json`. This is purely
for security purposes.

The following are configurable parameters:<br>
    - `text_model`: Specify the LLM used through Ollama, eg. "llama3".<br>
    - `response_stream`: `true` or `false`, to receive communication as it is
    generated or once it is completed generating.<br>
    - `domain`: The URL to be used to access the router.<br>
    - `router_port`: The port to be exposed to the internet.<br>
    - `api`: The URL to be used to access the One AI API.<br>
    - `api_port`: A port to be only accessible to the localhost.<br>
    - `auth_port`: A port to be only accessible to the localhost.<br>
    - `webpage_dir`: The directory containing a website.<br>
    - `webpage_port`: The port to expose the webpage directory to the internet.<br>

TODO:
  Urgent:
  - [x] Basic Documentation

  - [ ] Installation/setup script
    - [ ] AES-256 Private and Public key handshake via USB.
    - [ ] Cloudflare Tunnel setup via cloudflared
    - [ ] Daemonize service

  - [x] Encryption
    - [x] SHA-1 hash API request/response
    - [x] Encrypt API request
    - [x] Encrypt API response


  - [x] Dockerize backend
    - [x] Broke Dockerfile, need to expose additional ports.
    - [ ] Dynamically expose ports based on primary configuration file.

  - [ ] Golang backend, connect to other services/projects
    - [x] Port 8080 -> self-hosted portfolio
    - [x] Port 8081 -> self-hosted AI API
    - [x] Encryption
    - [ ] User authentication via JWT

  - [ ] Refactor

  - [ ] Testing

  - [ ] Connect Flutter Web App to server

  Later:
  - [ ] Raspberry Pi nightly package

  - [ ] Image support via llava
    - [x] Encode images to Base64 in frontend
    - [ ] Redirect prompts to appropriate model.
    - [ ] Image generation via llava, encode to Base64

  - [ ] GUI in Flutter
    - [x] Conversations list
    - [x] Conversation view
    - [ ] Settings
    - [x] File picker
    - [x] Image picker
    - [x] Camera
    - [x] On-device Speech to Text
    - [x] On-device Text to Speech

  router.go:
  - [ ] Allow for additional fields for the client.
  - [ ] Add preprocessing based upon filetypes.
  - [ ] Add support for dynamically changing models.
  - [ ] Actually make text streaming a toggleable setting.
  - [ ] Authentication via JWT.
  - [ ] Get config via CLI argument or environment variable.
  - [ ] Add --test CLI argument when testing solely on localhost.
  - [ ] Error handling, testing, & documentation.

  authentication.go:
  - [ ] 32 bit key generation & storage between server and client
  - [ ] Add testing flag
  - [ ] Error handling, testing, & documentation.

  serveAPI.go:
  - [ ] Error handling, testing, & documentation.

  servePage.go:
  - [ ] Error handling, testing, & documentation.

  Much Later:
  - [ ] Document support via OmniParser
    - [ ] Encode files to Base64 to/from backend.
    - [ ] Connect to external services like Google Drive

  - [ ] Context support
    - [ ] Access self-hosted or cloud calendar
    - [ ] Access self-hosted or cloud todo
    - [ ] Access self-hosted or cloud notes/docs
    - [ ] Access self-hosted or cloud photos/videos

  - [ ] User settings
    - [ ] Especially conversation history.
    - [ ] Choose default models
    - [ ] Connect to external API services

  - [ ] Convert API from REST to WebSocket architecture.
    - NOTE: This is to allow for the text streaming effect,
    but also audio, video, and for reducing bandwidth.

  - [ ] Backend Speech-To-Text and Text-To-Speech
    - NOTE: This is primarily due to the lack of native
    API's on Windows, MacOS, and Linux.

  - [ ] Update physical backend server to NixOS.

Way later:
- [ ] External hardware integration -> see personal notes

This project has been built, structured, architected, etc. in conjunction
with AI, specifically the llama3 and qwen2 models.
