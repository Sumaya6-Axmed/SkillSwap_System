import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../../../core/services/token_storage.dart';
import '../../upload/view/my_uploads_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data (frontend-only for now)
    final args = (Get.arguments ?? {}) as Map;
    final name = (args["name"] ?? "User").toString();    const role = "Learner • Tutor";
    const bio = "Learning, sharing, and building skills with the community.";

    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f172a),
        title: const Text("Profile"),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: "goHome"),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(name: name, role: role, bio: bio),
          const SizedBox(height: 18),

          _SectionTitle(title: "Quick actions"),
          const SizedBox(height: 10),

          _ActionTile(
            icon: Icons.school_outlined,
            title: "My Learning",
            subtitle: "Continue where you left off",
            onTap: () {
              // ✅ If you already have a route, use it:
              // Get.toNamed(AppRoutes.myLearning);

              // ✅ If not, keep this for now:
              Get.toNamed(AppRoutes.learning);
            },
          ),

          _ActionTile(
            icon: Icons.upload_file_outlined,
            title: "My Uploads",
            subtitle: "Courses you shared",
            onTap: () {
              final args = (Get.arguments ?? {}) as Map;
              final userId = (args["userId"] ?? "").toString();

              Get.to(
                    () => const MyUploadsView(),
                arguments: {"userId": userId},
              );
            },
          ),

          const SizedBox(height: 16),

          _LogoutButton(
            onTap: () async {
              await TokenStorage.logout();
              Get.offAllNamed(AppRoutes.welcome);
            },
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String bio;

  const _HeaderCard({
    required this.name,
    required this.role,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF14b8a6).withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: Color(0xFF14b8a6), size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bio,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF14b8a6).withOpacity(0.18),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF14b8a6)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.65)),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.logout),
      label: const Text("Logout"),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withOpacity(0.18)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}