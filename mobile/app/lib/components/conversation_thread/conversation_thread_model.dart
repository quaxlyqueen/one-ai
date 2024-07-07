import 'package:app/components/conversation_thread/chat_bubble_model.dart';
import 'package:app/components/conversation_thread/chat.dart';
import 'package:app/components/conversation_thread/conversation.dart';
import 'package:app/util/server.dart';

import 'package:app/components/prompt_box/prompt_box_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'conversation_thread_widget.dart' show ConversationThreadWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ConversationThreadModel extends FlutterFlowModel<ConversationThreadWidget> {
  final formKey = GlobalKey<FormState>();
  late PromptBoxModel promptBoxModel;
  late int ?conversationID;
  late Conversation conversation;

  // If there's a conversation ID, retrieve the conversation history.
  // Otherwise, start a new conversation with user defaults.
  ConversationThreadModel(this.conversationID);

  @override
  void initState(BuildContext context) {
    conversation = Conversation(conversationID!);
    promptBoxModel = createModel(context, () => PromptBoxModel());
  }

  @override
  void dispose() {
    promptBoxModel.dispose();
  }
}
