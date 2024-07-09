import '/components/conversation_thread/conversation_thread_widget.dart';
import '/components/model_item/model_item_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'conversation_widget.dart' show ConversationWidget;
import 'package:flutter/material.dart';

class ConversationModel extends FlutterFlowModel<ConversationWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for ConversationThread component.
  late ConversationThreadModel conversationThreadModel;
  // Model for ModelItem component.
  late ModelItemModel modelItemModel;

  @override
  void initState(BuildContext context) {
    conversationThreadModel = createModel(context, () => ConversationThreadModel()); // TODO
    modelItemModel = createModel(context, () => ModelItemModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    conversationThreadModel.dispose();
    modelItemModel.dispose();
  }
}
