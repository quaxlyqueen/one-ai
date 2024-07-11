import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

/// Handles standard Speech-To-Text using on-device processing.
class SpeechToText {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  // TODO: User customizable STT??
  final SpeechListenOptions options = stt.SpeechListenOptions(
    partialResults: true,
    onDevice: true,
  );

  bool speechEnabled = false;
  String text = "";

  // Check if speech recognition is enabled.
  bool isSpeechEnabled() => speechEnabled;

  Future<String> getTextWhenReady() async {
    await speechToText.stop();
    return text;
  }

  // Retrieve the text.
  @Deprecated("TODO: Deprecated message for speechToText.getText")
  String getText() => text;

  // Reset either after saving the text or prior to using STT again.
  void reset() => text = "";

  /// Start a speech recognition session
  void startListening() async {
    await speechToText.listen(
      onResult: onSpeechResult,
      pauseFor: const Duration(seconds: 3),

      // TODO: I think this is a bug with the speech_to_text library? The docs correctly identify the named parameter of SpeechListenOptions, but it's not recognized.
      // SpeechListenOptions: options,
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async => await speechToText.stop();

  SpeechToText() {
    initSpeech();
  }

  /// This has to happen only once per app
  void initSpeech() async => speechEnabled = await speechToText.initialize();

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) => (text = result.recognizedWords);
}