import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/components/conversation_thread/chat.dart';

import 'package:app/util/speech_to_text.dart';

class Server {
  // TODO: One-time process to establish server connection is required for easy setup/maintenance.
  // Server variables
  final url = "http://10.0.2.2:11434";
  Map<String, String> headers = {'Content-Type': 'application/json'};

  // Model variables
  final SpeechToText stt = SpeechToText();

  // Status variables
  late bool _speechEnabled;
  bool _historyEnabled = true;

  // Context variables
  List<Chat> chats = [
    (Chat("This is just a test. Only reply Yes.", true)),
    (Chat("Yes.", false)),
  ];

  // Runtime variables
  String prompt = "";
  String response = "";
  int conversationID = 0;

  Server() {
    // Speech-To-Text engine activation.
    _speechEnabled = stt.isSpeechEnabled();

    // TODO: Initialize all different components of STT, TTS, LLM, etc.
    // TODO: Handshake w/ server to validate identity
  }

  List<Chat> getConversationByID(conversationID) {
    // TODO: Implement conversation IDs & retrieval from server
    this.conversationID = conversationID;
    return chats;
  }

  // TODO: Integrate with getConversationByID()
  List<Map<String, String>> convertMessages() {
    List<Map<String, String>> messageList = [];
    for (Chat c in chats) {
      messageList.add({
        "role": c.role ? "user" : "assistant",
        "content": c.content,
      });
    }

    return messageList;
  }

  // Using native on-device Speech-To-Text capability, get the server response when ready.
  Future<String> sttGetResponseWhenReady() async {
    // TODO: In case on-device STT is unavailable, use server-side STT service.
    if (!_speechEnabled) "Unable to process Speech-To-Text on-device.";

    setPrompt(stt.getTextWhenReady() as String);
    httpSendRequest();

    return response;
  }

  Future<String> getResponseWhenReady(String p) async {
    prompt = p;
    httpSendRequest();
    return response;
  }

  // Arbitrary prompt, used for standard text interaction rather than STT.
  void setPrompt(String p) => prompt = p;

  // Get the last response or request a response from the server.
  String getResponse() {
      httpSendRequest();
      return response;
  }

  // Get the latest prompt.
  String getPrompt() => prompt;

  // Formats the prompt in JSON.
  String constructPrompt() {
    // TODO: Allow for additional flags, ie. continuous conversation, images, etc.
    // TODO: Allow for toggleable states between stream
    // TODO: Allow for different models to be dynamically selected.
    Map<String, dynamic> data;

    if(_historyEnabled) {
      chats = [...chats, Chat(prompt, true)];

      List<Map<String, String>> messageList = convertMessages();

      data = {
        "model": "llama3",
        "messages": messageList,
        "stream": false,
      };
    }
    else {
      data = {
        "model": "llama3",
        "prompt": prompt,
        "stream": false,
      };
    }

    // Encode the JSON payload
    return json.encode(data);
  }

  // Send the HTTP request to the server.
  void httpSendRequest() async {
    String json = constructPrompt();
    print("\n\n$json\n\n");

    String endpoint = "/api/";
    if(_historyEnabled) endpoint += "chat";
    else endpoint += "generate";

    // Send the HTTP POST request
    final serverResponse = await http.post(
      Uri.parse('$url$endpoint'),
      headers: headers,
      body: json,
    );

    if (serverResponse.statusCode == 200) {
      Map<String, dynamic> re = jsonDecode(serverResponse.body);
      response = re["response"]!;
    } else {
      response = ('Error: ${serverResponse.statusCode}');
    }
    chats.add(Chat(response, false));
  }
}