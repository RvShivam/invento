// lib/services/sales_service.dart
import '../models/sales_transaction.dart';

class SalesService {
  Future<List<SalesTransaction>> fetchSalesHistory() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return [
      SalesTransaction(
        orderId: '#S-54321',
        customerName: 'Vikram Sharma',
        date: '30/08/2025',
        totalAmount: 1250.00,
        items: [
          SoldItem(name: 'Ergonomic Mouse', quantity: 10, price: 120.00),
          SoldItem(name: 'Desk Mat', quantity: 2, price: 25.00),
        ],
      ),
      SalesTransaction(
        orderId: '#S-54320',
        customerName: 'Priya Verma',
        date: '29/08/2025',
        totalAmount: 820.00,
        items: [
          SoldItem(name: '4K Monitor', quantity: 1, price: 500.00),
          SoldItem(name: 'Webcam with Ringlight', quantity: 2, price: 160.00),
        ],
      ),
      SalesTransaction(
        orderId: '#S-54319',
        customerName: 'Rohan Patel',
        date: '28/08/2025',
        totalAmount: 1580.00,
        items: [
          SoldItem(name: 'Mechanical Keyboard', quantity: 5, price: 250.50),
          SoldItem(name: 'Laptop Stand', quantity: 7, price: 45.00),
        ],
      ),
    ];
  }
}