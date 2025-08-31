import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO:fetch the user's current data
  final _nameController = TextEditingController(text: 'Your Name');
  final _emailController = TextEditingController(text: 'your.email@example.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your Name',
            suffixIcon: Icon(Icons.edit, color: Colors.white54,)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address',
            suffixIcon: Icon(Icons.edit, color: Colors.white54,)),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Call a service to update the user's profile
            Navigator.of(context).pop();
          },
          child: const Text('Save Changes'),
        ),
      ),
    );
  }
}