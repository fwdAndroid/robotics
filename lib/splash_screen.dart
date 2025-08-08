import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robotics/screens/auth/login_screen.dart';
import 'package:robotics/screens/main_dashboard.dart'; // Your main dashboard screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in → go to main dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboard()),
      );
    } else {
      // User not logged in → go to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/logo.png', height: 200)),
    );
  }
}
