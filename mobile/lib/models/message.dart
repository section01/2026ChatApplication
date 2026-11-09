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

  // APIから受け取ったJSONをMessageに変換する
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      // APIから送信者名を取得
      senderName: json["senderName"],

      // APIからメッセージ本文を取得
      text: json["text"],

      // APIから送信日時を取得
      createdAt: DateTime.parse(json["createdAt"]),

      // 送信者名が「自分」なら自分のメッセージと判定
      isMine: json["senderName"] == "自分",
    );
  }
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
