import 'package:flutter/material.dart';
import 'chat.dart';

class ChatBubbleWidget extends StatelessWidget{
  late Chat c;

  ChatBubbleWidget({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: c.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
              bottomLeft: c.isMe ? const Radius.circular(12.0) : const Radius
                  .circular(0.0),
              bottomRight: c.isMe ? const Radius.circular(12.0) : const Radius
                  .circular(0.0),
            ),
            color: c.isMe ? Colors.blue[200] : Colors.grey[200],
          ),
          child: Text(c.message),
        ),
      ],
    );
  }
}