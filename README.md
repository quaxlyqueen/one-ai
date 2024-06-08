Dependencies:
pip install scipy pydub torch torchaudio wavio silero sounddevice;

Create output.txt file, TODO: Implement error handling.
touch output.txt;

Currently, you have 5 seconds to record a prompt. It will automatically place "in 50 words or less" at the start of your prompt for faster testing. The Text To Speech (TTS) engine is not great quality, at least at first. Just getting the basic structure together, more to come...
