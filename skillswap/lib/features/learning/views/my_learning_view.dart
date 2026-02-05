// FILE: lib/features/learning/views/my_learning_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';

class MyLearningView extends StatefulWidget {
  const MyLearningView({super.key});

  @override
  State<MyLearningView> createState() => _MyLearningViewState();
}

class _MyLearningViewState extends State<MyLearningView> {
  int tabIndex = 0; // 0 = In Progress, 1 = Completed

  late Future<List<Map<String, dynamic>>> _inProgressFuture;
  late Future<List<Map<String, dynamic>>> _completedFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _inProgressFuture = ApiService.getMyLearningCourses(completed: false);
    _completedFuture = ApiService.getMyLearningCourses(completed: true);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const card = Color(0xFF1e293b);
    const accent = Color(0xFF14b8a6);

    final future = tabIndex == 0 ? _inProgressFuture : _completedFuture;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "My Learning",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: "goHome"),
        ),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: () => setState(_load),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          //  Tabs (Saved removed)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: _TabChip(
                    label: "In Progress",
                    active: tabIndex == 0,
                    onTap: () => setState(() => tabIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabChip(
                    label: "Completed",
                    active: tabIndex == 1,
                    onTap: () => setState(() => tabIndex = 1),
                  ),
                ),
              ],
            ),
          ),

          //  List (no progress bar anymore)
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: accent),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Error loading learning:\n${snapshot.error}",
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final list = snapshot.data ?? [];

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      tabIndex == 0
                          ? "No courses in progress yet."
                          : "No completed courses yet.",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final c = list[i];

                    final title = (c["title"] ?? "Untitled").toString();
                    final tutor = (c["tutor"] ?? "Tutor").toString();
                    final category = (c["category"] ?? "General").toString();
                    final lessons = (c["lessons"] ?? "Drive materials").toString();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.menu_book,
                                color: accent, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "By $tutor • $category • $lessons",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Button (kept same behavior)
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Open course (next step)"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.white54),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF14b8a6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? accent : Colors.white12,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? accent : Colors.white12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}