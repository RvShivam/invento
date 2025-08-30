// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import the screens you want to test
import 'package:invento_app/screens/signup_screen.dart';
import 'package:invento_app/screens/login_screen.dart';
import 'package:invento_app/screens/dashboard_screen.dart';

void main() {
  // Test group for Authentication Screens
  group('Authentication Screens', () {
    
    testWidgets('SignUpScreen UI and navigation', (WidgetTester tester) async {
      // ARRANGE: Build the widget tree
      // We need to wrap our screen in MaterialApp to provide context like navigation
      await tester.pumpWidget(MaterialApp(
        // We define routes to handle the navigation triggered by button taps
        routes: {
          '/': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        initialRoute: '/',
      ));

      // ASSERT: Check if the main widgets are on the screen
      expect(find.text('Create Your Account'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3)); // Name, Email, Password
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // ACT: Simulate tapping the 'Sign Up' button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      // Rebuild the widget tree to reflect the navigation
      await tester.pumpAndSettle(); 

      // ASSERT: Verify that we have navigated to the DashboardScreen
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    
    testWidgets('LoginScreen UI and navigation', (WidgetTester tester) async {
      // ARRANGE: Build the LoginScreen
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        initialRoute: '/',
      ));

      // ASSERT: Check for key widgets
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email, Password
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);

      // ACT: Simulate tapping the 'Log In' button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle();

      // ASSERT: Verify navigation to the DashboardScreen
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });
}