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

  // 2つのメッセージの日付が同じか確認する
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,

      itemBuilder: (context, index) {
        // 現在のメッセージ
        final message = messages[index];

        // 最初のメッセージか、前のメッセージと日付が違う場合
        final bool showDate = index == 0 ||
            !_isSameDay(
              messages[index - 1].createdAt,
              message.createdAt,
            );

        return Column(
          children: [
            // 日付が変わった場合は中央に日付を表示
            if (showDate)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${message.createdAt.year}年${message.createdAt.month}月${message.createdAt.day}日",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

            // メッセージ本体
            MessageBubble(
              key: index == messages.length - 1 ? lastMessageKey : null,
              message: message,
            ),
          ],
        );
      },

    );
  }
}
