// メッセージデータのモデル
// 1件のメッセージを表すモデル
class Message {
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isMine;

  Message({
    required this.senderName,
    required this.text,
    required this.createdAt,
    required this.isMine,
  });
}

// ダミーデータ
final messages = [
  Message(
    senderName: "田中",
    text: "こんにちは！",
    createdAt: DateTime.now(),
    isMine: false,
  ),
  Message(
    senderName: "自分",
    text: "よろしくお願いします！",
    createdAt: DateTime.now(),
    isMine: true,
  ),
  Message(
    senderName: "佐藤",
    text: "了解です！",
    createdAt: DateTime.now(),
    isMine: false,
  ),
];
