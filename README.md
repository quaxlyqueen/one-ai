<h1>One AI</h1>

<h2>Description:</h2>
End-to-end solution for self-deploying a secure and private AI. Ideally, always using the latest and greatest open-source technologies available and optimizing the connection between them.

<h3>Dependencies:</h3>

```
pip install scipy pydub torch torchaudio wavio silero sounddevice;
```

<h3>Usage:</h3>

<p>Currently, you have 5 seconds to record a prompt. It will automatically place "in 50 words or less" at the start of your prompt for faster testing. The Text To Speech (TTS) engine is not great quality, at least at first. Just getting the basic structure together, more to come...</p>

<h3>TODO:</h3>

- [ ] Installation script, preferably need some kind of pipeline to auto-inject dependencies into the install script.
- [ ] Send and receive text files over USB
- [ ] GUI in flutter
