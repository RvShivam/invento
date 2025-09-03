import 'package:flutter/material.dart';
import 'package:invento_app/screens/verification_screen.dart';
import 'package:invento_app/services/auth_service.dart';
import 'package:invento_app/services/profile_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/delete_account_dialog.dart';
import 'package:invento_app/screens/profile_screen.dart';
import 'package:invento_app/screens/contact_us_screen.dart';
import 'package:invento_app/screens/faq_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  final _profileService = ProfileService();
  bool _isLoading = false;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _handleChangePassword() async {
    setState(() => _isLoading = true);
    
    final email = await _profileService.getUserEmail();

    if (email == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not retrieve user email.')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }
    
    final result = await _authService.sendOtp(email);
    
    if (mounted) {
      if (result['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An OTP has been sent to $email')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VerificationScreen(email: email);
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Please try again.')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await _authService.logout();
    if(mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
    setState(() => _isLoading = false);
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2D3E),
          title: const Text('About Invento'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Invento - Speak. Track. Sell.'),
                SizedBox(height: 12),
                Text('Version: 1.0.0'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

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
            onTap: _isLoading ? () {} : _handleChangePassword,
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: _isLoading ? () {} : _handleLogout,
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
            onTap: () => _showAboutDialog(context),
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