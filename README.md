<<<<<<< HEAD
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

The following are configurable parameters:
    - `text_model`: Specify the LLM used through Ollama, eg. "llama3".
    - `response_stream`: `true` or `false`, to receive communication as it is
    generated or once it is completed generating.
    - `domain`: The URL to be used to access the router.
    - `router_port`: The port to be exposed to the internet.
    - `api`: The URL to be used to access the One AI API.
    - `api_port`: A port to be only accessible to the localhost.
    - `auth_port`: A port to be only accessible to the localhost.
    - `webpage_dir`: The directory containing a website.
    - `webpage_port`: The port to expose the webpage directory to the internet.

TODO:
  - [x] Basic Documentation

  - [x] Installation/setup script
    - [ ] AES-256 Private and Public key handshake via USB.
    - [x] Cloudflare Tunnel setup via cloudflared
=======
One AI - Name TBD, this is just the shortest name I could think of and IDRC

Usage:
As of right now, running is not streamlined. Of particular note is using
cloudflared tunnels. I've done my own Cloudflare Tunnel configuration,
but in the future that will be automated as part of the installation process,
along with much more. These instructions are (currently) only for Linux.
In the meantime:

1. Install dependencies listed below:
      - ollama,
      - go,
      - cloudflared,
      - flutter,

      - docker, (optional)

    eg. `pacman -S ollama go docker cloudflared; yay -s flutter;`

2. Setup Ollama. If you're on a laptop (non-gaming variety), run `ollama pull
   qwen:0.5b`. If you're running this on something with a beefy GPU, run
   `ollama pull llama3`. Word of warning, qwen is really dumb, but it's light.
   it tried to convince me there were 12 letters in the alphabet.

3. Start the web server via Docker or plain Golang:
   a) Go to ./backend/src/security-layer/ and run `./init`. The exact script is
      within the repository, but the commands can be ran as follows:
        
        ```
        #!/bin/zsh
        # Force delete the old container and re-initialize the container.
        sudo docker rm -f security-layer

        # Build the Docker image.
        sudo docker build --tag security-layer:latest .

        # Create a Docker container from the image and connect host port 8000 to container port 8000.
        sudo docker run --name security-layer -d -p 8000:8000 security-layer:latest
        ```

   b) Go to ./backend/src/security-layer/container and run `go run router.go`.
   
4. Edit ~/.cloudflared/config.yml to to indicate something along these lines:
      ```
      tunnel: another-long-weird-hash
      credentials-file: /home/username/.cloudflared/another-long-weird-hash.json
      ingress:
        - hostname: somedomain.cloudflare.com
          service: http://localhost:8080
      ```

5. Start the Cloudflare Tunnel on the host/server machine. For Linux, it should
   be a command like `sudo cloudflared service install areallylonghash@sha-256?`

TODO:
  Urgent:
  - [x] Basic Documentation

  - [ ] Installation/setup script
    - [ ] AES-256 Private and Public key handshake via USB.
    - [ ] Cloudflare Tunnel setup via cloudflared
>>>>>>> 8e9b82829bebbb9a096236b505c2e8a17b8a9403
    - [ ] Daemonize service

  - [x] Encryption
    - [x] SHA-1 hash API request/response
    - [x] Encrypt API request
    - [x] Encrypt API response

<<<<<<< HEAD
  - [x] Dockerize backend
    - [x] Broke Dockerfile, need to expose additional ports.
    - [ ] Dynamically expose ports based on primary configuration file.
=======
  - [ ] Dockerize backend
    - [ ] Broke Dockerfile, need to expose additional ports.
>>>>>>> 8e9b82829bebbb9a096236b505c2e8a17b8a9403

  - [ ] Golang backend, connect to other services/projects
    - [x] Port 8080 -> self-hosted portfolio
    - [x] Port 8081 -> self-hosted AI API
    - [x] Encryption
    - [ ] User authentication via JWT

  - [ ] Refactor

  - [ ] Testing

  - [ ] Connect Flutter Web App to server

<<<<<<< HEAD
  Later:
=======
  Soon:
>>>>>>> 8e9b82829bebbb9a096236b505c2e8a17b8a9403
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

<<<<<<< HEAD
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
=======
  Later:
>>>>>>> 8e9b82829bebbb9a096236b505c2e8a17b8a9403
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
