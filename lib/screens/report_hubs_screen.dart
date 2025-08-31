// lib/screens/reports_hub_screen.dart
import 'package:flutter/material.dart';
import 'sales_management_screen.dart';
import 'sales_report_screen.dart';
import 'low_stock_report_screen.dart';
class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & Reports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHubCard(
            context: context,
            icon: Icons.point_of_sale,
            title: 'Sales Management',
            subtitle: 'View transaction history and record new sales',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SalesManagementScreen(),
                ),
              );
            },
          ),
          _buildHubCard(
            context: context,
            icon: Icons.bar_chart,
            title: 'Sales Report',
            subtitle: 'Analyze revenue and top selling items',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SalesReportScreen(),
                ),
              );
            },
          ),
          _buildHubCard(
            context: context,
            icon: Icons.warning_amber_rounded,
            title: 'Low Stock Report',
            subtitle: 'See items that are running low on stock',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LowStockReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // A reusable helper widget to create each card
  Widget _buildHubCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}