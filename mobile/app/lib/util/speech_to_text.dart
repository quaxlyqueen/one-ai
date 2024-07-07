import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Handles standard Speech-To-Text using on-device processing.
class SpeechToText {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  String text = "";

  // Check if speech recognition is enabled.
  bool isSpeechEnabled() => _speechEnabled;

  Future<String> getTextWhenReady() async {
    await _speechToText.stop();
    return text;
  }

  // Retrieve the text.
  String getText() => text;

  // Reset either after saving the text or prior to using STT again.
  void reset() => text = "";

  /// Start a speech recognition session
  void _startListening() async => await _speechToText.listen(onResult: _onSpeechResult);

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async => await _speechToText.stop();

  SpeechToText() {
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async => _speechEnabled = await _speechToText.initialize();

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) => text = result.recognizedWords;
}