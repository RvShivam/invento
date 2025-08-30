// lib/services/inventory_service.dart
import '../models/inventory_item.dart';

class InventoryService {
  Future<List<InventoryItem>> fetchInventoryItems() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      InventoryItem(name: 'Ergonomic Mouse', sku: '#123456', quantity: 52, price: 120.00, category: 'Electronics', supplier: 'TechPro'),
      InventoryItem(name: 'Mechanical Keyboard', sku: '#789012', quantity: 0, price: 250.50, category: 'Electronics', supplier: 'TechPro'),
      InventoryItem(name: '4K Monitor', sku: '#345678', quantity: 110, price: 75.00, category: 'Electronics', supplier: 'ViewMax'),
      InventoryItem(name: 'Webcam with Ringlight', sku: '#901234', quantity: 2, price: 500.00, category: 'Electronics', supplier: 'StreamCo'),
      InventoryItem(name: 'USB-C Hub', sku: '#567890', quantity: 78, price: 99.99, category: 'Accessories', supplier: 'ConnectIt'),
      InventoryItem(name: 'Laptop Stand', sku: '#112233', quantity: 45, price: 45.00, category: 'Accessories', supplier: 'ErgoLife'),
      InventoryItem(name: 'Desk Mat', sku: '#445566', quantity: 200, price: 25.00, category: 'Accessories', supplier: 'ErgoLife'),
    ];
  }
}