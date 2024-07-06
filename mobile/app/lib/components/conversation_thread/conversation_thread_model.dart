import '/components/conversation_bubbles/conversation_bubbles_widget.dart';
import '/components/prompt_box/prompt_box_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'conversation_thread_widget.dart' show ConversationThreadWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConversationThreadModel
    extends FlutterFlowModel<ConversationThreadWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Model for ConversationBubbles component.
  late ConversationBubblesModel conversationBubblesModel;
  // Model for PromptBox component.
  late PromptBoxModel promptBoxModel;

  @override
  void initState(BuildContext context) {
    conversationBubblesModel =
        createModel(context, () => ConversationBubblesModel());
    promptBoxModel = createModel(context, () => PromptBoxModel());
  }

  @override
  void dispose() {
    conversationBubblesModel.dispose();
    promptBoxModel.dispose();
  }
}
