// lib/models/item_details.dart

class StockHistoryEntry {
  final String type;
  final String description;
  final int quantityChange;
  final String date;

  StockHistoryEntry({
    required this.type,
    required this.description,
    required this.quantityChange,
    required this.date,
  });

  factory StockHistoryEntry.fromJson(Map<String, dynamic> json) {
    return StockHistoryEntry(
      type: json['type'] ?? 'N/A',
      description: json['description'] ?? '',
      quantityChange: (json['change'] is int) ? json['change'] : int.tryParse(json['change'].toString()) ?? 0,
      date: json['date'] ?? '',
    );
  }
}

class ItemDetails {
  final int id;
  final String name;
  final String sku;
  final int currentStock;
  final String category;
  final String supplier;
  final String dateAdded;
  final double purchasePrice;
  final double sellingPrice;
  final List<StockHistoryEntry> stockHistory;

  ItemDetails({
    required this.id,
    required this.name,
    required this.sku,
    required this.currentStock,
    required this.category,
    required this.supplier,
    required this.dateAdded,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockHistory,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    var historyList = json['stock_history'] as List;
    List<StockHistoryEntry> history = historyList.map((i) => StockHistoryEntry.fromJson(i)).toList();

    return ItemDetails(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      currentStock: json['quantity'],
      category: json['category'],
      supplier: json['supplier'],
      dateAdded: json['date_added'],
      purchasePrice: double.parse(json['purchase_price'].toString()),
      sellingPrice: double.parse(json['selling_price'].toString()),
      stockHistory: history,
    );
  }
}