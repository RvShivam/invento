// lib/services/dashboard_service.dart
import 'dart:async';
import 'package:fl_chart/fl_chart.dart'; // Import the package
import '../models/dashboard_data.dart';

class DashboardService {
  Future<DashboardData> fetchDashboardData() async {
    await Future.delayed(const Duration(seconds: 2));

    return DashboardData(
      totalInventoryValue: '₹1,50,230',
      lowStockItems: 10,
      todaysSales: '₹5,450',
      totalSales: '₹1,250,000',
      averageOrderValue: '₹1,000',
      recentOrders: [
        Order(customerName: 'Vikram Sharma', orderId: 'Order #12345', amount: '₹12,500'),
        Order(customerName: 'Priya Verma', orderId: 'Order #12346', amount: '₹8,200'),
        Order(customerName: 'Rohan Patel', orderId: 'Order #12347', amount: '₹15,800'),
      ],

      salesTrendData: const [
        FlSpot(0, 3),   // Jan
        FlSpot(1, 5),   // Feb
        FlSpot(2, 4),   // Mar
        FlSpot(3, 6.5), // Apr
        FlSpot(4, 5.5), // May
        FlSpot(5, 7.5), // Jun
        FlSpot(6, 6),   // Jul
        FlSpot(7, 8),   // Aug
        FlSpot(8, 5),   // Sep
        FlSpot(9, 9.5), // Oct
        FlSpot(10, 8),  // Nov
        FlSpot(11, 10), // Dec
      ],
    );
  }
}