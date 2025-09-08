// lib/models/dashboard_data.dart

class Order {
  final String customerName;
  final String orderId;
  final String amount;

  Order({required this.customerName, required this.orderId, required this.amount});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customerName: json['customer_name'],
      orderId: json['order_id'],
      amount: '₹${double.parse(json['total_amount'].toString()).toStringAsFixed(2)}',
    );
  }
}

class DashboardData {
  final String totalInventoryValue;
  final int lowStockItems;
  final String todaysSales;
  final String totalSales;
  final String averageOrderValue;
  final List<Order> recentOrders;
  final List<(double x, double y, String date)> salesTrendData;
  final double salesTrendPercentage; 

  DashboardData({
    required this.totalInventoryValue,
    required this.lowStockItems,
    required this.todaysSales,
    required this.totalSales,
    required this.averageOrderValue,
    required this.recentOrders,
    required this.salesTrendData,
    required this.salesTrendPercentage, 
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    var orderList = json['recentOrders'] as List;
    List<Order> orders = orderList.map((i) => Order.fromJson(i)).toList();

    var trendList = json['salesTrendData'] as List;
    List<(double, double, String)> trendData = trendList.map((point) {
      return (
        (point['x'] as int).toDouble(),
        (point['y'] as double),
        point['date'] as String,
      );
    }).toList();

    return DashboardData(
      totalInventoryValue: '₹${double.parse(json['totalInventoryValue'].toString()).toStringAsFixed(2)}',
      lowStockItems: json['lowStockItems'],
      todaysSales: '₹${double.parse(json['todaysSales'].toString()).toStringAsFixed(2)}',
      totalSales: '₹${double.parse(json['totalSales'].toString()).toStringAsFixed(2)}',
      averageOrderValue: '₹${double.parse(json['averageOrderValue'].toString()).toStringAsFixed(2)}',
      recentOrders: orders,
      salesTrendData: trendData.isNotEmpty ? trendData : [(0, 0, '')],
      salesTrendPercentage: double.parse(json['salesTrendPercentage'].toString()),
    );
  }
}