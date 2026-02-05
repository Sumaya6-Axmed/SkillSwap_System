import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change later when backend is ready
  static const String baseUrl = 'http://localhost:5000/api';

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url);
  }

  Future<http.Response> postRequest(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
