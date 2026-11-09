// グループ情報を管理するモデル
class ChatGroup {
  // グループID
  final int id;

  // グループ名
  final String name;

  // コンストラクタ
  ChatGroup({
    required this.id,
    required this.name,
  });

  // JSONをChatGroupオブジェクトに変換
  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    return ChatGroup(
      id: json["id"],
      name: json["name"],
    );
  }
}