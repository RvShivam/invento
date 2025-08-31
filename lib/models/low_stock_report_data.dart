// lib/models/low_stock_report_data.dart
import 'inventory_item.dart';

class LowStockReportData {
  final int totalLowStockItems;
  final List<InventoryItem> items;

  LowStockReportData({
    required this.totalLowStockItems,
    required this.items,
  });
}