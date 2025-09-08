// lib/models/sales_report_data.dart

class TopSellingProduct {
  final String name;
  final int quantitySold;
  final double totalRevenue;

  TopSellingProduct({
    required this.name,
    required this.quantitySold,
    required this.totalRevenue,
  });

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    return TopSellingProduct(
      name: json['name'],
      quantitySold: json['quantitySold'],
      totalRevenue: double.parse(json['totalRevenue'].toString()),
    );
  }
}

class SalesReportData {
  final double totalRevenue;
  final int numberOfSales;
  final List<TopSellingProduct> topSellingProducts;

  SalesReportData({
    required this.totalRevenue,
    required this.numberOfSales,
    required this.topSellingProducts,
  });

  factory SalesReportData.fromJson(Map<String, dynamic> json) {
    var productList = json['topSellingProducts'] as List;
    List<TopSellingProduct> products =
        productList.map((i) => TopSellingProduct.fromJson(i)).toList();

    return SalesReportData(
      totalRevenue: double.parse(json['totalRevenue'].toString()),
      numberOfSales: json['numberOfSales'],
      topSellingProducts: products,
    );
  }
}