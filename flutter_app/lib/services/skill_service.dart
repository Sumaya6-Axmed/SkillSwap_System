import 'package:dio/dio.dart';
import 'package:skillswap_app/app/core/api_client.dart';

class SkillService {
  final Dio _dio = ApiClient.dio;

  static const String base = "/api/skills";

 
  // GET ALL SKILLS

  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _dio.get(base);
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }


  // GET MY SKILLS

  Future<List<Map<String, dynamic>>> getMine() async {
    final res = await _dio.get("$base/my");
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  
  // GET SINGLE SKILL BY ID  ✅ ADD
  
  Future<Map<String, dynamic>> getById(String id) async {
    final res = await _dio.get("$base/$id");
    return Map<String, dynamic>.from(res.data);
  }


  // CREATE SKILL

  Future<Map<String, dynamic>> create({
    required String name,
    required String category,
    String? description,
  }) async {
    final res = await _dio.post(
      base,
      data: {
        "name": name,
        "category": category,
        "description": description ?? "",
      },
    );
    return Map<String, dynamic>.from(res.data);
  }


  // UPDATE SKILL

  Future<Map<String, dynamic>> update({
    required String id,
    required String name,
    required String category,
    String? description,
  }) async {
    final res = await _dio.put(
      "$base/$id",
      data: {
        "name": name,
        "category": category,
        "description": description ?? "",
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  // DELETE SKILL

  Future<void> remove(String id) async {
    await _dio.delete("$base/$id");
  }
}
