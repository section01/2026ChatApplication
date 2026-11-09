// 画面全体
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/message_service.dart';
import '../models/message.dart';
import '../widgets/message_list.dart';
import '../widgets/loading_indicator.dart';
import '../models/chat_group.dart';
import '../services/message_service.dart';
import '../services/chat_group_service.dart';

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

  // グループ情報を取得するService
  final ChatGroupService _chatGroupService = ChatGroupService();

  // 取得したグループ一覧
  List<ChatGroup> _groups = [];

  // 現在選択しているグループ
  ChatGroup? _selectedGroup;

  final TextEditingController _controller = TextEditingController();

  // グループ名の入力欄を管理
  final TextEditingController _groupNameController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _lastMessageKey = GlobalKey();

  // 初期化処理
  @override
  void initState() {
    super.initState();

    // 初期メッセージ
    _messages = List.from(messages);

    // グループ一覧をAPIから取得
    _loadGroups();
  }

  // APIからグループ一覧を取得する処理
  Future<void> _loadGroups() async {
    try {
      // グループ一覧をAPIから取得
      final result = await _chatGroupService.getGroups();

      // 取得したグループ一覧を画面に反映
      setState(() {
        _groups = result;

        if (_groups.isNotEmpty) {
          // グループが存在する場合は先頭のグループを選択
          _selectedGroup = _groups.first;
        } else {
          // グループが存在しない場合は選択状態を解除
          _selectedGroup = null;
        }

        // 選択したグループのメッセージを取得
        _loadMessages();  
      });
    } catch (error) {
      // ターミナルにエラーを表示
      print("グループ取得エラー: $error");
    }
  }

  // グループを作成する処理
  Future<void> _createGroup(String name) async {
    // グループ名が空の場合は処理しない
    if (name.trim().isEmpty) {
      return;
    }

    try {
      // グループ作成APIを呼び出す
      await _chatGroupService.createGroup(name.trim());

      // グループ一覧を再取得
      await _loadGroups();
    } catch (error) {
      // エラーをターミナルに表示
      print("グループ作成エラー: $error");
    }
  }

  // グループ名を変更する処理
  Future<void> _updateGroup(String newName) async {
    // グループ名が空の場合は処理しない
    if (newName.trim().isEmpty || _selectedGroup == null) {
      return;
    }

    try {
      // グループ名変更APIを呼び出す
      await _chatGroupService.updateGroup(
        _selectedGroup!.id,
        newName.trim(),
      );

      // グループ一覧を再取得
      await _loadGroups();
    } catch (error) {
      // エラーをターミナルに表示
      print("グループ名変更エラー: $error");
    }
  }

  // グループを削除する処理
  Future<void> _deleteGroup() async {
    // グループが選択されていない場合は処理しない
    if (_selectedGroup == null) {
      return;
    }

    try {
      // 選択中のグループを削除
      await _chatGroupService.deleteGroup(_selectedGroup!.id);

      // グループ一覧を再取得
      await _loadGroups();
    } catch (error) {
      // エラーをターミナルに表示
      print("グループ削除エラー: $error");
    }
  }

  // グループ削除の確認ダイアログを表示
  void _showDeleteGroupDialog() {
    // グループが選択されていない場合は処理しない
    if (_selectedGroup == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("グループ削除"),
          content: Text(
            "「${_selectedGroup!.name}」を削除しますか？",
          ),
          actions: [
            // キャンセルボタン
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("キャンセル"),
            ),

            // 削除ボタン
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteGroup();
              },
              child: const Text("削除"),
            ),
          ],
        );
      },
    );
  }

  // グループ作成ダイアログを表示
  void _showCreateGroupDialog() {
    // 入力欄を空にする
    _groupNameController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("グループ作成"),
          content: TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: "グループ名を入力",
            ),
          ),
          actions: [
            // キャンセルボタン
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("キャンセル"),
            ),

            // 作成ボタン
            ElevatedButton(
              onPressed: () async {
                await _createGroup(_groupNameController.text);

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              child: const Text("作成"),
            ),
          ],
        );
      },
    );
  }

  // グループ名変更ダイアログを表示
  void _showUpdateGroupDialog() {
    // グループが選択されていない場合は処理しない
    if (_selectedGroup == null) {
      return;
    }

    // 現在のグループ名を入力欄に設定
    _groupNameController.text = _selectedGroup!.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("グループ名変更"),
          content: TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: "新しいグループ名を入力",
            ),
          ),
          actions: [
            // キャンセルボタン
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("キャンセル"),
            ),

            // 変更ボタン
            ElevatedButton(
              onPressed: () async {
                await _updateGroup(_groupNameController.text);

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              child: const Text("変更"),
            ),
          ],
        );
      },
    );
  }

  // APIからメッセージ一覧を取得する処理
  void _loadMessages() {

    // グループが選択されていない場合
    if (_selectedGroup == null) {
      setState(() {
        _messages = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    // 読み込み中の状態にする
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // メッセージ一覧をAPIから取得
    _messageService.getMessages(_selectedGroup!.id).then((result) {

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

    // グループが選択されていない場合は送信しない
    if (_selectedGroup == null) {
      return;
    }

    final text = _controller.text;

    // 空白を除去して空文字の場合は送信しない
    if (text.trim().isEmpty) {
      return;
    }

    // メッセージをAPIに送信
    try {
      await _messageService.sendMessage(text, _selectedGroup!.id);

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

      appBar: AppBar(
        title: const Text("グループチャット"),
        centerTitle: true,

        // グループ作成ボタンとグループ名変更ボタンをAppBarに追加
        actions: [
          // グループ作成ボタン
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "グループ作成",
            onPressed: () {
              _showCreateGroupDialog();
            },
          ),  

          // グループ名変更ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "グループ名変更",
            onPressed: () {
              _showUpdateGroupDialog();
            },
          ),

          // グループ削除ボタン
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "グループ削除",
            onPressed: () {
              _showDeleteGroupDialog();
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // グループ選択欄
          DropdownButton<ChatGroup>(
            value: _selectedGroup,
            hint: const Text("グループを選択"),
            items: _groups.map((group) {
              return DropdownMenuItem<ChatGroup>(
                value: group,
                child: Text(group.name),
              );
            }).toList(),
            onChanged: (group) {
              // 選択したグループを更新
              setState(() {
                _selectedGroup = group;
                _isLoading = true;
              });

              // 選択したグループのメッセージを取得
              _loadMessages();
            },
          ),

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
