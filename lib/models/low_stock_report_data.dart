// lib/models/low_stock_report_data.dart
import 'inventory_item.dart';

class LowStockReportData {
  final int totalLowStockItems;
  final List<InventoryItem> items;

  LowStockReportData({
    required this.totalLowStockItems,
    required this.items,
  });

  // ADD THIS FACTORY CONSTRUCTOR
  factory LowStockReportData.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<InventoryItem> items = itemsList.map((i) => InventoryItem.fromJson(i)).toList();

    return LowStockReportData(
      totalLowStockItems: json['totalLowStockItems'],
      items: items,
    );
  }
}