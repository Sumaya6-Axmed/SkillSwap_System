// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../app/app_routes.dart';
// import '../../../core/widgets/app_scaffold.dart';
// import '../../../core/constants/app_colors.dart';
//
// class SkillDetailsView extends StatelessWidget {
//   const SkillDetailsView({super.key});
//
//   Future<void> _openLink(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri == null) {
//       Get.snackbar("Invalid link", "This link is not valid.");
//       return;
//     }
//
//     final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
//     if (!ok) {
//       Get.snackbar("Cannot open", "Your phone could not open this link.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // We expect a skill Map from Get.arguments
//     final Map<String, dynamic> skill =
//     (Get.arguments ?? {}) as Map<String, dynamic>;
//
//     final title = (skill["title"] ?? "Skill").toString();
//     final tutor = (skill["tutor"] ?? "Unknown").toString();
//     final level = (skill["level"] ?? "Beginner").toString();
//     final desc = (skill["desc"] ?? "No description").toString();
//
//     // Option A: one lesson link per skill
//     final lessonVideoUrl = (skill["lessonVideoUrl"] ?? "").toString();
//
//     return AppScaffold(
//       title: "Skill Details",
//       showBack: true, // ✅ back button
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style:
//                 const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//
//             Row(
//               children: [
//                 Text("Tutor: $tutor",
//                     style: const TextStyle(color: Colors.black54)),
//                 const SizedBox(width: 10),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.accent.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Text(
//                     level,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.accent,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 18),
//
//             const Text("Description",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(desc, style: const TextStyle(color: Colors.black87)),
//
//             const SizedBox(height: 22),
//
//             const Text("Recorded Lesson (Optional)",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//
//             if (lessonVideoUrl.trim().isEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.04),
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                   Border.all(color: AppColors.primary.withOpacity(0.08)),
//                 ),
//                 child: const Text(
//                   "No recorded lesson link added.",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               )
//             else
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.04),
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                   Border.all(color: AppColors.primary.withOpacity(0.08)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Drive link available",
//                         style: TextStyle(color: Colors.black54)),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 44,
//                       child: ElevatedButton(
//                         onPressed: () => _openLink(lessonVideoUrl),
//                         child: const Text("Open lesson"),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Tip: Tutor should set sharing to “Anyone with the link”.",
//                       style: TextStyle(fontSize: 12, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//
//             const SizedBox(height: 26),
//
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Get.toNamed(AppRoutes.requestSession);
//                 },
//                 child: const Text("Request Session"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }