import 'dart:io';

import 'package:app/components/util/backend.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import 'package:app/theme.dart';
import 'package:image_picker/image_picker.dart';

import '../conversation_thread/chat.dart';
import 'prompt_box_model.dart';
export 'prompt_box_model.dart';

class PromptBoxWidget extends StatefulWidget {
  const PromptBoxWidget({super.key});

  @override
  State<PromptBoxWidget> createState() => _PromptBoxWidgetState();
}

class _PromptBoxWidgetState extends State<PromptBoxWidget> {
  late PromptBoxModel _model;
  String entryText = "";

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
    const double buttonPadding = 4;
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
                    padding: const EdgeInsets.all(buttonPadding),
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () async {
                        final picker = FilePicker.platform;
                        final result = await picker.pickFiles(allowMultiple: true); // Allow multiple files
                        if (result != null) {
                          for (final platformFile in result.files) {
                            // TODO: Upload file to server
                            final file = File(platformFile.path!);
                          }
                        } else {
                          print('User canceled file selection');
                        }
                      },
                    ),
                  ),
                ),
                Expanded( // TODO: Gallery context upload
                  child: Padding(
                    padding: const EdgeInsets.all(buttonPadding),
                    child: IconButton(
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);

                        // TODO: Allow for multiple pictures/photos to be selected.
                        // final images = await picker.pickMultiImage();
                        if (image != null) {

                          // TODO: Upload to server and add to conversation.chats
                          String i = Backend.convertToBase64(File(image.path)).toString();
                          Backend.loadedConversation.add(Chat.image(i, true, 1));
                        } else {
                          print('User canceled image selection');
                        }
                      },
                    ),
                  ),
                ),
                Expanded( // TODO: Video context upload
                  child: Padding(
                    padding: const EdgeInsets.all(buttonPadding),
                    child: IconButton(
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
                    padding: const EdgeInsets.all(buttonPadding),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          // TODO: Upload to server and add to conversation.chats
                          final i = Backend.convertToBase64(File(image.path));
                          Backend.loadedConversation.add(Chat.image(i.toString(), true, 1));
                        } else {
                          print('User canceled photo capture');
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(buttonPadding),
                    child: IconButton(
                      icon: Icon(
                        Backend.stt.speechToText.isNotListening ? Icons.mic_off_outlined : Icons.mic_none,
                        color: AppTheme.darkest,
                        size: 30,
                      ),
                      onPressed: () {
                        // TODO: Audio input is still buggy, it appears to only enter the text field once the button is pressed again to stop.
                        if(Backend.stt.speechToText.isNotListening) {
                          print('STT engine starting ...');
                          Backend.stt.startListening();
                          updateText();
                        } else {
                          print('STT engine stopping');
                          Backend.stt.stopListening();
                          updateText();
                        }
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
                            if(_model.textController.text != "") {
                              // TODO: Connect with multimedia
                              entryText = _model.textController.text;
                              Backend.respondWhenReady(entryText);
                              _model.textController?.clear(); // Clear the text field
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            }
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
                      textInputAction: TextInputAction.send, // "Send" on keyboard
                      onFieldSubmitted: (text) {
                        // Don't take any action unless there's an actual input.
                        if(_model.textController.text != "") {
                          entryText = _model.textController.text;
                          Backend.respondWhenReady(entryText); // TODO: Connect with multimedia
                          _model.textController?.clear(); // Clear the text field
                        }
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

  void updateText() {
    _model.textController.text = Backend.stt.text;
    entryText = _model.textController.text;
    print(entryText);
    print(_model.textController.text);
    Backend.stt.reset();
  }
}