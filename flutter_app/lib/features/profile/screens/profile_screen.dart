import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap_app/controllers/auth_controller.dart';
import 'package:skillswap_app/controllers/skill_controller.dart';
import 'package:skillswap_app/utils/storage_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final skills = Get.find<SkillController>();

    final email = StorageHelper.email() ?? "Unknown email";
    final userId = StorageHelper.userId() ?? "-";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Color(0x11000000)),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "User ID: $userId",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Obx(
            () => _StatRow(
              leftTitle: "My Skills",
              leftValue: skills.mine.length.toString(),
              rightTitle: "All Skills",
              rightValue: skills.feed.length.toString(),
            ),
          ),

          const SizedBox(height: 14),

          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.refresh),
            title: const Text("Refresh my skills"),
            onTap: () async {
              await skills.loadMine();
              Get.snackbar("Done", "My skills refreshed");
            },
          ),

          const SizedBox(height: 10),

          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: auth.logout,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;

  const _StatRow({
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    Widget box(String title, String value) {
      return Expanded(
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
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        box(leftTitle, leftValue),
        const SizedBox(width: 12),
        box(rightTitle, rightValue),
      ],
    );
  }
}
