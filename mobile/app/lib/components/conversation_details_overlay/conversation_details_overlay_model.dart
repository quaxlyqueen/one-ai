import '/components/options_dialog/options_dialog_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'conversation_details_overlay_widget.dart'
    show ConversationDetailsOverlayWidget;
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
