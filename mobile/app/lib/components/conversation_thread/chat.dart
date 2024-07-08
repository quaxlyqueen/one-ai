import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Chat {
  final String content;
  final bool role;

  // Most basic chat, text from server or from user.
  Chat(this.content, this.role);

  String toJson() {
    Map<String, dynamic> c = {
      "content": content,
      "role": role,
    };

    return json.encode(c);
  }

  // TODO: Overload constructors to allow for multimedia.
}