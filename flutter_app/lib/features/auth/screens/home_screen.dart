import 'package:flutter/material.dart';
import 'package:skillswap_app/utils/storage_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> handleLogout(BuildContext context) async {
    await StorageHelper.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to SkillSwap 🎉',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
