import 'package:flutter/material.dart';
import 'package:skillswap_app/app/splash_screen.dart';
import 'package:skillswap_app/features/auth/screens/home_screen.dart';
import 'package:skillswap_app/features/auth/screens/login_screen.dart';
import 'package:skillswap_app/features/auth/screens/register_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const register = '/register';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
  };
}
