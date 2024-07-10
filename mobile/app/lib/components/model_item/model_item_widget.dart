import 'package:app/components/conversation_thread/conversation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

import 'model_item_model.dart';
export 'model_item_model.dart';

class ModelItemWidget extends StatefulWidget {
  final Conversation conversation;
  const ModelItemWidget({super.key, required this.conversation});

  @override
  State<ModelItemWidget> createState() => _ModelItemWidgetState(conversation);
}

class _ModelItemWidgetState extends State<ModelItemWidget> {
  late ModelItemModel _model;
  late Conversation conversation;

  _ModelItemWidgetState(this.conversation);

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModelItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      cursor: MouseCursor.defer ?? MouseCursor.defer,
      onEnter: ((event) async {
        setState(() => _model.iuserHovered = true);
      }),
      onExit: ((event) async {
        setState(() => _model.iuserHovered = false);
      }),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accent1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primary,
                    width: 2,
                  ),
                ),
                child: const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyLarge,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( // Label
                        conversation.conversationLabel,
                        style: AppTheme.bodyMedium,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text( // Sub-label
                          conversation.conversationSubLabel,
                          style: AppTheme.bodySmall,
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
