// lib/models/inventory_item.dart

class InventoryItem {
  final int id;
  final String name;
  final String sku;
  final int quantity;
  final double price;
  final String category;
  final String supplier;
  final List<dynamic> stockHistory; 

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
    required this.category,
    required this.supplier,
    required this.stockHistory, 
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      quantity: json['quantity'],
      price: double.parse(json['selling_price'].toString()),
      category: json['category'],
      supplier: json['supplier'],
      stockHistory: json['stock_history'] ?? [],
    );
  }
}