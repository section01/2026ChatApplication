// HTTP通信を行うためのパッケージ
import 'package:http/http.dart' as http;

// JSONを扱うためのパッケージ
import 'dart:convert';

// グループモデル
import '../models/chat_group.dart';

// グループ情報に関するAPI通信を担当するクラス
class ChatGroupService {
  // Spring BootのベースURL
  static const String baseUrl = "http://localhost:8080";

  // グループ一覧を取得するメソッド
  Future<List<ChatGroup>> getGroups() async {
    // グループ取得APIを呼び出す
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups"),
    );

    // HTTPステータスが200以外の場合はエラーにする
    if (response.statusCode != 200) {
      throw Exception("グループ取得に失敗しました");
    }

    // JSONをDartで扱える形式に変換
    final List<dynamic> data = jsonDecode(response.body);

    // JSONをChatGroupオブジェクトに変換して返す
    return data.map((item) {
      return ChatGroup.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  // グループを作成するメソッド
  Future<void> createGroup(String name) async {
    // グループ作成APIを呼び出す
    final response = await http.post(
      Uri.parse("$baseUrl/api/groups"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
      }),
    );

    // HTTPステータスが2xx以外の場合はエラーにする
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("グループ作成に失敗しました");
    }
  }

  // グループ名を変更するメソッド
  Future<void> updateGroup(int groupId, String newName) async {
    // グループ名変更APIを呼び出す
    final response = await http.put(
      Uri.parse("$baseUrl/api/groups/$groupId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": newName,
      }),
    );

    // HTTPステータスが2xx以外の場合はエラーにする
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("グループ名の変更に失敗しました");
    }
  }
}