import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/util/speech_to_text.dart';

class Server {
  // TODO: One-time process to establish server connection is required for easy setup/maintenance.
  final url = "http://10.0.2.2:11434";
  final headers = {'Content-Type': 'application/json'};

  final SpeechToText stt = SpeechToText();
  late bool _speechEnabled;

  String prompt = "";
  String response = "";

  Server() {
    // Speech-To-Text engine activation.
    _speechEnabled = stt.isSpeechEnabled();

    // TODO: Initialize all different components of STT, TTS, LLM, etc.
    // TODO: Handshake w/ server to validate identity
  }

  // Using native on-device Speech-To-Text capability, get the server response when ready.
  Future<String> sttGetResponseWhenReady() async {
    // TODO: In case on-device STT is unavailable, use server-side STT service.
    if (!_speechEnabled) "Unable to process Speech-To-Text on-device.";

    setPrompt(stt.getTextWhenReady() as String);
    constructPrompt();
    httpSendRequest();

    return response;
  }

  // Arbitrary prompt, used for standard text interaction rather than STT.
  void setPrompt(String p) => prompt = p;

  // Get the last response or request a response from the server.
  String getResponse() {
    if(response.isEmpty) {
      constructPrompt();
      httpSendRequest();
    }

    return response;
  }

  // Get the latest prompt.
  String getPrompt() => prompt;

  // Formats the prompt in JSON.
  String constructPrompt() {
    // Construct the JSON payload
    final Map<String, dynamic> data = {
      "model":
      "llama3", // TODO: Allow for different models to be dynamically selected.
      "prompt": prompt,
      "stream": false // TODO: Allow for toggleable states between stream
      // TODO: Allow for additional flags, ie. continuous conversation, images, etc.
    };

    // Encode the JSON payload
    final String body = json.encode(data);

    return body;
  }

  // Send the HTTP request to the server.
  void httpSendRequest() async {
    String json = constructPrompt();

    // Send the HTTP POST request
    final serverResponse = await http.post(
      Uri.parse('$url/api/generate'),
      headers: headers,
      body: json,
    );

    if (serverResponse.statusCode == 200) {
      Map<String, dynamic> re = jsonDecode(serverResponse.body);
      response = re["response"]!;
    } else {
      response = ('Error: ${serverResponse.statusCode}');
    }
  }
}
//
//
// // GUI components
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: const Text(
//                 'Recognized words:',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   // If listening is active show the recognized words
//                   _speechToText.isListening
//                       ? prompt
//                   // If listening isn't active but could be tell the user
//                   // how to start it, otherwise indicate that speech
//                   // recognition is not yet ready or not supported on
//                   // the target device
//                       : _speechEnabled
//                       ? responseFromAI
//                       : 'Speech disabled',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//         // If not yet listening for speech start, otherwise stop
//         //sendPrompt,
//         _speechToText.isNotListening ? _startListening : sendPrompt,
//         tooltip: 'Listen',
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
