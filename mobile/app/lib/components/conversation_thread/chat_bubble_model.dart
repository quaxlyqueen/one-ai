import 'chat_bubble_widget.dart';
import 'chat.dart';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';


class ChatBubbleModel extends FlutterFlowModel<ChatBubbleWidget>{
  late final Chat c;

  ChatBubbleModel(this.c);

  @override
  void dispose() {} // TODO: Need to implement for prompt/response deletion.

  @override
  void initState(BuildContext context) {} // TODO: Need to implement for loading in media and editing.
}