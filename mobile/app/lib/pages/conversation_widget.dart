import '/components/conversation_details_overlay/conversation_details_overlay_widget.dart';
import '/components/conversation_thread/conversation_thread_widget.dart';
import '/components/model_item/model_item_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';

import 'package:app/theme.dart';

import 'conversation_model.dart';
export 'conversation_model.dart';

class ConversationWidget extends StatefulWidget {
  const ConversationWidget({super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  late ConversationModel _model;

  _ConversationWidgetState();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationModel());
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
              color: AppTheme.primaryTextColor,
              size: 30,
            ),
            onPressed: () async {
              print("something pressed in conversation_widget.dart");
              // TODO
              // context.goNamed(
              //   'ConversationsList',
              //   extra: <String, dynamic>{
              //     kTransitionInfoKey: TransitionInfo(
              //       hasTransition: true,
              //       transitionType: PageTransitionType.leftToRight,
              //       duration: const Duration(milliseconds: 250),
              //     ),
              //   },
              // );
            },
          ),
          title: wrapWithModel(
            model: _model.modelItemModel,
            updateCallback: () => setState(() {}),
            child: const ModelItemWidget(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 16, 8),
              // ---------- Options Button
              child: FlutterFlowIconButton(
                borderColor: AppTheme.alternate,
                borderRadius: 12,
                borderWidth: 2,
                buttonSize: 40,
                fillColor: AppTheme.primaryBackground,
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.primaryTextColor,
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
            child: const ConversationThreadWidget(),
          ),
        ),
      ),
    );
  }
}
