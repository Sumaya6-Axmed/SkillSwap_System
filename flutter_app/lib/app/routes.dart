import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/skills/screens/skills_screen.dart';
import '../features/sessions/screens/sessions_screen.dart';
import '../features/quiz/screens/quiz_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String skills = '/skills';
  static const String sessions = '/sessions';
  static const String quiz = '/quiz';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    skills: (context) => const SkillsScreen(),
    sessions: (context) => const SessionsScreen(),
    quiz: (context) => const QuizScreen(),
    profile: (context) => const ProfileScreen(),
  };
}
