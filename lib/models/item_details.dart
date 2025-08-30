// lib/models/item_details.dart

// Represents a single entry in the stock history (e.g., stock in or stock out)
class StockHistoryEntry {
  final String type; // e.g., "Stock In", "Stock Out"
  final String description; // e.g., "Order #O-98765", "Sale #S-54321"
  final int quantityChange;
  final String date;

  StockHistoryEntry({
    required this.type,
    required this.description,
    required this.quantityChange,
    required this.date,
  });
}

// Represents the full details of a single inventory item
class ItemDetails {
  final String name;
  final String sku;
  final int currentStock;
  final String category;
  final String supplier;
  final String dateAdded;
  final double purchasePrice;
  final double sellingPrice;
  final String margin;
  final List<StockHistoryEntry> stockHistory;

  ItemDetails({
    required this.name,
    required this.sku,
    required this.currentStock,
    required this.category,
    required this.supplier,
    required this.dateAdded,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.margin,
    required this.stockHistory,
  });
}