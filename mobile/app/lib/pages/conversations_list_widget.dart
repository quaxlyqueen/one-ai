import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import '/components/conversation_options/conversation_options_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

import 'conversations_list_model.dart';
export 'conversations_list_model.dart';

class ConversationsListWidget extends StatefulWidget {
  const ConversationsListWidget({super.key});

  @override
  State<ConversationsListWidget> createState() =>
      _ConversationsListWidgetState();
}

class _ConversationsListWidgetState extends State<ConversationsListWidget> {
  late ConversationsListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationsListModel());
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
        floatingActionButton: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onLongPress: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () => _model.unfocusNode.canRequestFocus
                      ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                      : FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: const ConversationOptionsWidget(),
                  ),
                );
              },
            ).then((value) => safeSetState(() {}));

            // TODO
            //context.pushNamed('Conversation');
          },
          child: FloatingActionButton(
            // TODO
            // onPressed: () async {
            //   context.pushNamed('Conversation');
            // },
            onPressed: () {
              print("fab pressed");
            },
            backgroundColor: AppTheme.primary,
            elevation: 8,
            child: const Icon(
              Icons.add,
              color: AppTheme.info,
              size: 24,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppTheme.secondaryBackground,
          automaticallyImplyLeading: false,
          title: const Text(
            'My Chats',
            style: AppTheme.headlineLarge,
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  'AI conversations',
                  style: AppTheme.labelMedium,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          // TODO
                          // onTap: () async {
                          //   context.pushNamed('Conversation');
                          // },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: AppTheme
                                      .secondaryBackground,
                                ),
                                child: const Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: AppTheme
                                        .secondaryText,
                                    size: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: const AlignmentDirectional(-1, 0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.sizeOf(context).width,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppTheme
                                          .secondaryBackground,
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Hello World',
                                                style: AppTheme.headlineLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Hello World',
                                                  style: AppTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: AppTheme
                                      .secondaryBackground,
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppTheme
                                      .secondaryText,
                                  size: 48,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
