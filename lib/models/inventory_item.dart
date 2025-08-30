// lib/models/inventory_item.dart

class InventoryItem {
  final String name;
  final String sku;
  final int quantity;
  final double price;

  InventoryItem({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
  });
}