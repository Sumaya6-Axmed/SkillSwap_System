import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap_app/app/app_routes.dart';
import 'package:skillswap_app/controllers/skill_controller.dart';

class SkillsFeedScreen extends StatelessWidget {
  const SkillsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SkillController>();

    if (c.feed.isEmpty) {
      Future.microtask(c.loadFeed);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => c.search.value = v,
            decoration: InputDecoration(
              hintText: "Search skills...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (c.isLoadingFeed.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = c.filteredFeed;
              if (data.isEmpty) {
                return const Center(child: Text("No skills found"));
              }

              return RefreshIndicator(
                onRefresh: c.loadFeed,
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _SkillCard(skill: data[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    final name = (skill["name"] ?? "").toString();
    final category = (skill["category"] ?? "").toString();
    final desc = (skill["description"] ?? "").toString();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.toNamed(
          AppRoutes.skillDetails,
          arguments: skill, // ✅ PASS FULL OBJECT
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(blurRadius: 10, color: Color(0x11000000)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                category,
                style: const TextStyle(color: Colors.indigo),
              ),
            ),
            if (desc.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(desc, style: const TextStyle(color: Colors.black87)),
            ],
          ],
        ),
      ),
    );
  }
}
