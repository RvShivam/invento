// lib/models/dashboard_data.dart
import 'package:fl_chart/fl_chart.dart'; 
class Order {
  final String customerName;
  final String orderId;
  final String amount;

  Order({required this.customerName, required this.orderId, required this.amount});
}

class DashboardData {
  final String totalInventoryValue;
  final int lowStockItems;
  final String todaysSales;
  final String totalSales;
  final String averageOrderValue;
  final List<Order> recentOrders;
  final List<FlSpot> salesTrendData; 

  DashboardData({
    required this.totalInventoryValue,
    required this.lowStockItems,
    required this.todaysSales,
    required this.totalSales,
    required this.averageOrderValue,
    required this.recentOrders,
    required this.salesTrendData, 
  });
}