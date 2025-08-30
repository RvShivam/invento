// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_nav_bar.dart'; // Import the new widget
import 'dashboard_screen.dart';
//import 'inventory_screen.dart';
import 'assistant_screen.dart';
//import 'chat_screen.dart';
//import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of the main screens in your app
  static const List<Widget> _pages = <Widget>[
    DashboardScreen(),
    //InventoryScreen(),
    AssistantScreen(),
    //ChatScreen(),
    //SettingsScreen(),
  ];

  // This function updates the state when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the currently selected page
      body: _pages[_selectedIndex],
      // Use your reusable bottom navigation bar here
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}