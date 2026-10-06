import 'package:flutter/material.dart';
import '../models/message.dart';

/* 1件のメッセージを表示する部品（Widget）
    今回の目標
    自分のメッセージは 右寄せ・青色
    相手のメッセージは 左寄せ・グレー
    名前・本文・時刻を表示 */
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Column(
          crossAxisAlignment: message.isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!message.isMine)
              Text(
                message.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 4),

            Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isMine ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isMine ? Colors.white : Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
