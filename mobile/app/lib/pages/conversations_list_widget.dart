import 'package:app/components/conversation_thread/conversation.dart';
import 'package:app/theme.dart';

import 'package:app/pages/conversation_widget.dart';
import 'package:app/components/conversation_options/conversation_options_widget.dart';
import 'package:app/util/server.dart';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final selectedIndexProvider = StateProvider<int>((_) => 0); // Initial state

  late List<Widget> conversations = [];
  // = [
  //   // TODO: Dynamically generate list of pages based upon existing conversations.
  //   // This requires retrievable conversations from the server side.
  //   const Center(child: ConversationWidget()),
  // ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Server().init();
    List<Conversation> convos = Server.conversations;
    for(Conversation c in convos) {
      conversations.add(const ConversationWidget());
    }

    _model = createModel(context, () => ConversationsListModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Conversation> conversations = Server.getConversationsList();
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                  child: Text(
                    'Conversations',
                    style: AppTheme.labelMedium,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: ListView.builder(
                      itemCount: conversations.length,
                      padding: EdgeInsets.zero,
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Align(
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
                                  decoration: const BoxDecoration(color: AppTheme.secondaryBackground,),
                                  child: const Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Icon(
                                      Icons.settings_outlined, // TODO: Dynamically generate or allow users to color code/tag conversations.
                                      color: AppTheme.secondaryText,
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
                                        minWidth: MediaQuery.sizeOf(context).width,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.secondaryBackground,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: const AlignmentDirectional(-1, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  conversations[index].conversationLabel,
                                                  style: AppTheme.headlineLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(-1, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    conversations[index].conversationSubLabel,
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
                                    color: AppTheme.secondaryBackground,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppTheme.secondaryText,
                                    size: 48,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => {
                              // TODO: Need to implement.
                              // Get the conversation object based on the index
                              // Use Navigator to push a new ConversationWidget with conversation data
                              Server.loadConversation(index),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConversationWidget(),
                                ),
                              )
                            },
                            onLongPress: () => {
                              // TODO: Need to implement.
                              print("opening options")
                            },
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}