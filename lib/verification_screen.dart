import 'package:flutter/material.dart';
import 'home_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Complete Verification"),
        backgroundColor: const Color(0xFFE91E8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Secure Your Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We verify users to ensure a safe and trusted platform.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // STEP 1
            _buildStep(
              title: "Mobile Verification",
              subtitle: "Phone number verified successfully",
              icon: Icons.check_circle,
              color: Colors.green,
              completed: true,
            ),

            const SizedBox(height: 20),

            // STEP 2
            _buildStep(
              title: "Identity Verification",
              subtitle: "Upload College ID / Employee ID / Aadhaar",
              icon: Icons.verified_user,
              color: Colors.orange,
              completed: false,
            ),

            const Spacer(),

            // CONTINUE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool completed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (completed)
            const Icon(Icons.check, color: Colors.green),
        ],
      ),
    );
  }
}