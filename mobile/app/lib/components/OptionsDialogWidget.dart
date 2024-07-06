import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'popup_model.dart';
export 'popup_model.dart';

class PopupWidget extends StatefulWidget {
  const PopupWidget({super.key});

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  late PopupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Align(
        alignment: AlignmentDirectional(0, 0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570,
            maxHeight: 375,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 64,
                color: Color(0xB2000000),
                offset: Offset(
                  2,
                  2,
                ),
                spreadRadius: 225,
              )
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFE0E3E7),
            ),
          ),
          alignment: AlignmentDirectional(0, 0),
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: Text(
                            'Refine the components modal.',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF14181B),
                                  fontSize: 24,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderColor: Color(0xFFF1F4F8),
                        borderRadius: 30,
                        borderWidth: 2,
                        buttonSize: 44,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Color(0xFF57636C),
                          size: 24,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Divider(
                    height: 24,
                    thickness: 2,
                    color: Color(0xFFF1F4F8),
                  ),
                  Text(
                    'FlutterFlow is a visual development platform that allows you to easily create beautiful and responsive user interfaces for your mobile and web applications. With its drag-and-drop interface and pre-built components, you can quickly prototype and build your app without writing any code. \nAdditionally, FlutterFlow\'s real-time preview feature allows you to see your changes in real-time and make adjustments on the fly.',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF57636C),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                          options: FFButtonOptions(
                            height: 40,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: Colors.white,
                            textStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Readex Pro',
                                      color: Color(0xFF14181B),
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                    ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            hoverColor: Color(0xFFF1F4F8),
                            hoverTextColor: Color(0xFF14181B),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Create Task',
                          options: FFButtonOptions(
                            width: 130,
                            height: 40,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: Color(0xFF4B39EF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            hoverColor: Color(0xFF2B16ED),
                            hoverTextColor: Colors.white,
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
      ),
    );
  }
}
