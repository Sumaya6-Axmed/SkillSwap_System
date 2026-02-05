// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../core/widgets/app_scaffold.dart';
// import '../../../core/widgets/app_text_field.dart';
// import '../../../core/constants/app_colors.dart';
//
// class AddSkillView extends StatelessWidget {
//   const AddSkillView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final titleController = TextEditingController();
//     final descController = TextEditingController();
//     final lessonLinkController = TextEditingController();
//
//     String selectedLevel = "Beginner";
//
//     return AppScaffold(
//       title: "Add Skill",
//       showBack: true, // ✅ back button
//       body: StatefulBuilder(
//         builder: (context, setState) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppTextField(
//                   label: "Skill title",
//                   hint: "e.g., Java Basics",
//                   controller: titleController,
//                 ),
//                 const SizedBox(height: 14),
//
//                 const Text("Level", style: TextStyle(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 8),
//                 DropdownButtonFormField<String>(
//                   value: selectedLevel,
//                   items: const [
//                     DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
//                     DropdownMenuItem(value: "Intermediate", child: Text("Intermediate")),
//                     DropdownMenuItem(value: "Advanced", child: Text("Advanced")),
//                   ],
//                   onChanged: (val) => setState(() => selectedLevel = val ?? "Beginner"),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 const Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: descController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: "Write what the student will learn...",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//
//                 const SizedBox(height: 18),
//
//                 const Text(
//                   "Recorded Lesson (Optional)",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//
//                 TextField(
//                   controller: lessonLinkController,
//                   decoration: InputDecoration(
//                     hintText: "Paste Google Drive link (https://drive.google.com/...)",
//                     prefixIcon: const Icon(Icons.link),
//                     filled: true,
//                     fillColor: AppColors.primary.withOpacity(0.04),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Tip: Make sure Drive sharing is set to “Anyone with the link”.",
//                   style: TextStyle(fontSize: 12, color: Colors.black54),
//                 ),
//
//                 const SizedBox(height: 22),
//
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Demo validation
//                       final title = titleController.text.trim();
//                       final link = lessonLinkController.text.trim();
//
//                       if (title.isEmpty) {
//                         Get.snackbar("Missing", "Please enter skill title.");
//                         return;
//                       }
//
//                       if (link.isNotEmpty &&
//                           !(link.startsWith("http://") || link.startsWith("https://"))) {
//                         Get.snackbar("Invalid link", "Lesson link must start with http:// or https://");
//                         return;
//                       }
//
//                       Get.snackbar("Saved", "Skill added (demo).");
//                       Get.back(); // later: go to Skills list + refresh
//                     },
//                     child: const Text("Save Skill"),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }