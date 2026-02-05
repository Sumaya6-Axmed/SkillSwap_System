// FILE: lib/app/app_pages.dart
import 'package:get/get.dart';

import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/auth/views/welcome_view.dart';
import '../features/home/views/home_view.dart';

import '../features/courses/views/course_details_view.dart';
import '../features/learning/views/my_learning_view.dart';
import '../features/sessions/views/session_details_view.dart';
import '../features/sessions/views/session_request_view.dart';
import '../features/sessions/views/sessions_list_view.dart';

import '../features/profile/views/profile_view.dart';
import '../features/profile/views/edit_profile_view.dart';
// import '../features/learning/views/learning_view.dart';

import 'app_routes.dart';

class AppPages {
  // This is what main.dart should use
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeView()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView()),

    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.learning, page: () => const MyLearningView()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileView()),

    GetPage(name: AppRoutes.sessionsList, page: () => const SessionsListView()),
    GetPage(name: AppRoutes.sessionRequest, page: () => const SessionRequestView()),

    GetPage(
      name: AppRoutes.courseDetails,
      page: () {
        final args = (Get.arguments ?? {}) as Map;

        return CourseDetailsView(
          title: (args["title"] ?? "Course").toString(),
          tutor: (args["tutor"] ?? "Tutor").toString(),
          category: (args["category"] ?? "General").toString(),
          level: (args["level"] ?? "Beginner").toString(),
          files: (args["files"] ?? "Documents").toString(),
          quiz: (args["quiz"] ?? "Quiz").toString(),
          description: (args["description"] ?? "").toString(),
          driveLink: (args["driveLink"] ?? "https://drive.google.com/").toString(),

          // IDs
          skillId: (args["skillId"] ?? "").toString(),
          tutorId: (args["tutorId"] ?? "").toString(),
          myUserId: (args["myUserId"] ?? "").toString(),
        );
      },
    ),
    GetPage(
      name: AppRoutes.sessionDetails,
      page: () => const SessionDetailsView(

      ),
    ),
  ];
}