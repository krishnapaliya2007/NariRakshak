import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NariRakshakApp());
}

class NariRakshakApp extends StatelessWidget {
  const NariRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NariRakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E8C)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Run minimum splash time
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    User? user = FirebaseAuth.instance.currentUser;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            user != null ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E8C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield, size: 100, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'NariRakshak',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Community Driven Women Safety',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
