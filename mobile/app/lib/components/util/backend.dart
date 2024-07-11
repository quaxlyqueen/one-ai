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

    // TODO: Further adaption of API calls to allow for images to/from the AI model
    //  Example API call for image recognition
  //   curl http://localhost:11434/api/generate -d '{
  //   "model": "llava",
  //   "prompt":"What is in this picture?",
  //   "stream": false,
  //   "images": ["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"]
  // }'

    Map<String, dynamic> data;

    if(loadedConversation.conversationContext) {
      loadedChats = [...loadedChats, Chat(prompt, true, 0)];
      endpoint = "chat";

      List<Map<String, String>> messageList = convertMessages();

      // Last prompt was text
      if(loadedChats.last.chatType == 0) {
        data = {
          "model": model.name,
          "messages": messageList,
          "stream": loadedConversation.stream,
        };
      // Last prompt was image
      } else { //if (loadedChats.last.chatType == 1) {
        // TODO: Do some wizardry to pipe the output of llava as additional context for the user's actual prompt or something.
        data = {
          "model": "llava",
          "prompt": "What is in this picture?",
          "stream": loadedConversation.stream,
          "images" : [loadedChats.last.content],
        };
      }
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