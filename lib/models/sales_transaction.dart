// lib/models/sales_transaction.dart

// Represents a single item within a sale
class SoldItem {
  final String name;
  final int quantity;
  final double price;

  SoldItem({required this.name, required this.quantity, required this.price});
}

// Represents a complete sales transaction
class SalesTransaction {
  final String orderId;
  final String customerName;
  final String date;
  final double totalAmount;
  final List<SoldItem> items;

  SalesTransaction({
    required this.orderId,
    required this.customerName,
    required this.date,
    required this.totalAmount,
    required this.items,
  });
}