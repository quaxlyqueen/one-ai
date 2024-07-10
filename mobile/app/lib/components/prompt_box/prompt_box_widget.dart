import 'package:app/util/server.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import 'package:app/theme.dart';

import 'prompt_box_model.dart';
export 'prompt_box_model.dart';

class PromptBoxWidget extends StatefulWidget {
  const PromptBoxWidget({super.key});

  @override
  State<PromptBoxWidget> createState() => _PromptBoxWidgetState();
}

class _PromptBoxWidgetState extends State<PromptBoxWidget> {
  late PromptBoxModel _model;
  late String entry_text;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PromptBoxModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: const AlignmentDirectional(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              // TODO: Implement the context upload buttons
              children: [
                Expanded( // TODO: File context upload
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                ),
                Expanded( // TODO: Photo context upload
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                ),
                Expanded( // TODO: Video context upload
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: const Icon(
                        Icons.videocam_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                ),
                Expanded( // TODO: Camera context upload
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      onChanged: (_) => EasyDebounce.debounce(
                        '_model.textController',
                        const Duration(milliseconds: 2000),
                        () => setState(() {}),
                      ),
                      autofocus: true,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        isDense: false,
                        counterStyle: AppTheme.bodyMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppTheme.secondaryText,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppTheme.alternate,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // TODO: Connect with multimedia
                            entry_text = _model.textController.text;
                            Backend.respondWhenReady(entry_text);
                            _model.textController?.clear(); // Clear the text field
                          },
                          child: const Icon(
                            Icons.send,
                            color: AppTheme.primary,
                            size: 30,
                          ),
                        ),
                      ),
                      style: AppTheme.displayMedium,
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      minLines: 1,
                      validator: _model.textControllerValidator.asValidator(context),
                      textInputAction: TextInputAction.send, // "Send" on keyboard
                      onFieldSubmitted: (text) {
                        Backend.respondWhenReady(text); // TODO: Connect with multimedia
                        _model.textController?.clear(); // Clear the text field
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
