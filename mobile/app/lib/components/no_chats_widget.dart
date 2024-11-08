import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

class NoChatsWidget extends StatefulWidget {
  const NoChatsWidget({
    super.key,
    this.icon,
    String? title,
    String? body,
  })  : title = title ?? 'No Comments',
        body = body ?? 'There are no comments associated with this post.';

  final Widget? icon;
  final String title;
  final String body;

  @override
  State<NoChatsWidget> createState() => _NoChatsWidgetState();
}

class _NoChatsWidgetState extends State<NoChatsWidget> {

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon!,
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(
              widget.body,
              textAlign: TextAlign.center,
              style: AppTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
