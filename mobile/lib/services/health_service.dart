import 'dart:convert';
import 'package:http/http.dart' as http;

class HealthService {
  static const String baseUrl = "http://localhost:8080";

  Future<String> getHealth() async {
    final response = await http.get(Uri.parse("$baseUrl/health"));

    return response.body;
  }
}
