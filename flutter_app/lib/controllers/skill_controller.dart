import 'package:get/get.dart';
import 'package:skillswap_app/services/skill_service.dart';

class SkillController extends GetxController {
  final _service = SkillService();

  final isLoadingFeed = false.obs;
  final isLoadingMine = false.obs;

  final feed = <Map<String, dynamic>>[].obs;
  final mine = <Map<String, dynamic>>[].obs;

  final search = "".obs;

  List<Map<String, dynamic>> get filteredFeed {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return feed;
    return feed.where((s) {
      final name = (s["name"] ?? "").toString().toLowerCase();
      final cat = (s["category"] ?? "").toString().toLowerCase();
      final desc = (s["description"] ?? "").toString().toLowerCase();
      return name.contains(q) || cat.contains(q) || desc.contains(q);
    }).toList();
  }

  Future<void> loadFeed() async {
    try {
      isLoadingFeed.value = true;
      feed.value = await _service.getAll();
    } finally {
      isLoadingFeed.value = false;
    }
  }

  Future<void> loadMine() async {
    try {
      isLoadingMine.value = true;
      mine.value = await _service.getMine();
    } finally {
      isLoadingMine.value = false;
    }
  }

  Future<void> createSkill({
    required String name,
    required String category,
    String? description,
  }) async {
    await _service.create(
      name: name,
      category: category,
      description: description,
    );
    await loadFeed();
    await loadMine();
  }

  Future<void> updateSkill({
    required String id,
    required String name,
    required String category,
    String? description,
  }) async {
    await _service.update(
      id: id,
      name: name,
      category: category,
      description: description,
    );
    await loadFeed();
    await loadMine();
  }

  Future<void> deleteSkill(String id) async {
    await _service.remove(id);
    mine.removeWhere((e) => e["_id"] == id);
    feed.removeWhere((e) => e["_id"] == id);
  }

  // ✅ ADD THIS INSIDE THE CLASS
  Future<Map<String, dynamic>> fetchSkillById(String id) async {
    final s = await _service.getById(id);
    return s;
  }
}
