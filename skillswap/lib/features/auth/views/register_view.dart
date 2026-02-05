import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';
import '../../../core/services/token_storage.dart';
import '../data/auth_api.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  static const bg = Color(0xFF0f172a);
  static const card = Color(0xFF1e293b);
  static const accent = Color(0xFF14b8a6);

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final n = name.text.trim();
    final e = email.text.trim();
    final p = password.text.trim();

    if (n.isEmpty || e.isEmpty || p.isEmpty) {
      Get.snackbar(
        "Missing info",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => loading = true);

    try {
      final data = await AuthApi.register(name: n, email: e, password: p);

//  save token
      final token = data["token"];
      if (token != null) {
        await TokenStorage.save(token);
      }

      Get.offAllNamed(AppRoutes.home, arguments: data);
    } catch (err) {
      Get.snackbar(
        "Register failed",
        err.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text("Create account"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // LOGO / TITLE
                const Icon(Icons.school, size: 70, color: accent),
                const SizedBox(height: 16),
                const Text(
                  "Join SkillSwap",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Create your account to start learning.",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 30),

                // CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      _input(
                        controller: name,
                        hint: "Full name",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 14),
                      _input(
                        controller: email,
                        hint: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 14),
                      _input(
                        controller: password,
                        hint: "Password",
                        icon: Icons.lock,
                        obscure: true,
                      ),
                      const SizedBox(height: 20),

                      // CREATE ACCOUNT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: loading ? null : _register,
                          child: loading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                              : const Text(
                            "Create account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: const Text(
                          "Back to login",
                          style: TextStyle(color: accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Field (typing visible + cursor visible)
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}