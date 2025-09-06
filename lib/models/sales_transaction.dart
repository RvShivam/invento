// lib/models/sales_transaction.dart

class SoldItem {
  final String name;
  final int quantity;
  final double price;

  SoldItem({required this.name, required this.quantity, required this.price});

  factory SoldItem.fromJson(Map<String, dynamic> json) {
    return SoldItem(
      name: json['name'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }
}

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

  factory SalesTransaction.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items_sold'] as List;
    List<SoldItem> items = itemsList.map((i) => SoldItem.fromJson(i)).toList();

    return SalesTransaction(
      orderId: json['order_id'],
      customerName: json['customer_name'],
      date: json['date'],
      totalAmount: double.parse(json['total_amount'].toString()),
      items: items,
    );
  }
}