// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../core/widgets/app_scaffold.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../app/app_routes.dart';
//
// class MySkillsView extends StatelessWidget {
//   const MySkillsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Dummy "skills I posted" for now
//     final mySkills = [
//       {
//         "title": "Java Basics",
//         "level": "Beginner",
//         "desc": "Variables, loops, functions.",
//         "lessonVideoUrl": "https://drive.google.com/your-link-here",
//       },
//       {
//         "title": "Flutter UI",
//         "level": "Intermediate",
//         "desc": "Build clean screens with GetX.",
//         "lessonVideoUrl": "",
//       },
//     ];
//
//     return AppScaffold(
//       title: "My Skills",
//       showBack: true, // ✅ back button
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: OutlinedButton.icon(
//                 onPressed: () => Get.toNamed(AppRoutes.addSkill),
//                 icon: const Icon(Icons.add),
//                 label: const Text("Add New Skill"),
//               ),
//             ),
//             const SizedBox(height: 14),
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: mySkills.length,
//                 itemBuilder: (context, i) {
//                   final s = mySkills[i];
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       border:
//                       Border.all(color: AppColors.primary.withOpacity(0.08)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           s["title"] ?? "",
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 6),
//
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: AppColors.accent.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(999),
//                           ),
//                           child: Text(
//                             s["level"] ?? "",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.accent,
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 10),
//                         Text(s["desc"] ?? "",
//                             style: const TextStyle(color: Colors.black87)),
//
//                         const SizedBox(height: 14),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   // later: open edit skill screen
//                                   Get.snackbar("Demo", "Edit will be added later.");
//                                 },
//                                 child: const Text("Edit"),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // open details (reuse skill details screen)
//                                   Get.toNamed(
//                                     AppRoutes.skillDetails,
//                                     arguments: {
//                                       "title": s["title"],
//                                       "tutor": "Me",
//                                       "level": s["level"],
//                                       "desc": s["desc"],
//                                       "lessonVideoUrl": s["lessonVideoUrl"],
//                                     },
//                                   );
//                                 },
//                                 child: const Text("View"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }