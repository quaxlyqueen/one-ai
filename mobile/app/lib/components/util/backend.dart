import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:app/components/conversation_thread/conversation.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

import 'package:app/components/conversation_thread/chat.dart';

import 'package:app/components/util/speech_to_text.dart';

import 'model.dart';

// Uses Singleton design pattern to ensure that any server references across the app are using the same instance.
class Backend {
  //     SERVER VARIABLES
  static final Backend singleBackend = Backend._internal();
  Backend._internal();
  // TODO: One-time process to establish server connection is required for easy setup/maintenance.
  static const url = "http://10.0.2.2:11434/api/"; // For emulated device in testing
  //static final url = "http://192.168.1.68:11434/api"; // For local access to home server
  static String endpoint = "";
  static final Map<String, String> headers = {'Content-Type': 'application/json'};
  static final bool UI_TESTING = true;



  //     AI VARIABLES
  static final SpeechToText stt = SpeechToText();
  static late bool _speechEnabled;



  //     PRIVACY-NECESSARY VARIABLES
  // TODO: Reorder based on most recent usage.
  static List<Conversation> conversations = [];
  static List<Chat> loadedChats = [];
  static late Conversation loadedConversation;
  static late List<CameraDescription> cameras;
  static late CameraController controller;


  //     RUNTIME & STATUS VARIABLES
  static late int conversationID;
  static late int maxConversationID;
  static late Model model;
  static String prompt = "";
  static String response = "";
  static bool initiated = false;

  // TODO: Verify all different components of STT, TTS, LLM, etc have been initialized.
  // TODO: Handshake w/ server to validate identity
  factory Backend() {


    return singleBackend;
  }

  void init() async {
    // Prevent multiple initiations
    if(!initiated) {
      initiated = true;
      // Speech-To-Text engine activation.
      _speechEnabled = stt.isSpeechEnabled();

      model = Model("llama3"); // Primarily used llama3, testing gemma2
      maxConversationID = conversations.length;

      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize(); // TODO: Add error catching on camera
    }

    // TODO: Dynamically get available models and models that can be pulled.
    // TODO: Dynamically get the user's default model
    // TODO: Dynamically obtain conversations.
    // TODO: Obtain all user permissions at once.
  }



  //     PRIMARY INTERFACES
  @Deprecated("Use STT interface directly and use respondWhenReady().")
  static Future<String> sttGetResponseWhenReady() async {
    // TODO: In case on-device STT is unavailable, use server-side STT service.
    if (!_speechEnabled) {
      return "Unable to process Speech-To-Text on-device.";
    }

    prompt = stt.getTextWhenReady() as String;
    conversations[conversationID].add(Chat(prompt, true, 0));
    if(!UI_TESTING) {
      httpSendRequest();
    }
    conversations[conversationID].add(Chat(response, false, 0));

    return response;
  }

  static void respondWhenReady(String p) async {
    prompt = p;
    conversations[conversationID].add(Chat(prompt, true, 0));
    if(!UI_TESTING) {
      httpSendRequest();
    }
  }

  static ImageProvider convertFromBase64(img) {
    Uint8List imageBytes = base64Decode(img);

    return Image.memory(imageBytes).image;
  }

  // Converts image to base64 encoded string for data transfer.
  static String convertToBase64(f)  {
    List<int> imageBytes = f.readAsBytesSync();
    String img = base64Encode(imageBytes);

    // TODO: Add special handling for images included in prompts.
    conversations[conversationID].add(Chat.image(img, true, 1));
    return img;
  }


  //     CONVERSATION MANAGEMENT
  @Deprecated("")
  static List<Conversation> getConversationsList() { return conversations; }

  static Conversation getLoadedConversation() { return loadedConversation; }

  // Load conversation should be called prior to any other server requests.
  static void loadConversation(id) {
    conversationID = id;

    loadedConversation = conversations[id];
    loadedChats = loadedConversation.chats;
  }

  // TODO: Better conversation ID management is needed. Preferably randomized IDs to not indicate the number of conversations.
  static int createConversation() {
    int id = conversations.length;
    conversations.add(Conversation(id, "Conversation $id", "Another AI conversation"));
    return id;
  }

  static void deleteConversation(id) {
    loadedChats = conversations[conversationID].chats; // TODO: Temporarily saving the chats for "undo" popup.
    conversations.removeAt(id);
  }

  @Deprecated('Just directly get loadedChats list. Unless multiple chats can be opened simultaneously?')
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

    if(conversations[conversationID].conversationContext) {
      loadedChats = [...loadedChats, Chat(prompt, true, 0)];
      endpoint = "chat";

      List<Map<String, String>> messageList = convertMessages();

      data = {
        "model": model.name,
        "messages": messageList,
        "stream": loadedConversation.stream,
      };
    }
    else {
      endpoint = "generate";
      data = {
        "model": model.name,
        "prompt": prompt,
        "stream": loadedConversation.stream,
      };
    }

    // Encode the JSON payload
    return json.encode(data);
  }

  // Send the HTTP request to the server.
  static void httpSendRequest() async {
    // TODO: Add AES256 encryption to the prompt/messages thread.
    // TODO: Add SHA256 checksum to be sent and verified to prevent/notify in case of data loss.
    String json = constructPrompt();

    // Send the HTTP POST request
    final serverResponse = await http.post(
      Uri.parse('$url$endpoint'),
      headers: headers,
      body: json,
    );

    if (serverResponse.statusCode == 200) {
      Map<String, dynamic> re = jsonDecode(serverResponse.body);
      if(conversations[conversationID].conversationContext) {
        response = re["message"]["content"];
        // TODO: Modify in case of different response types.
        loadedChats = [...loadedChats, Chat(response, false, 0)];
      } else {
        response = re["response"];
      }
    }
    conversations[conversationID].add(Chat(response, false, 0));

    prompt = "";
    response = "";
  }
}