import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'home_screen.dart';
import 'verification_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String verificationId = "";
  bool otpSent = false;

  // 🔹 SEND OTP
  void sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP Sent")));
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // 🔹 VERIFY OTP
  void verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return; // 🔥 IMPORTANT FIX

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerificationScreen()),
      );
    } catch (e) {
      if (!mounted) return; // 🔥 IMPORTANT FIX

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Phone Number",
              ),
            ),

            const SizedBox(height: 20),

            if (!otpSent)
              ElevatedButton(onPressed: sendOtp, child: const Text("Send OTP")),

            if (otpSent) ...[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter OTP",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyOtp,
                child: const Text("Verify OTP"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
