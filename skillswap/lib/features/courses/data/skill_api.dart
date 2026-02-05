import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/services/app_config.dart';

class SkillApi {
  static Future<List<dynamic>> getAll() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/skills");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Failed to load skills");
  }
}