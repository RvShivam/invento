// lib/screens/verification_screen.dart
import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Check Your Email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "We've sent a 6-digit code to your email. Please enter it below to proceed.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            // In a real app, you might use a package like 'pinput' for a better code field
            const TextField(
              decoration: InputDecoration(hintText: '6-Digit Code'),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to the reset password screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                );
              },
              child: const Text('Verify Code'),
            ),
            const SizedBox(height: 24),
            Text(
              "Didn't receive the code? Resend",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}