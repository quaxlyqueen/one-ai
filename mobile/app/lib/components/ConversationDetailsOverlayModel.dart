import '/components/options_dialog/options_dialog_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'conversation_details_overlay_widget.dart'
    show ConversationDetailsOverlayWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConversationDetailsOverlayModel
    extends FlutterFlowModel<ConversationDetailsOverlayWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for OptionsDialog component.
  late OptionsDialogModel optionsDialogModel;

  @override
  void initState(BuildContext context) {
    optionsDialogModel = createModel(context, () => OptionsDialogModel());
  }

  @override
  void dispose() {
    optionsDialogModel.dispose();
  }
}
