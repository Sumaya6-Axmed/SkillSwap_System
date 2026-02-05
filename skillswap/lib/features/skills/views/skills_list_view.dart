// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../app/app_routes.dart';
// import '../../../core/widgets/app_scaffold.dart';
// import '../../../core/constants/app_colors.dart';
//
// class SkillsListView extends StatelessWidget {
//   const SkillsListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Dummy data for now (later we’ll fetch from backend)
//     final skills = [
//       {
//         "title": "Java Basics",
//         "tutor": "Sumaya",
//         "level": "Beginner",
//         "desc": "Learn variables, loops, and functions.",
//       },
//       {
//         "title": "Networking Fundamentals",
//         "tutor": "Ahmed",
//         "level": "Intermediate",
//         "desc": "IP addressing, routing, and protocols.",
//       },
//       {
//         "title": "Canva Design",
//         "tutor": "Hodan",
//         "level": "Beginner",
//         "desc": "Design posters and presentations quickly.",
//       },
//     ];
//
//     return AppScaffold(
//       title: "Skills",
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
//                 label: const Text("Add Skill"),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search skills...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: AppColors.primary.withOpacity(0.04),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // List of skills
//             Expanded(
//               child: ListView.builder(
//                 itemCount: skills.length,
//                 itemBuilder: (context, index) {
//                   final s = skills[index];
//                   return _SkillCard(
//                     title: s["title"]!,
//                     tutor: s["tutor"]!,
//                     level: s["level"]!,
//                     desc: s["desc"]!,
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
//
// class _SkillCard extends StatelessWidget {
//   final String title;
//   final String tutor;
//   final String level;
//   final String desc;
//
//   const _SkillCard({
//     required this.title,
//     required this.tutor,
//     required this.level,
//     required this.desc,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.primary.withOpacity(0.08)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 6),
//
//           Row(
//             children: [
//               Text("Tutor: $tutor", style: const TextStyle(color: Colors.black54)),
//               const SizedBox(width: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppColors.accent.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//                 child: Text(
//                   level,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.accent,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//           Text(desc, style: const TextStyle(color: Colors.black87)),
//           const SizedBox(height: 12),
//
//           SizedBox(
//             width: double.infinity,
//             height: 44,
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.toNamed(
//                   AppRoutes.skillDetails,
//                   arguments: {
//                     "title": title,
//                     "tutor": tutor,
//                     "level": level,
//                     "desc": desc,
//                     "lessonVideoUrl": "https://drive.google.com/your-link-here",
//                   },
//                 );
//               },
//               child: const Text("View"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }