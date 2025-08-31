import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // Helper to launch URLs (mailto for email, tel for phone)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildContactCard(
            context: context,
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'support@invento.com',
            onTap: () => _launchURL('mailto:support@invento.com'),
          ),
          _buildContactCard(
            context: context,
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+91 12345 67890',
            onTap: () => _launchURL('tel:+911234567890'),
          ),
          _buildContactCard(
            context: context,
            icon: Icons.web_asset_outlined,
            title: 'Visit Our Website',
            subtitle: 'www.invento.com',
            onTap: () => _launchURL('https://www.invento.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1C1F2E),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}