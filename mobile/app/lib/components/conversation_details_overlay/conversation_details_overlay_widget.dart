import '/components/options_dialog/options_dialog_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

import 'conversation_details_overlay_model.dart';
export 'conversation_details_overlay_model.dart';

class ConversationDetailsOverlayWidget extends StatefulWidget {
  const ConversationDetailsOverlayWidget({super.key});

  @override
  State<ConversationDetailsOverlayWidget> createState() =>
      _ConversationDetailsOverlayWidgetState();
}

class _ConversationDetailsOverlayWidgetState
    extends State<ConversationDetailsOverlayWidget> {
  late ConversationDetailsOverlayModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConversationDetailsOverlayModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(),
          child: Align(
            alignment: const AlignmentDirectional(0, -1),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'Chat Details',
                            style: AppTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                          child: FlutterFlowIconButton(
                            borderColor: AppTheme.alternate,
                            borderRadius: 12,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: AppTheme.accent4,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppTheme.primaryTextColor,
                              size: 24,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 4),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Group Chat ID: ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: 'Hello World ',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style: AppTheme.labelMedium,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1,
                              color: AppTheme.tertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.alternate,
                              ),
                            ),
                            child: wrapWithModel(
                              model: _model.optionsDialogModel,
                              updateCallback: () => setState(() {}),
                              updateOnChange: true,
                              child: const PopupWidget(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 44),
                      child: FFButtonWidget(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        text: 'Close',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 52,
                          padding: const EdgeInsetsDirectional.fromSTEB(44, 0, 44, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color:
                              AppTheme.secondaryBackground,
                          textStyle: AppTheme.titleLarge,
                          elevation: 0,
                          borderSide: const BorderSide(
                            color: AppTheme.alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: AppTheme.alternate,
                          hoverBorderSide: const BorderSide(
                            color: AppTheme.alternate,
                            width: 2,
                          ),
                          hoverTextColor: AppTheme.primaryTextColor,
                          hoverElevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
