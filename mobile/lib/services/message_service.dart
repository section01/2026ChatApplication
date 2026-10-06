// HTTP通信を行うためのパッケージ
import 'package:http/http.dart' as http;

// JSONを扱うためのパッケージ
import 'dart:convert';

// メッセージモデル
import '../models/message.dart';

// メッセージに関するAPI通信を担当するクラス
class MessageService {
  // Spring BootのベースURL
  static const String baseUrl = "http://localhost:8080";

  // メッセージ一覧を取得するメソッド
  Future<List<Message>> getMessages() async {
    // Spring Bootのメッセージ取得APIを呼び出す
    final response = await http.get(Uri.parse("$baseUrl/api/messages"));

    // HTTPステータスが200以外の場合はエラーにする
    if (response.statusCode != 200) {
      throw Exception("メッセージ取得に失敗しました");
    }

    // JSON形式のレスポンスをDartで扱える形式に変換
    final List<dynamic> data = jsonDecode(response.body);

    // JSONをMessageオブジェクトに変換して返す
    return data.map((item) {
      return Message.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  // メッセージを送信するメソッド
  Future<void> sendMessage(String text) async {
    // Spring Bootのメッセージ登録APIを呼び出す
    final response = await http.post(
      Uri.parse("$baseUrl/api/messages"),

      // JSON形式でデータを送信することを指定
      headers: {"Content-Type": "application/json"},

      // メッセージ本文をJSON形式に変換して送信
      body: jsonEncode({"text": text}),
    );

    // HTTPステータスが200番台以外の場合はエラーにする
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("メッセージ送信に失敗しました");
    }
  }
}
