import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';
import '../../../core/services/token_storage.dart';
import '../data/auth_api.dart'; // Step 4 file you created

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const bg = Color(0xFF0f172a);
  static const card = Color(0xFF1e293b);
  static const accent = Color(0xFF14b8a6);

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final e = email.text.trim();
    final p = password.text.trim();

    if (e.isEmpty || p.isEmpty) {
      Get.snackbar(
        "Missing info",
        "Please enter email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => loading = true);

    try {
      final data = await AuthApi.login(email: e, password: p);
      debugPrint("LOGIN DATA => $data");


// save token
      final token = data["token"];
      final userName = (data["user"]?["name"] ?? "User").toString();
      final userId = (data["user"]?["id"] ?? "").toString();
      if (token != null) {
        await TokenStorage.save(token);
        await TokenStorage.saveUser(userId: userId, userName: userName);
      }

      Get.offAllNamed(
        AppRoutes.home,
        arguments: {
          "token": token,
          "name": userName,
          "userId":userId,
          "user":data["user"],
        },
      );    } catch (err) {
      Get.snackbar(
        "Login failed",
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // LOGO / TITLE
                const Icon(Icons.school, size: 70, color: accent),
                const SizedBox(height: 16),
                const Text(
                  "SkillSwap",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Learn. Teach. Grow.",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 40),

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

                      // LOGIN BUTTON
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
                          onPressed: loading ? null : _login,
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
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // REGISTER LINK
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.register),
                        child: const Text(
                          "Create account",
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

  // Reusable Input Field (fixed typing color + cursor)
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      // This ensures typed text is visible
      style: const TextStyle(color: Colors.white),

      //  Cursor color visible too
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