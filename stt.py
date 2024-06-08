# import required libraries
from glob import glob
from scipy.io.wavfile import write
from pydub import AudioSegment
from pydub.playback import play

import os
import torch
import zipfile
import torchaudio
import sounddevice as sd
import wave
import wavio as wv

########### Record audio
def record_audio(audio, duration=5, freq=192000):
    # Start recorder with the given values of duration and sample frequency
    recording = sd.rec(int(duration * freq), samplerate=freq, channels=2)

    print('Please say your prompt. You have ' + str(duration) + ' seconds.')
    # Record audio for the given number of seconds
    sd.wait()

    # This will convert the NumPy array to an audio file with the given sampling frequency
    write(audio, freq, recording)

def speech_to_text(audio):
    device = torch.device('cuda')  # cuda also works, but our models are fast enough for CPU
    model, decoder, utils = torch.hub.load(repo_or_dir='snakers4/silero-models', model='silero_stt', language='en', device=device)
    (read_batch, split_into_batches, read_audio, prepare_model_input) = utils  # see function signature for details

    test_files = glob(audio)
    batches = split_into_batches(test_files, batch_size=100)
    input = prepare_model_input(read_batch(batches[0]), device=device)

    text = ""
    output = model(input)
    for example in output:
        text += decoder(example.cpu())

    return text

def text_to_speech():
    language = 'en'
    model_id = 'v3_en'
    sample_rate = 8000
    speaker = 'en_1'
    device = torch.device('cuda')

    model, example_text = torch.hub.load(repo_or_dir='snakers4/silero-models', model='silero_tts', language=language, speaker=model_id)
    model.to(device)  # cuda or cpu

    text = open("output.txt").read()
    audio = model.apply_tts(text, speaker=speaker, sample_rate=sample_rate)
    torchaudio.save("output.mp3", audio.unsqueeze(0), sample_rate=8000)

    song = AudioSegment.from_mp3("output.mp3")
    play(song)

def main():
    audio = "input.wav"
    record_audio(audio)
    prompt = "in 50 words or less, " +  speech_to_text(audio)
    print(prompt)

    command = "ollama run llama3 " + prompt + " > output.txt"
    os.system(command)
    text_to_speech()


if __name__ == "__main__":
    main()
