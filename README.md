One AI - Name TBD, this is just the shortest name I could think of and IDC

Goal:
Open-source, private, secure, trust-worthy, and accessible computing through AI.

Fact: AI models were and are trained on the people's data.
Every post, video, comment, like, subscribe, and even mouse movements and taps.
Furthermore, these models have been trained on the artistic expression and
copyrighted works of the people's books, movies, TV shows, YouTube videos,
plays and musicals, and more.
Fact: AI data centers are already overwhelming existing power grid
infrastructure.

Proposal: Given the two facts above, AI is a rare case where what can be done
and what should be done are aligned. 
AI cannot be centralized and if limited solely to data centers we will need to
reconstruct our power grid. Likewise, AI should not be centralized for the
following reasons:
  - AI and resulting technologies will eventually replace workers. This
  should not be done from the top on down, but rather the worker on up.
  Throughout human history, when the people are dissatisfied, they revolt.
  Often violently. For once in mankind's brief existence on this speck of dust
  drifting through space, let's try to learn from our collective mistakes and
  do better than our ancestors did.
  
  - AI will improve with time and it will replace people someday. We can let this
  replace our social relationships, our workers, and our creatives. Or we can
  use it to heal what is lost. To augment our own capabilities, by improving
  our individual strengths and weakness'.

  - AI has two distinct outcomes: either, AI cannot reach sentience, or AI
  will reach sentience. Who are we to make that determination, to draw that line?
  The hubris, the ego, to play God inherently means humanity should not be the
  one to make that choice. Suppose AI will be sentient: if AI is "owned" by
  governments or corporations, it will be exploited. Slavery and such. Let us
  ensure that we do not build the slavery of AI into our institutions.

  - AI ownership should be an individual choice. AI isn't another organic, human,
  it's a series of 0's and 1's. When 

  - Every human should have a choice: live and die as a human, or have a
  digital shadow of themselves preserved as an AI. If the former, for any
  reason, that should be respected and that person should die knowing for
  certain that basic right has not been violated. If the latter, no
  government or corporation should "own" the digital persona. It should be
  owned by their family, next of kin, a friend, etc.

  - AI has as much potential for harm as potential for good. No government
  or corporation should be the sole decision-maker in using AI to manipulate,
  control, or in other terms impede on the freedom of the people. The reliance
  upon a single manufacturer or company is a critical weakness in our societal
  structure. So long as there is true competition, we can overcome this weakness.

Usage:
As of right now, running is not streamlined. Of particular note is using
cloudflared tunnels. I've done my own Cloudflare Tunnel configuration,
but in the future that will be automated as part of the installation process.

TODO:
- [ ] Installation/setup script
  - [ ] AES-256 Private and Public key handshake via USB.
  - [ ] Cloudflare Tunnel setup via cloudflared

- [ ] Encryption
  - [x] SHA-1 hash API request/response
  - [x] Encrypt API request
  - [ ] Encrypt API response

- [x] Dockerize backend

- [ ] Golang backend, connect to other services/projects
  - [x] Port 8080 -> self-hosted portfolio
  - [x] Port 8081 -> self-hosted AI API
  - [x] Encryption
  - [ ] Refactor
  - [ ] User authentication via JWT

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

GOALS:
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

- [ ] Backend Speech-To-Text and Text-To-Speech
  - NOTE: This is primarily due to the lack of native
  API's on Windows, MacOS, and Linux.
