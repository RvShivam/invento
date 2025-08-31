// lib/services/report_generation_service.dart
import 'package:csv/csv.dart';
import '../models/sales_report_data.dart';

class ReportGenerationService {
  // Converts the report data into a CSV formatted string
  String generateSalesReportCsv(SalesReportData data) {
    // Define the header row
    final List<String> header = [
      'Product Name',
      'Quantity Sold',
      'Total Revenue'
    ];

    // Create a list of rows, starting with the header
    List<List<dynamic>> rows = [header];

    // Add a row for each top-selling product
    for (var product in data.topSellingProducts) {
      rows.add([
        product.name,
        product.quantitySold,
        product.totalRevenue,
      ]);
    }
    
    // Add summary rows at the end
    rows.add([]); // Add an empty row for spacing
    rows.add(['Summary', '']);
    rows.add(['Total Revenue', data.totalRevenue]);
    rows.add(['Number of Sales', data.numberOfSales]);

    // Use the csv package to convert the list of lists into a CSV string
    return const ListToCsvConverter().convert(rows);
  }
}