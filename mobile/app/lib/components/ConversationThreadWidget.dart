import '/components/conversation_bubbles/conversation_bubbles_widget.dart';
import '/components/prompt_box/prompt_box_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'conversation_thread_model.dart';
export 'conversation_thread_model.dart';

class ConversationThreadWidget extends StatefulWidget {
  const ConversationThreadWidget({super.key});

  @override
  State<ConversationThreadWidget> createState() =>
      _ConversationThreadWidgetState();
}

class _ConversationThreadWidgetState extends State<ConversationThreadWidget> {
  late ConversationThreadModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationThreadModel());
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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                0,
                12,
                0,
                24,
              ),
              reverse: true,
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  decoration: BoxDecoration(),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 1,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height * 1,
                  ),
                  decoration: BoxDecoration(),
                  child: wrapWithModel(
                    model: _model.conversationBubblesModel,
                    updateCallback: () => setState(() {}),
                    child: ConversationBubblesWidget(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FlutterFlowMediaDisplay(
                                path: '',
                                imageBuilder: (path) => ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl: path,
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                videoPlayerBuilder: (path) =>
                                    FlutterFlowVideoPlayer(
                                  path: path,
                                  width: 300,
                                  autoPlay: false,
                                  looping: true,
                                  showControls: true,
                                  allowFullScreen: true,
                                  allowPlaybackSpeedMenu: false,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, -1),
                                child: FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).error,
                                  borderRadius: 20,
                                  borderWidth: 2,
                                  buttonSize: 40,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                              ),
                            ]
                                .divide(SizedBox(width: 8))
                                .addToStart(SizedBox(width: 16))
                                .addToEnd(SizedBox(width: 16)),
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: wrapWithModel(
                      model: _model.promptBoxModel,
                      updateCallback: () => setState(() {}),
                      child: PromptBoxWidget(),
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
