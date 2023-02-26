import 'package:flutter/cupertino.dart';

class ChatMessage {
  String? messageContent;
  String? messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});

  factory ChatMessage.fromJson(Map<String, dynamic> data) {
    return ChatMessage(
      messageContent: data["messageContent"],
      messageType: data["messageType"],
    );
  }
}
