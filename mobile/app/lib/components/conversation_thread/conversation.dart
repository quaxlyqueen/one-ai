import 'package:app/util/server.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class Conversation with ChangeNotifier {
  int conversationID;
  String conversationLabel;
  String conversationSubLabel;
  List<Chat> chats = [];

  Conversation(this.conversationID, this.conversationLabel, this.conversationSubLabel);

  Conversation.completeConversation(this.conversationID, this.conversationLabel, this.conversationSubLabel, this.chats);

  void add(Chat message) {
    chats.add(message);
    notifyListeners();
  }

  void loadChats() {
    chats = Backend.getChatsByConversationID(conversationID);
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