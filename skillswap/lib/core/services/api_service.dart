import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../../../core/services/token_storage.dart';

class ApiService {
  // =================================
  // AUTO BASE URL
  // =================================
  static String get baseUrl {
    // Web (Chrome)
    if (kIsWeb) return "http://localhost:5000/api";

    // Mobile/Desktop (NOT web)
    if (Platform.isAndroid) return "http://10.0.2.2:5000/api";

    // Windows / macOS / iOS simulator
    return "http://localhost:5000/api";
  }

  // =================================
  // GET TOKEN
  // =================================
  static Future<String?> _getToken() async {
    return TokenStorage.read();
  }

  // =================================
  // HEADERS (auto add token)
  // =================================
  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // =================================
  // CREATE SKILL (UPLOAD COURSE)
  // =================================
  static Future<bool> createSkill({
    required String title,
    required String description,
    required String driveLink,
    bool quiz = false,
    String? category,
    String? level,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/skills"),
      headers: await _headers(),
      body: jsonEncode({
        "title": title,
        "description": description,
        "driveLink": driveLink,
        "category": category ?? "General",
        "level": level ?? "Beginner",
        "files": [],
        "quiz": quiz,
      }),
    );

    return res.statusCode == 201;
  }

  // ================================
  // GET MY SESSIONS
  // ================================
  static Future<List<dynamic>> getMySessions() async {
    final res = await http.get(
      Uri.parse("$baseUrl/sessions/mine"),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) return decoded;
      return [];
    } else {
      throw Exception("Failed to load sessions: ${res.statusCode} ${res.body}");
    }
  }

  // ================================
  // GET MY USER ID FROM JWT TOKEN
  // ================================
  static Future<String?> getMyUserId() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String normalizeBase64(String s) =>
          s.padRight(s.length + ((4 - s.length % 4) % 4), '=');

      final payload = utf8.decode(
        base64Url.decode(normalizeBase64(parts[1])),
      );

      final data = jsonDecode(payload) as Map<String, dynamic>;

      // Your backend might use any of these keys
      return (data["id"] ??
          data["_id"] ??
          data["userId"] ??
          data["sub"])
          ?.toString();
    } catch (_) {
      return null;
    }
  }

  // ================================
  // TUTOR RESPOND TO SESSION (accept/reject)
  // ================================
  static Future<bool> respondToSession({
    required String sessionId,
    required String status, // "accepted" or "rejected"
  }) async {
    final res = await http.patch(
      Uri.parse("$baseUrl/sessions/$sessionId/respond"),
      headers: await _headers(),
      body: jsonEncode({"status": status}),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  // ================================
  // REQUEST SESSION (learner)
  // ================================
  static Future<bool> requestSession({
    required String skillId,
    DateTime? scheduledAt, //  nullable (optional)
    String message = "",
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/sessions"),
      headers: await _headers(),
      body: jsonEncode({
        "skillId": skillId, //  MUST be skillId (backend expects skillId)
        "scheduledAt": scheduledAt?.toUtc().toIso8601String(), //  send null if not chosen
        "message": message,
      }),
    );

    return res.statusCode == 201;
  }


  // ================================
// MY LEARNING (from sessions)
// - Learning tab = accepted sessions where I am learner
// - Completed tab = completed sessions where I am learner
// Returns: List<Map<String,dynamic>> with {title,tutor,category,lessons}
// ================================
  static Future<List<Map<String, dynamic>>> getMyLearningCourses({
    required bool completed,
  }) async {
    final myId = await getMyUserId();
    if (myId == null) {
      throw Exception("Token missing. Please login again.");
    }

    final sessions = await getMySessions(); // already exists in your ApiService

    final wantedStatus = completed ? "completed" : "accepted";

    final list = <Map<String, dynamic>>[];

    for (final item in sessions) {
      final s = (item as Map<String, dynamic>);

      final status = (s["status"] ?? "").toString();
      if (status != wantedStatus) continue;

      final learner = s["learner"];
      final learnerId = (learner is Map) ? learner["_id"]?.toString() : null;
      if (learnerId != myId) continue;

      // skill is populated in backend: populate("skill", "title category level driveLink")
      final skill = s["skill"];
      final title =
          (skill is Map ? skill["title"] : null)?.toString() ?? "Untitled";

      final category =
          (skill is Map ? skill["category"] : null)?.toString() ?? "General";

      final tutor = s["tutor"];
      final tutorName =
          (tutor is Map ? tutor["name"] : null)?.toString() ?? "Tutor";

      // lessons not in backend -> keep placeholder text
      const lessons = "Drive materials";

      list.add({
        "title": title,
        "tutor": tutorName,
        "category": category,
        "lessons": lessons,
      });
    }

    return list;
  }


  static Future<bool> completeSession({required String sessionId}) async {
    final res = await http.patch(
      Uri.parse("$baseUrl/sessions/$sessionId/complete"),
      headers: await _headers(),
    );
    return res.statusCode == 200;
  }
}