import 'package:app/util/server.dart';
import 'chat.dart';

class Conversation {
  int conversationID;
  List<Chat> chats = [];

  Conversation(this.conversationID) {
    chats = Server().getConversationByID(conversationID);
  }

  List<Chat> getChats() {
    return chats;
  }
}