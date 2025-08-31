// lib/services/report_generation_service.dart
import 'package:csv/csv.dart';
import '../models/sales_report_data.dart';
import '../models/low_stock_report_data.dart';

class ReportGenerationService {
  String generateSalesReportCsv(SalesReportData data) {
    final List<String> header = [
      'Product Name',
      'Quantity Sold',
      'Total Revenue'
    ];

    List<List<dynamic>> rows = [header];

    for (var product in data.topSellingProducts) {
      rows.add([
        product.name,
        product.quantitySold,
        product.totalRevenue,
      ]);
    }
    
    rows.add([]);
    rows.add(['Summary', '']);
    rows.add(['Total Revenue', data.totalRevenue]);
    rows.add(['Number of Sales', data.numberOfSales]);

    // Return statement was missing, now it's added.
    return const ListToCsvConverter().convert(rows);
  } // <-- This closing brace is the key fix.

  // This method is now correctly defined at the class level.
  String generateLowStockReportCsv(LowStockReportData data) {
    final List<String> header = [
      'Product Name',
      'SKU',
      'Quantity Left',
      'Supplier'
    ];

    List<List<dynamic>> rows = [header];

    for (var item in data.items) {
      rows.add([
        item.name,
        item.sku,
        item.quantity,
        item.supplier,
      ]);
    }
    
    rows.add([]);
    rows.add(['Total Low Stock Items', data.totalLowStockItems]);
    return const ListToCsvConverter().convert(rows);
  }
}