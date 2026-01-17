import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkillDetailsScreen extends StatelessWidget {
  const SkillDetailsScreen({super.key});

  
  // FORMAT CREATOR DISPLAY
 
  String _creatorText(dynamic creator) {
    // creator may be String (userId) OR Map (populated user)
    if (creator == null) return "Unknown";

    if (creator is String) {
      // backend didn’t populate user
      return "User ID: $creator";
    }

    if (creator is Map) {
      final name = (creator["name"] ?? "").toString().trim();
      final email = (creator["email"] ?? "").toString().trim();

      if (name.isNotEmpty && email.isNotEmpty) {
        return "$name • $email";
      }
      if (name.isNotEmpty) return name;
      if (email.isNotEmpty) return email;
    }

    return "Unknown";
  }

 
  // REQUEST SESSION (UI ONLY)
 
  void _requestSession(String skillName) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handshake_outlined, size: 36),
            const SizedBox(height: 10),
            const Text(
              "Request Session",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "You are requesting a session for:\n$skillName",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    "Request Sent",
                    "Your request was recorded (UI only).",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text("Confirm Request"),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

   
    // SAFETY CHECK
   
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Skill data not available",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final Map<String, dynamic> skill = args;

    final name = (skill["name"] ?? "").toString();
    final category = (skill["category"] ?? "").toString();
    final description = (skill["description"] ?? "").toString();
    final creator = _creatorText(skill["creator"]);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: const Text("Skill Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           
            // DETAILS CARD
           
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Color(0x11000000)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skill Name
                  Text(
                    name.isEmpty ? "Skill" : name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Creator
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          creator,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.indigo),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Description
                  Text(
                    description.isEmpty
                        ? "No description provided."
                        : description,
                    style: const TextStyle(height: 1.4),
                  ),
                ],
              ),
            ),

            const Spacer(),

           
            // REQUEST SESSION BUTTON
           
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.handshake_outlined),
                label: const Text("Request Session"),
                onPressed: () => _requestSession(name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
