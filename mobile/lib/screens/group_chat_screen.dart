// 画面全体
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/message_service.dart';
import '../models/message.dart';
import '../widgets/message_list.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late List<Message> _messages;

  final MessageService _messageService = MessageService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _lastMessageKey = GlobalKey();

  // 初期化処理
  @override
  void initState() {
    super.initState();

    // 初期メッセージ
    _messages = List.from(messages);

    // メッセージ一覧をAPIから取得
    _messageService.getMessages().then((result) {
      setState(() {
        // APIから取得したメッセージを画面表示用の形式に変換
        _messages = result.map((item) {
          return Message(
            senderName: "自分",
            text: item["text"],
            createdAt: DateTime.now(),
            isMine: true,
          );
        }).toList();
      });
    });
  }

  // 画面破棄時にコントローラーを破棄
  @override
  void dispose() {
    // 入力欄のコントローラーを破棄
    _controller.dispose();
    // スクロールのコントローラーを破棄
    _scrollController.dispose();
    super.dispose();
  }

  // メッセージ送信処理
  void _sendMessage() {
    final text = _controller.text;

    // 空白を除去して空文字の場合は送信しない
    if (text.trim().isEmpty) {
      return;
    }

    // 画面を更新
    setState(() {
      // メッセージを追加
      _messages.add(
        Message(
          senderName: "自分",
          text: text,
          createdAt: DateTime.now(),
          isMine: true,
        ),
      );
    });

    // メッセージをAPIに送信
    _messageService.sendMessage(text).catchError((error) {
        print("メッセージ送信エラー: $error");
    });

    // 入力欄をクリア
    _controller.clear();

    // 一覧を一番下まで自動スクロール
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _lastMessageKey.currentContext;

      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("グループチャット"), centerTitle: true),
      body: Column(
        children: [
          // メッセージ一覧
          Expanded(
            child: MessageList(
              messages: _messages,
              controller: _scrollController,
              lastMessageKey: _lastMessageKey,
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
                    textInputAction: TextInputAction.send,

                    // Enterキーで送信
                    onSubmitted: (_) {
                      _sendMessage();
                    },

                    decoration: const InputDecoration(
                      hintText: "メッセージを入力",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () {
                    // メッセージ送信処理
                    _sendMessage();
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
