import 'package:app/components/util/backend.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class Conversation with ChangeNotifier {
  int conversationID;
  String conversationLabel;
  String conversationSubLabel;
  // TODO: Fix history, very, verry strange behavior when disabled.
  bool history = true; // History is disabled by default. This means chats are auto-deleted once the user exits that conversation.\
  bool conversationContext = true; // The prior prompts and responses are used as additional context for the next prompt and response.
  late bool stream = false; // Update the UI with a stream of characters as received from the server, or as one text.
  var lastAccessTime = DateTime.timestamp(); // Used to sort conversations based on most recent usage.

  List<Chat> chats = [];

  Conversation(this.conversationID, this.conversationLabel, this.conversationSubLabel);

  Conversation.completeConversation(this.conversationID, this.conversationLabel, this.conversationSubLabel, this.chats);

  void toggleHistory() => history = !history;

  void toggleConversationContext() => conversationContext = !conversationContext;

  void toggleStream() => stream = !stream;

  void add(Chat message) {
    lastAccessTime = DateTime.timestamp();
    chats.add(message);
    notifyListeners();
  }

  void loadChats() {
    lastAccessTime = DateTime.timestamp();
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
    lastAccessTime = DateTime.timestamp();
    return chats;
  }

  void setLabels(String cLabel, String cSubLabel) {
    lastAccessTime = DateTime.timestamp();
    conversationLabel = cLabel;
    conversationSubLabel = cSubLabel;
  }
}