import 'package:get/get.dart';
import 'package:skillswap_app/app/splash_screen.dart';
import 'package:skillswap_app/features/auth/screens/login_screen.dart';
import 'package:skillswap_app/features/auth/screens/register_screen.dart';
import 'package:skillswap_app/features/auth/screens/homeSHell.dart';
import 'package:skillswap_app/features/skills/screens/skill_form_screen.dart';
import 'package:skillswap_app/features/skills/screens/skill_details_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const addSkill = '/add-skill';
  static const skillDetails = '/skill-details';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeShell()),
    GetPage(name: AppRoutes.addSkill, page: () => const SkillFormScreen()),
    GetPage(
      name: AppRoutes.skillDetails,
      page: () => const SkillDetailsScreen(),
    ),
  ];
}
