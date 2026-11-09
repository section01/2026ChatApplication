// 画面全体
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/message_service.dart';
import '../models/message.dart';
import '../widgets/message_list.dart';
import '../widgets/loading_indicator.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late List<Message> _messages;

  // APIからメッセージを取得中かどうか
  bool _isLoading = true;

  // API取得時に発生したエラーメッセージ
  String? _errorMessage;

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
    _loadMessages();
  }

  // APIからメッセージ一覧を取得する処理
  void _loadMessages() {

    // 読み込み中の状態にする
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // メッセージ一覧をAPIから取得
    _messageService.getMessages().then((result) {

      setState(() {
        _messages = result;
        _isLoading = false;
      });

    }).catchError((error) {

      setState(() {
        _errorMessage = "メッセージの取得に失敗しました";
        _isLoading = false;
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
  void _sendMessage() async {
    final text = _controller.text;

    // 空白を除去して空文字の場合は送信しない
    if (text.trim().isEmpty) {
      return;
    }

    // メッセージをAPIに送信
    try {
      await _messageService.sendMessage(text);

      // API送信成功後に画面を更新
      setState(() {
        _messages.add(
          Message(
            senderName: "自分",
            text: text,
            createdAt: DateTime.now(),
            isMine: true,
          ),
        );
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

    } catch (error) {

      // 画面にエラーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("メッセージの送信に失敗しました"),
        ),
      );

      // ターミナルにもエラーを表示
      print("メッセージ送信エラー: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("グループチャット"), centerTitle: true),
      body: Column(
        children: [
          // メッセージ一覧
          Expanded(
            child: _isLoading
                ? const Center(
                    child: LoadingIndicator(),
                )
                : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // エラーメッセージを表示
                          Text(_errorMessage!),

                          const SizedBox(height: 16),

                          // 再読み込みボタン
                          ElevatedButton(
                            onPressed: () {
                              // メッセージを再取得する
                              _loadMessages();
                            },
                            child: const Text("再読み込み"),
                          ),
                        ],
                      ),
                    )
                    : MessageList(
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
