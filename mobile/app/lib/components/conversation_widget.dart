import 'package:app/components/conversation_thread/conversation.dart';

import '/components/conversation_details_overlay/conversation_details_overlay_widget.dart';
import '/components/conversation_thread/conversation_thread_widget.dart';
import '/components/model_item/model_item_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/theme.dart';

import '../components/conversation_model.dart';
export '../components/conversation_model.dart';

class ConversationWidget extends StatefulWidget {
  final Conversation conversation;
  const ConversationWidget({super.key, required this.conversation});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState(conversation);
}

class _ConversationWidgetState extends State<ConversationWidget> {
  late ConversationModel _model;
  Conversation conversation;

  _ConversationWidgetState(this.conversation);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationModel(conversation));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppTheme.secondaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBackground,
          automaticallyImplyLeading: false,
          // ---------- Back Button
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.lightest,
              size: 30,
            ),
            onPressed: () async {
              // TODO: Smooth out the animation to prevent the conversations list from loading half-way up the screen.
              // Note: that only applies if the input was already selected.
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              Navigator.pop(context);
            },
          ),
          title: wrapWithModel(
            model: _model.modelItemModel,
            updateCallback: () => setState(() {}),
            child: ModelItemWidget(conversation: conversation,),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 16, 8),
              // ---------- Options Button
              child: FlutterFlowIconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.lightest,
                  size: 24,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => _model.unfocusNode.canRequestFocus
                            ? FocusScope.of(context)
                                .requestFocus(_model.unfocusNode)
                            : FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const ConversationDetailsOverlayWidget(),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: wrapWithModel(
            model: _model.conversationThreadModel,
            updateCallback: () => setState(() {}),
            child: ConversationThreadWidget(conversation: conversation),
          ),
        ),
      ),
    );
  }
}
