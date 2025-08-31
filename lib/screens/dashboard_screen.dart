// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_data.dart';
import '../services/dashboard_service.dart';
import 'add_item.dart';
import 'sales_management_screen.dart';
import 'sales_report_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = DashboardService().fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<DashboardData>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard('Total Inventory Value', data.totalInventoryValue),
                  const SizedBox(height: 16),
                  _buildInfoCard('Items Low on Stock', data.lowStockItems.toString()),
                  const SizedBox(height: 16),
                  _buildInfoCard("Today's Sales", data.todaysSales),
                  const SizedBox(height: 32),
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  _buildStatsGrid(data),
                  const SizedBox(height: 16),
                  _buildSalesTrendCard(data),
                  const SizedBox(height: 32),
                  const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRecentOrders(data.recentOrders),
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
  

  Widget _buildInfoCard(String title, String value) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 1. Add New Item
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddItemScreen()),
                  );
                },
                child: const Text('Add Item'),
              ),
            ),
            const SizedBox(width: 16),
            // 2. Low Stock Report
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LowStockReportScreen()),
                  );*/
                },
                child: const Text('Low Stock'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // 3. Sales Report
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SalesReportScreen()),
                  );
                },
                child: const Text('Sales Report'),
              ),
            ),
            const SizedBox(width: 16),
            // 4. Manage Sales
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SalesManagementScreen()),
                  );
                },
                child: const Text('Manage Sales'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardData data) {
    return Row(
      children: [
        Expanded(child: _buildStatsCard('Total Sales', data.totalSales)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatsCard('Average Order Value', data.averageOrderValue)),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTrendCard(DashboardData data) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sales Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text('+15%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(width: 8),
                Text('Last 3 Months', style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 120,
              child: _buildLineChart(data.salesTrendData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> spots) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
                Widget text;
                switch (value.toInt()) {
                  case 2:
                    text = const Text('Mar', style: style);
                    break;
                  case 6:
                    text = const Text('Jul', style: style);
                    break;
                  case 10:
                    text = const Text('Nov', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(axisSide: meta.axisSide, child: text);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.white,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(List<Order> orders) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: orders.asMap().entries.map((entry) {
          int idx = entry.key;
          Order order = entry.value;
          return _buildOrderTile(order.customerName, order.orderId, order.amount, idx == orders.length - 1);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderTile(String customer, String orderId, String amount, bool isLast) {
    return Column(
      children: [
        ListTile(
          title: Text(customer, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(orderId, style: const TextStyle(color: Colors.white70)),
          trailing: Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        if (!isLast) const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}