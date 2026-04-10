import 'package:flutter/material.dart';
import 'user_login_screen.dart';
import 'authority_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE91E8C), Color(0xFFAD1457)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔰 LOGO
                const Icon(Icons.shield, size: 90, color: Colors.white),

                const SizedBox(height: 20),

                // 🔤 APP NAME
                const Text(
                  "NariRakshak",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 8),

                // 🧾 TAGLINE
                const Text(
                  "Community Driven Women Safety",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 50),

                // 🔴 LOGIN AS USER
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserLoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login as User",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔵 LOGIN AS AUTHORITY
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthorityLoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login as Authority",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 30),

                // 🧠 SMALL TRUST LINE (VERY IMPACTFUL)
                const Text(
                  "Secure • Verified • Women Only",
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
