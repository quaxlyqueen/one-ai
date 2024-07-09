import 'dart:convert';
import 'package:app/components/conversation_thread/conversation.dart';
import 'package:http/http.dart' as http;

import 'package:app/components/conversation_thread/chat.dart';

import 'package:app/util/speech_to_text.dart';

// Uses Singleton design pattern to ensure that any server references across the app are using the same instance.
class Server {
  //     SERVER VARIABLES
  static final Server _single_server = Server._internal();
  Server._internal();
  // TODO: One-time process to establish server connection is required for easy setup/maintenance.
  static final url = "http://10.0.2.2:11434/api/"; // For emulated device in testing
  //static final url = "http://192.168.1.68:11434/api"; // For local access to home server
  static String endpoint = "";
  static final Map<String, String> headers = {'Content-Type': 'application/json'};



  //     AI VARIABLES
  static final SpeechToText stt = SpeechToText();
  static late bool _speechEnabled;



  //     PRIVACY VARIABLES
  static bool _historyEnabled = true;
  static late int conversationID;
  static List<Conversation> conversations = [];
  static List<Chat> loadedChats = [];



  //     RUNTIME & STATUS VARIABLES
  static String prompt = "";
  static String response = "";
  static bool initiated = false;

  // TODO: Verify all different components of STT, TTS, LLM, etc have been initialized.
  // TODO: Handshake w/ server to validate identity
  factory Server() {
    // Speech-To-Text engine activation.
    _speechEnabled = stt.isSpeechEnabled();

    // loadedChats = conversations[conversationID].chats;

    return _single_server;
  }

  void init() {
    initiated = true;

    // TODO: Dynamically obtain conversations.
    conversations.add(
      Conversation.completeConversation(
        0,
        "Test Conversation",
        "Testing Functionality",
        [
          (Chat("Hello there! You are part of a prototype and are running locally on my Macbook Air. Please keep your responses brief as every prompt freezes my computer.", true)),
          (Chat("Understood! How can I help?", false)),
        ]
      )
    );

    // conversations.add(
    //     Conversation.completeConversation(
    //         1,
    //         "Label test",
    //         "Sub-label Test",
    //         [
    //           (Chat("A different test. Only reply No.", true)),
    //           (Chat("No.", false)),
    //         ]
    //     )
    // );
  }



  //     PRIMARY INTERFACE
  static Future<String> sttGetResponseWhenReady() async {
    // TODO: In case on-device STT is unavailable, use server-side STT service.
    if (!_speechEnabled) "Unable to process Speech-To-Text on-device.";

    prompt = stt.getTextWhenReady() as String;
    conversations[conversationID].add(Chat(prompt, true));
    httpSendRequest();
    conversations[conversationID].add(Chat(response, false));

    return response;
  }

  static void respondWhenReady(String p) async {
    prompt = p;
    conversations[conversationID].add(Chat(prompt, true));
    httpSendRequest();
  }



  //     CONVERSATION MANAGEMENT
  static List<Conversation> getConversationsList() { return conversations; }

  static Conversation getLoadedConversation() { return conversations[conversationID]; }

  // Load conversation should be called prior to any other server requests.
  static void loadConversation(id) {
    conversationID = id;
    loadedChats = conversations[conversationID].chats;
  }

  static List<Chat> getChatsByConversationID(id) { return conversations[id].chats; }



  //     SERVER UTILS
  static List<Map<String, String>> convertMessages() {
    // TODO: Integrate with getConversationByID()
    List<Map<String, String>> messageList = [];
    for (Chat c in loadedChats) {
      messageList.add({
        "role": c.role ? "user" : "assistant",
        "content": c.content,
      });
    }

    return messageList;
  }

  // Formats the prompt in JSON.
  static String constructPrompt() {
    // TODO: Allow for additional flags, ie. continuous conversation, images, etc.
    // TODO: Allow for toggleable states between stream
    // TODO: Allow for different models to be dynamically selected.
    Map<String, dynamic> data;

    if(_historyEnabled) {
      loadedChats = [...loadedChats, Chat(prompt, true)];
      endpoint = "chat";

      List<Map<String, String>> messageList = convertMessages();

      data = {
        "model": "llama3",
        "messages": messageList,
        "stream": false,
      };
    }
    else {
      endpoint = "generate";
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
  static void httpSendRequest() async {
    String json = constructPrompt();

    // Send the HTTP POST request
    final serverResponse = await http.post(
      Uri.parse('$url$endpoint'),
      headers: headers,
      body: json,
    );

    if (serverResponse.statusCode == 200) {
      Map<String, dynamic> re = jsonDecode(serverResponse.body);
      if(_historyEnabled) {
        response = re["message"]["content"];
        loadedChats = [...loadedChats, Chat(response, false)];
      } else {
        response = re["response"];
      }
    }
    conversations[conversationID].add(Chat(response, false));

    prompt = "";
    response = "";
  }
}