import 'package:app/components/conversation_thread/conversation.dart';
import 'package:app/theme.dart';

import 'package:app/pages/conversation_widget.dart';
import 'package:app/util/server.dart';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';

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

  static List<ConversationWidget> conversations = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Backend().init();

    if(conversations.isEmpty) {
      List<Conversation> convoys = Backend.conversations;
      for(Conversation c in convoys) {
        conversations.add(ConversationWidget(conversation: c,));
      }
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
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: true,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  splashColor: AppTheme.accent,
                                  focusColor: AppTheme.lightest,
                                  hoverColor: AppTheme.dark,
                                  highlightColor: AppTheme.darkest,
                                  // TODO
                                  // onTap: () async {
                                  //   context.pushNamed('Conversation');
                                  // },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      //color: AppTheme.darkest,
                                      border: Border(
                                        top: BorderSide(width: 2.0, color: AppTheme.darkest),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(color: AppTheme.lightest,),
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
                                                color: AppTheme.lightest,
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
                                                          conversations[index].conversation.conversationLabel,
                                                          style: AppTheme.labelLarge,
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
                                                            conversations[index].conversation.conversationSubLabel,
                                                            style: AppTheme.labelSmall,
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
                                            color: AppTheme.lightest,
                                          ),
                                          child: const Icon(
                                            Icons.chevron_right_rounded,
                                            color: AppTheme.secondaryText,
                                            size: 48,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () => {
                                    Backend.loadConversation(index),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConversationWidget(conversation: Backend.getLoadedConversation(),),
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
                Positioned(
                  bottom: 20.0, // Adjust positioning as needed
                  right: 20.0, // Adjust positioning as needed
                  child: FloatingActionButton(
                    onPressed: () => {
                      Backend.loadConversation(Backend.maxConversationID), // TODO: Dynamically get the next ID
                      conversations.add(ConversationWidget(conversation: Backend.getLoadedConversation())),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationWidget(conversation: Backend.getLoadedConversation(),),
                        ),
                      ), // Handle the button press
                    },
                    backgroundColor: AppTheme.darkest,
                    child: const Icon(
                      Icons.bubble_chart,
                      color: AppTheme.lightest,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}