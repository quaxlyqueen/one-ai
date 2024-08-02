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
    - [ ] Daemonize service

  - [x] Encryption
    - [x] SHA-1 hash API request/response
    - [x] Encrypt API request
    - [x] Encrypt API response

  - [ ] Dockerize backend
    - [ ] Broke Dockerfile, need to expose additional ports.

  - [ ] Golang backend, connect to other services/projects
    - [x] Port 8080 -> self-hosted portfolio
    - [x] Port 8081 -> self-hosted AI API
    - [x] Encryption
    - [ ] User authentication via JWT

  - [ ] Refactor

  - [ ] Testing

  - [ ] Connect Flutter Web App to server

  Soon:
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

  Later:
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
