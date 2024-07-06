import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'model_item_model.dart';
export 'model_item_model.dart';

class ModelItemWidget extends StatefulWidget {
  const ModelItemWidget({super.key});

  @override
  State<ModelItemWidget> createState() => _ModelItemWidgetState();
}

class _ModelItemWidgetState extends State<ModelItemWidget> {
  late ModelItemModel _model;

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
          color: AppAppAppAppAppAppAppAppAppTheme.primaryBackground,
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
                  color: AppAppAppAppAppAppAppAppAppTheme.accent1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppAppAppAppAppAppAppAppAppTheme.primary,
                    width: 2,
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: AppAppAppAppAppAppAppAppAppTheme.bodyLarge.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                        ),
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
                      Text(
                        'Randy Peterson',
                        style: AppAppAppAppAppAppAppAppAppTheme.bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'name@domainname.com',
                          style:
                              AppAppAppAppAppAppAppAppAppTheme.bodySmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: AppAppAppAppAppAppAppAppAppTheme.primary,
                                    letterSpacing: 0,
                                  ),
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
