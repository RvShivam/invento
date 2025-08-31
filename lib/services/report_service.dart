// lib/services/report_service.dart
import '../models/sales_report_data.dart';

// Import the DateRange enum from your sales_report_screen
import '../screens/sales_report_screen.dart'; 

class ReportService {
  // The method now accepts a DateRange
  Future<SalesReportData> fetchSalesReport({required DateRange range}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

    // Return different data based on the selected range
    switch (range) {
      case DateRange.today:
        return SalesReportData(
          totalRevenue: 1250.00,
          numberOfSales: 15,
          topSellingProducts: [
            TopSellingProduct(name: 'Organic Apples', quantitySold: 5, totalRevenue: 250.00),
            TopSellingProduct(name: 'Avocados', quantitySold: 4, totalRevenue: 200.00),
          ],
        );
      case DateRange.last7Days:
        return SalesReportData(
          totalRevenue: 12500.00,
          numberOfSales: 350,
          topSellingProducts: [
            TopSellingProduct(name: 'Organic Apples', quantitySold: 50, totalRevenue: 2500.00),
            TopSellingProduct(name: 'Whole Wheat Bread', quantitySold: 40, totalRevenue: 2000.00),
            TopSellingProduct(name: 'Free-Range Eggs', quantitySold: 35, totalRevenue: 1750.00),
            TopSellingProduct(name: 'Almond Milk', quantitySold: 30, totalRevenue: 1500.00),
            TopSellingProduct(name: 'Avocados', quantitySold: 25, totalRevenue: 1250.00),
          ],
        );
      case DateRange.last30Days:
        return SalesReportData(
          totalRevenue: 55200.00,
          numberOfSales: 1240,
          topSellingProducts: [
            TopSellingProduct(name: 'Whole Wheat Bread', quantitySold: 180, totalRevenue: 9000.00),
            TopSellingProduct(name: 'Organic Apples', quantitySold: 150, totalRevenue: 7500.00),
            TopSellingProduct(name: 'Almond Milk', quantitySold: 120, totalRevenue: 6000.00),
            TopSellingProduct(name: 'Free-Range Eggs', quantitySold: 110, totalRevenue: 5500.00),
            TopSellingProduct(name: 'Chicken Breast', quantitySold: 95, totalRevenue: 4750.00),
          ],
        );
    }
  }
}