import '/components/conversation_details_overlay/conversation_details_overlay_widget.dart';
import '/components/conversation_thread/conversation_thread_widget.dart';
import '/components/model_item/model_item_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/theme.dart';

import 'conversation_model.dart';
export 'conversation_model.dart';

class ConversationWidget extends StatefulWidget {
  const ConversationWidget({super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  late ConversationModel _model;

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
        backgroundColor: myAppTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: myAppTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.primaryText,
              size: 30,
            ),
            onPressed: () async {
              context.goNamed(
                'ConversationsList',
                extra: <String, dynamic>{
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.leftToRight,
                    duration: const Duration(milliseconds: 250),
                  ),
                },
              );
            },
          ),
          title: wrapWithModel(
            model: _model.modelItemModel,
            updateCallback: () => setState(() {}),
            child: ModelItemWidget(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 16, 8),
              child: FlutterFlowIconButton(
                borderColor: AppTheme.alternate,
                borderRadius: 12,
                borderWidth: 2,
                buttonSize: 40,
                fillColor: AppTheme.primaryBackground,
                icon: Icon(
                  Icons.more_vert,
                  color: AppTheme.primaryText,
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
                          child: ConversationDetailsOverlayWidget(),
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
            child: ConversationThreadWidget(),
          ),
        ),
      ),
    );
  }
}
