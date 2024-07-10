import 'package:app/util/backend.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class Conversation with ChangeNotifier {
  int conversationID;
  String conversationLabel;
  String conversationSubLabel;
  bool history = true;
  // History is disabled by default. This means chats are auto-deleted once the user exits that conversation.
  bool conversationContext = true; // The prior prompts and responses are used as additional context for the next prompt and response.
  late bool stream = false; // Update the UI with a stream of characters as received from the server, or as one text.
  List<Chat> chats = [];

  Conversation(this.conversationID, this.conversationLabel, this.conversationSubLabel);

  Conversation.completeConversation(this.conversationID, this.conversationLabel, this.conversationSubLabel, this.chats);

  void toggleHistory() => history = !history;

  void toggleConversationContext() => conversationContext = !conversationContext;

  void toggleStream() => stream = !stream;

  void add(Chat message) {
    chats.add(message);
    notifyListeners();
  }

  void loadChats() {
    Backend.loadConversation;
    chats = Backend.loadedChats;
  }

  void setLabel() {
    // TODO: Need to implement
  }

  void setSubLabel() {
    // TODO: Need to implement
  }

  List<Chat> getChats() {
    return chats;
  }

  void setLabels(String cLabel, String cSubLabel) {
    conversationLabel = cLabel;
    conversationSubLabel = cSubLabel;
  }
}