// 画面全体
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../widgets/message_list.dart';

class GroupChatScreen extends StatefulWidget {
    const GroupChatScreen({super.key});

    @override
    State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {

    late List<Message> _messages;

    final TextEditingController _controller = TextEditingController();

    @override
    void initState() {
        super.initState();

        _messages = List.from(messages);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("グループチャット"),
                centerTitle: true,
            ),
            body: Column(
                children: [
                    // メッセージ一覧
                    Expanded(
                        child: MessageList(
                            messages: _messages,
                        ),
                    ),

                    // 入力欄
                    Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey.shade200,
                        child: Row(
                            children: [
                                Expanded(
                                    child: TextField(
                                        controller: _controller,

                                        decoration: const InputDecoration(
                                        hintText: "メッセージを入力",
                                        border: OutlineInputBorder(),
                                        ),
                                    ),
                                ),

                                const SizedBox(width: 8),

                                ElevatedButton(
                                    onPressed: () {
                                        // Sprint1では未実装
                                    },
                                    child: const Text("送信"),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}