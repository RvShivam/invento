// lib/services/inventory_service.dart
import '../models/inventory_item.dart';

class InventoryService {
  // This method simulates a network call to fetch all inventory items.
  Future<List<InventoryItem>> fetchInventoryItems() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return a list of mock data that matches your design
    return [
      InventoryItem(name: 'Ergonomic Mouse', sku: '#123456', quantity: 52, price: 120.00),
      InventoryItem(name: 'Mechanical Keyboard', sku: '#789012', quantity: 0, price: 250.50),
      InventoryItem(name: '4K Monitor', sku: '#345678', quantity: 110, price: 75.00),
      InventoryItem(name: 'Webcam with Ringlight', sku: '#901234', quantity: 2, price: 500.00),
      InventoryItem(name: 'USB-C Hub', sku: '#567890', quantity: 78, price: 99.99),
      InventoryItem(name: 'Laptop Stand', sku: '#112233', quantity: 45, price: 45.00),
      InventoryItem(name: 'Desk Mat', sku: '#445566', quantity: 200, price: 25.00),
    ];
  }
}