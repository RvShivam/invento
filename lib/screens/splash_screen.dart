// lib/screens/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:invento_app/screens/main_screen.dart';
import 'signup_screen.dart';
import 'main_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // This is a placeholder for a real authentication check.
  // In a real app, you would use something like Firebase Auth, SharedPreferences, etc.
  bool _isUserLoggedIn = false; 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 4), () {
      // After 4 seconds, navigate based on the login status
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => _isUserLoggedIn ? const MainScreen() : const SignUpScreen(),
        ),
      );
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF101623), Color(0xFF1A233A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/invento_logo.png',
              width: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Invento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Speak. Track. Sell.',
              style: TextStyle(
                color: Color(0xFF5884FF),
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}