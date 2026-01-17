import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap_app/app/app_routes.dart';
import 'package:skillswap_app/controllers/auth_controller.dart';
import 'package:skillswap_app/controllers/skill_controller.dart';
import 'package:skillswap_app/features/profile/screens/profile_screen.dart';
import 'package:skillswap_app/features/skills/screens/my_skills_screen.dart';
import 'package:skillswap_app/features/skills/screens/skills_feed_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.put(HomeNavController());
    final auth = Get.put(AuthController());
    Get.put(SkillController()); // shared controller for tabs

    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: Text(nav.titles[nav.index.value]),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: auth.logout),
          ],
        ),
        body: IndexedStack(
          index: nav.index.value,
          children: const [
            SkillsFeedScreen(),
            MySkillsScreen(),
            ProfileScreen(),
          ],
        ),
        floatingActionButton: nav.index.value == 1
            ? FloatingActionButton.extended(
                onPressed: () => Get.toNamed(AppRoutes.addSkill),
                icon: const Icon(Icons.add),
                label: const Text("Add Skill"),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.index.value,
          onTap: nav.index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: "My Skills",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

class HomeNavController extends GetxController {
  final index = 0.obs;
  final titles = const ["SkillSwap", "My Skills", "Profile"];
}
