import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Uri _uri(String path) => Uri.parse("$baseUrl$path");

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await http.get(_uri(path));
    _ensureSuccess(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      _uri(path),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    _ensureSuccess(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> putJson(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      _uri(path),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    _ensureSuccess(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> delete(String path) async {
    final res = await http.delete(_uri(path));
    _ensureSuccess(res);
  }

  void _ensureSuccess(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }
    
  }
}
