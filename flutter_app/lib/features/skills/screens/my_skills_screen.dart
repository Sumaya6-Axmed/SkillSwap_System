import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap_app/controllers/skill_controller.dart';
import 'package:skillswap_app/app/app_routes.dart';

class MySkillsScreen extends StatelessWidget {
  const MySkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SkillController>();

    if (c.mine.isEmpty) {
      Future.microtask(c.loadMine);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (c.isLoadingMine.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.mine.isEmpty) {
          return const Center(child: Text("You haven't added any skills yet."));
        }

        return RefreshIndicator(
          onRefresh: c.loadMine,
          child: ListView.separated(
            itemCount: c.mine.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final s = c.mine[i];
              return _MySkillCard(
                skill: s,
                onEdit: () => Get.toNamed(AppRoutes.addSkill, arguments: s),
                onDelete: () async {
                  final ok =
                      await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text("Delete Skill?"),
                          content: const Text(
                            "Are you sure you want to delete this skill?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (ok) {
                    await c.deleteSkill(s["_id"]);
                    Get.snackbar("Deleted", "Skill removed successfully");
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _MySkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MySkillCard({
    required this.skill,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = (skill["name"] ?? "").toString();
    final category = (skill["category"] ?? "").toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(category, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
