import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api/auth";

  // ======================
  // LOGIN
  // ======================
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // ======================
  // REGISTER
  // ======================
  static Future<void> register(
  String name,
  String email,
  String password,
  String role,
) async {
  final response = await http.post(
    Uri.parse("$baseUrl/register"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "role": role, // ✅ BACKEND REQUIREMENT
    }),
  );

  if (response.statusCode != 201) {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

}
