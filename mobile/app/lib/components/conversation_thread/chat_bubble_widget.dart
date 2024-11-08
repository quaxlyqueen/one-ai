import 'dart:convert';

import 'package:app/components/util/backend.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class ChatBubbleWidget extends StatelessWidget{
  late Chat c;

  ChatBubbleWidget({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    double max_width = MediaQuery.of(context).size.width*0.65;

    return Row(
      mainAxisAlignment: c.role ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: max_width,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
              bottomLeft: c.role ? const Radius.circular(12.0) : const Radius
                  .circular(0.0),
              bottomRight: c.role ? const Radius.circular(12.0) : const Radius
                  .circular(0.0),
            ),
            color: c.role ? AppTheme.darkest : AppTheme.dark,
          ),
          child:
             // TODO: Properly display filetypes in the thread.
             c.chatType == 0 ? Text(
               c.content,
               style: AppTheme.bodyMedium,
             )
             : c.chatType == 1 ? Image(image: Backend.convertFromBase64(c.content))
             : c.chatType == 2 ? const Icon(
                 Icons.file_copy,
             ) : const Text("null"),
          // Text(
          //   c.content,
          //   style: AppTheme.bodyMedium,
          // ),
        ),
      ],
    );
  }
}