import 'package:flutter/material.dart';
import 'authority_dashboard_screen.dart';

class AuthorityLoginScreen extends StatefulWidget {
  const AuthorityLoginScreen({super.key});

  @override
  State<AuthorityLoginScreen> createState() => _AuthorityLoginScreenState();
}

class _AuthorityLoginScreenState extends State<AuthorityLoginScreen> {
  final TextEditingController codeController = TextEditingController();

  void login() {
    if (codeController.text == "ADMIN123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthorityDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid Authority Code")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authority Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text("Enter Authority Code", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Code",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
