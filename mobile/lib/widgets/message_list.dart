// メッセージ一覧
import 'package:flutter/material.dart';
import '../models/message.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
    final List<Message> messages;

    const MessageList({
        super.key,
        required this.messages,
    });

    @override
    Widget build(BuildContext context) {
        return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
                return MessageBubble(
                    message: messages[index],
                );
            },
        );
    }
}