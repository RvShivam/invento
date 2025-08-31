// lib/services/low_stock_service.dart
import '../models/inventory_item.dart';
import '../models/low_stock_report_data.dart';

class LowStockService {
  Future<LowStockReportData> fetchLowStockReport() async {
    await Future.delayed(const Duration(seconds: 1));

    final lowStockItems = [
      InventoryItem(name: 'Webcam with Ringlight', sku: '#901234', quantity: 2, price: 500.00, category: 'Electronics', supplier: 'StreamCo'),
      InventoryItem(name: 'Mechanical Keyboard', sku: '#789012', quantity: 0, price: 250.50, category: 'Electronics', supplier: 'TechPro'),
    ];
    
    return LowStockReportData(
      totalLowStockItems: lowStockItems.length,
      items: lowStockItems,
    );
  }
}