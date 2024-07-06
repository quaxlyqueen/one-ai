import 'package:app/pages/conversation_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/components/conversation_options/conversation_options_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

import 'conversations_list_model.dart';
export 'conversations_list_model.dart';

final conversationIndex = ValueNotifier<int>(0);


class MyState with ChangeNotifier {
  int get selectedIndex => conversationIndex.value;

  set selectedIndex(int value) {
    conversationIndex.value = value;
    notifyListeners();
  }
}

class ConversationsListWidget extends StatefulWidget {
  const ConversationsListWidget({super.key});

  @override
  State<ConversationsListWidget> createState() =>
      _ConversationsListWidgetState();
}

class _ConversationsListWidgetState extends State<ConversationsListWidget> {
  late ConversationsListModel _model;
  final selectedIndexProvider = StateProvider<int>((_) => 0); // Initial state

  final List<Widget> _pages = [
    // Replace with the widget for your first page (e.g., HomeScreen())
    Center(child: ConversationWidget()),

    // TODO: Dynamically generate list of pages based upon existing conversations.
    // This requires retrievable conversations from the server side.
  ];

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
                                    color: AppTheme.secondaryBackground,
                                  ),
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
                                        minWidth:
                                            MediaQuery.sizeOf(context).width,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.secondaryBackground,
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
                                                  'Hello World', // TODO: Dynamically obtain conversation title from server.
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
                                                    'Hello World', // TODO: Summary or list of models used
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
                              print("opening existing conversation")
                            },
                            onLongPress: () => {
                              print("opening options")
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}