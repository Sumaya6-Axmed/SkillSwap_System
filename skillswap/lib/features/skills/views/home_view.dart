// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSwap'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          'Welcome to SkillSwap Home! 💡',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.school, size: 48, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'SkillSwap',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home, 'Home', AppRoutes.home),
          _drawerItem(Icons.book, 'Courses', '/courses'),
          _drawerItem(Icons.message, 'Messages', '/messages'),
          _drawerItem(Icons.person, 'Profile', '/profile'),
          _drawerItem(Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => Get.toNamed(route),
    );
  }
}
