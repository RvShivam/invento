// lib/screens/inventory_screen.dart
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<InventoryItem>> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _inventoryFuture = InventoryService().fetchInventoryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a custom app bar for the title and search/filter actions
      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Removes the default back button
        // This makes the app bar taller to accommodate the search bar below it
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchAndFilter(),
          ),
        ),
      ),
      body: FutureBuilder<List<InventoryItem>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildInventoryItemCard(items[index]);
              },
            );
          }
          return const Center(child: Text('No items found.'));
        },
      ),
      // The floating action button for adding a new item
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to the Add Item screen
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  // Widget for the search bar and filter button
  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or SKU...',
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF2A2D3E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            // TODO: Open the Filter & Sort overlay
          },
          icon: const Icon(Icons.filter_list),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF2A2D3E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // Widget to display a single inventory item card
  Widget _buildInventoryItemCard(InventoryItem item) {
    // Determine the color of the quantity text based on stock level
    Color quantityColor;
    if (item.quantity == 0) {
      quantityColor = Colors.red;
    } else if (item.quantity <= 10) {
      quantityColor = Colors.orange;
    } else {
      quantityColor = Colors.white;
    }

    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('SKU: ${item.sku}', style: const TextStyle(color: Colors.white70)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item.quantity} units',
                  style: TextStyle(fontWeight: FontWeight.bold, color: quantityColor, fontSize: 16),
                ),
                Text(
                  '₹${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          ],
        ),
        onTap: () {
          // TODO: Navigate to the Item Details screen
        },
      ),
    );
  }
}