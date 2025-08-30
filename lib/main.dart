// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const InventoApp());
}

class InventoApp extends StatelessWidget {
  const InventoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invento',
      debugShowCheckedModeBanner: false,
      // Define the dark theme based on your designs
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1217),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF568CFF), // Blue for buttons
          secondary: Color(0xFF262D3A), // Color for text fields
          onSecondary: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF262D3A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
          hintStyle: const TextStyle(color: Color(0xFF99A5BC)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF568CFF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}