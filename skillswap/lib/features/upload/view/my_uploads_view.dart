import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../courses/data/skill_api.dart';
import '../../courses/views/course_details_view.dart';

class MyUploadsView extends StatefulWidget {
  const MyUploadsView({super.key});

  @override
  State<MyUploadsView> createState() => _MyUploadsViewState();
}

class _MyUploadsViewState extends State<MyUploadsView> {
  late final String userId;
  late final Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments ?? {}) as Map;
    userId = (args["userId"] ?? "").toString();

    _future = SkillApi.getAll(); // we filter locally
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const card = Color(0xFF1e293b);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Uploads"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Error:\n${snapshot.error}",
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final all = snapshot.data ?? [];

          //  only uploads where tutor == current user
          final mine = all.where((item) {
            final c = item as Map<String, dynamic>;
            final t = c["tutor"];

            if (t is Map<String, dynamic>) {
              return (t["_id"] ?? "").toString() == userId;
            }
            return (t ?? "").toString() == userId;
          }).toList();

          if (mine.isEmpty) {
            return const Center(
              child: Text(
                "You haven’t uploaded any courses yet.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            itemCount: mine.length,
            itemBuilder: (_, i) {
              final c = mine[i] as Map<String, dynamic>;

              final title = (c["title"] ?? "Untitled").toString();
              final description = (c["description"] ?? "").toString();

              String tutorName = "You";
              String tutorId = "";

              final t = c["tutor"];
              if (t is Map<String, dynamic>) {
                tutorName = (t["name"] ?? "You").toString();
                tutorId = (t["_id"] ?? "").toString();
              } else if (t != null) {
                tutorId = t.toString();
              }

              String driveLink = (c["driveLink"] ?? "").toString();
              if (driveLink.isEmpty && c["videoLinks"] is List) {
                final list = c["videoLinks"] as List;
                if (list.isNotEmpty) driveLink = (list.first ?? "").toString();
              }

              final skillId = (c["_id"] ?? "").toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.upload_file, color: Color(0xFF14b8a6)),
                  title: Text(title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    description.isEmpty ? "No description" : description,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailsView(
                          skillId: skillId,
                          tutorId: tutorId,
                          myUserId:userId,
                          title: title,
                          tutor: tutorName,
                          category: "General",
                          level: "Beginner",
                          files: "Documents",
                          quiz: "Quiz",
                          description: description.isEmpty ? "No description provided." : description,
                          driveLink: driveLink.isEmpty ? "https://drive.google.com/" : driveLink,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}