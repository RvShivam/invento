// lib/models/sales_report_data.dart

// UPDATE this model to include revenue per product
class TopSellingProduct {
  final String name;
  final int quantitySold;
  final double totalRevenue;

  TopSellingProduct({
    required this.name,
    required this.quantitySold,
    required this.totalRevenue,
  });
}

// UPDATE this model to use the new product model
class SalesReportData {
  final double totalRevenue;
  final int numberOfSales;
  final List<TopSellingProduct> topSellingProducts;

  SalesReportData({
    required this.totalRevenue,
    required this.numberOfSales,
    required this.topSellingProducts,
  });
}