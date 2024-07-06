import '/components/options_dialog/options_dialog_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'Chat Details',
                            style: AppAppAppAppAppAppAppAppAppTheme
                                .headlineSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                          child: FlutterFlowIconButton(
                            borderColor: AppAppAppAppAppAppAppAppAppTheme.alternate,
                            borderRadius: 12,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: AppAppAppAppAppAppAppAppAppTheme.accent4,
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppAppAppAppAppAppAppAppAppTheme.primaryText,
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
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Group Chat ID: ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: 'Hello World ',
                              style: TextStyle(
                                color: AppAppAppAppAppAppAppAppAppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style:
                              AppAppAppAppAppAppAppAppAppTheme.labelMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1,
                              color: AppAppAppAppAppAppAppAppAppTheme.tertiary,
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
                              color: AppAppAppAppAppAppAppAppAppTheme
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppAppAppAppAppAppAppAppAppTheme.alternate,
                              ),
                            ),
                            child: wrapWithModel(
                              model: _model.optionsDialogModel,
                              updateCallback: () => setState(() {}),
                              updateOnChange: true,
                              child: OptionsDialogWidget(),
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
                              AppAppAppAppAppAppAppAppAppTheme.secondaryBackground,
                          textStyle:
                              AppAppAppAppAppAppAppAppAppTheme.titleLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18,
                                    letterSpacing: 0,
                                  ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: AppAppAppAppAppAppAppAppAppTheme.alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: AppAppAppAppAppAppAppAppAppTheme.alternate,
                          hoverBorderSide: BorderSide(
                            color: AppAppAppAppAppAppAppAppAppTheme.alternate,
                            width: 2,
                          ),
                          hoverTextColor:
                              AppAppAppAppAppAppAppAppAppTheme.primaryText,
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
