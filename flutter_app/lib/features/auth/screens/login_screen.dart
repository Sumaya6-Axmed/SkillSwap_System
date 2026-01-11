import 'package:flutter/material.dart';
import 'package:skillswap_app/features/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  // ==============================
  // LOGIN FUNCTION (DHAMEYSTIRAN)
  // ==============================
  Future<void> handleLogin() async {
    setState(() => loading = true);

    try {
      final success = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==============================
            // EMAIL FIELD
            // ==============================
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // ==============================
            // PASSWORD FIELD
            // ==============================
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            // ==============================
            // LOGIN BUTTON
            // ==============================
            ElevatedButton(
              onPressed: loading ? null : handleLogin,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),

            // ==============================
            // 🆕 REGISTER LINK (KAN WAA CUSUB)
            // ==============================
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create new account'),
            ),
          ],
        ),
      ),
    );
  }
}
