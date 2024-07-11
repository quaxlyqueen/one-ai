class Chat {
  final String content;
  final bool role;
  int chatType = 0;

  // Most basic chat, text from server or from user.
  Chat(this.content, this.role, this.chatType);

  // A chat with an included image.
  Chat.image(this.content, this.role, this.chatType);

  // A chat with an included file.
  Chat.file(this.content, this.role, this.chatType);
}

// TODO: Add proper filetype support. File should either be parsed on-device, or uploaded to the server.
// TODO: See https://github.com/adithya-s-k/omniparse
// TODO: Implement dynamic pathing based upon filetypes.
enum Filetype {
  pdf,
  doc,
  docx,
  pages,
  note,
  todo,
  cal,
  calendar,
  event,
  contact,
  mp3,
  mp4,
  wav,
}