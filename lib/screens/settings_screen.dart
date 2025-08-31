import 'package:flutter/material.dart';
import 'package:invento_app/screens/verification_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/delete_account_dialog.dart';
import 'package:invento_app/screens/profile_screen.dart';
import 'package:invento_app/screens/contact_us_screen.dart';
import 'package:invento_app/screens/faq_screen.dart';

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    debugPrint('Could not launch $url');
  }
}
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsCard(
            context: context,
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // TODO: send code to email
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const VerificationScreen();
              }));
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Support & About'),
          _buildSettingsCard(
            context: context,
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.contact_support_outlined,
            title: 'Contact Support',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              
              _launchURL('https://yourwebsite.com/privacy');
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.gavel_outlined,
            title: 'Terms & Conditions',
            onTap: () {
              _launchURL('https://yourwebsite.com/terms');
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.info_outline,
            title: 'About Invento',
            onTap: () {
              // TODO: Show an 'About' dialog with app version, etc.
            },
          ),
          const SizedBox(height: 32),
          _buildDeleteAccountButton(context),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  // A reusable helper widget for each settings option
  Widget _buildSettingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1C1F2E),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return const DeleteAccountDialog();
          },
          );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text('Delete Account'),
    );
  }
}