// lib/services/item_details_service.dart
import '../models/item_details.dart';

class ItemDetailsService {
  // In a real app, you would pass an item ID or SKU to this method.
  Future<ItemDetails> fetchItemDetails(String sku) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data for the "Ergonomic Mouse" as shown in the design
    return ItemDetails(
      name: 'Ergonomic Mouse',
      sku: '#123456',
      currentStock: 52,
      category: 'Electronics',
      supplier: 'TechPro Inc.',
      dateAdded: '12/03/2024',
      purchasePrice: 85.00,
      sellingPrice: 120.00,
      margin: '29.17%',
      imageUrl: 'https://via.placeholder.com/150', // Placeholder image URL
      stockHistory: [
        StockHistoryEntry(
          type: 'Stock In',
          description: 'Order #O-98765',
          quantityChange: 50,
          date: '10/03/2024',
        ),
        StockHistoryEntry(
          type: 'Stock Out',
          description: 'Sale #S-54321',
          quantityChange: -10,
          date: '11/03/2024',
        ),
      ],
    );
  }
}