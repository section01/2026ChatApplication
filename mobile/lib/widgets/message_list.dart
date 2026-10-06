// メッセージ一覧
import 'package:flutter/material.dart';
import '../models/message.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController controller;
  final GlobalKey? lastMessageKey;

  const MessageList({
    super.key,
    required this.messages,
    required this.controller,
    this.lastMessageKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(
          key: index == messages.length - 1 ? lastMessageKey : null,
          message: messages[index],
        );
      },
    );
  }
}
