import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'conversations_list_widget.dart' show ConversationsListWidget;
import 'package:flutter/material.dart';

class ConversationsListModel extends FlutterFlowModel<ConversationsListWidget> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
