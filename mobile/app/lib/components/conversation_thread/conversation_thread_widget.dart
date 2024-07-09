import 'package:app/components/conversation_thread/conversation.dart';
import 'package:app/util/server.dart';
import 'package:provider/provider.dart';

import '/components/conversation_thread/chat_bubble_widget.dart';
import 'package:app/components/conversation_thread/conversation_thread_model.dart';
import '/components/prompt_box/prompt_box_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:app/theme.dart';

import 'conversation_thread_model.dart';
export 'conversation_thread_model.dart';

class ConversationThreadWidget extends StatefulWidget {
  final Conversation conversation;
  const ConversationThreadWidget({super.key, required this.conversation});

  @override
  State<ConversationThreadWidget> createState() =>
      _ConversationThreadWidgetState(conversation);
}

class _ConversationThreadWidgetState extends State<ConversationThreadWidget> {
  late ConversationThreadModel _model;
  Conversation conversation;

  _ConversationThreadWidgetState(this.conversation);

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationThreadModel(conversation));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppTheme.primaryBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _model.conversation,
                builder: (BuildContext context, Widget? child) {
                  return ListView.builder(
                    itemCount: Server.getLoadedConversation().chats.length,
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 24,),
                    reverse: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatBubbleWidget(c: Server.getLoadedConversation().chats[index]);
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(
                      0,
                      -2,
                    ),
                  )
                ],
              ),
              // TODO
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FlutterFlowMediaDisplay(
                                //   path: '',
                                //   imageBuilder: (path) => ClipRRect(
                                //     borderRadius: BorderRadius.circular(8),
                                //     child: CachedNetworkImage(
                                //       fadeInDuration: const Duration(milliseconds: 500),
                                //       fadeOutDuration:
                                //           const Duration(milliseconds: 500),
                                //       imageUrl: path,
                                //       width: 120,
                                //       height: 100,
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                // TODO
                                //   videoPlayerBuilder: (path) =>
                                //       FlutterFlowVideoPlayer(
                                //     path: path,
                                //     width: 300,
                                //     autoPlay: false,
                                //     looping: true,
                                //     showControls: true,
                                //     allowFullScreen: true,
                                //     allowPlaybackSpeedMenu: false,
                                //   ),
                                // ),
                                Align(
                                  alignment: const AlignmentDirectional(-1, -1),
                                  // TODO: Make the delete button conditional upon media upload.
                                  child: FlutterFlowIconButton(
                                    borderColor:
                                    AppTheme.error,
                                    borderRadius: 20,
                                    borderWidth: 2,
                                    buttonSize: 40,
                                    fillColor: AppTheme.primaryBackground,
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppTheme.error,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                ),
                              ]
                                  .divide(const SizedBox(width: 8))
                                  .addToStart(const SizedBox(width: 16))
                                  .addToEnd(const SizedBox(width: 16)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: wrapWithModel(
                        model: _model.promptBoxModel,
                        updateCallback: () => setState(() {}),
                        child: const PromptBoxWidget(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
