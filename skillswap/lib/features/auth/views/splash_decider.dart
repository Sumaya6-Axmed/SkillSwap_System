import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/token_storage.dart';
import 'welcome_view.dart';
import '../../home/views/home_view.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();

    // run after first frame so GetX is fully ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _go());
  }

  Future<void> _go() async {
    try {
      // small timeout so it never hangs forever
      final token = await TokenStorage.read().timeout(const Duration(seconds: 3));

      if (token != null && token.isNotEmpty) {
        Get.offAll(() => const HomeView());
      } else {
        Get.offAll(() => const WelcomeView());
      }
    } catch (_) {
      // If anything goes wrong, just go to Welcome
      Get.offAll(() => const WelcomeView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}