// lib/screens/item_details_screen.dart
import 'package:flutter/material.dart';
import '../models/item_details.dart';
import '../services/item_details_service.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String sku;
  const ItemDetailsScreen({super.key, required this.sku});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<ItemDetails> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = ItemDetailsService().fetchItemDetails(widget.sku);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergonomic Mouse'), // This could be dynamic
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show delete confirmation dialog
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: FutureBuilder<ItemDetails>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final item = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSummaryCard(item),
                  const SizedBox(height: 16),
                  _buildDetailsCard(item),
                  const SizedBox(height: 16),
                  _buildPricingCard(item),
                  const SizedBox(height: 16),
                  _buildStockHistoryCard(item),
                ],
              ),
            );
          }
          return const Center(child: Text('Item not found.'));
        },
      ),
      // Bottom navigation for action buttons
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildSummaryCard(ItemDetails item) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            //             Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('SKU: ${item.sku}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Text('${item.currentStock} units', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(ItemDetails item) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Category', item.category),
            const Divider(color: Colors.grey),
            _buildDetailRow('Supplier', item.supplier),
            const Divider(color: Colors.grey),
            _buildDetailRow('Date Added', item.dateAdded),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(ItemDetails item) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Purchase Price', '₹${item.purchasePrice.toStringAsFixed(2)}'),
            const Divider(color: Colors.grey),
            _buildDetailRow('Selling Price', '₹${item.sellingPrice.toStringAsFixed(2)}'),
            const Divider(color: Colors.grey),
            _buildDetailRow('Margin', '${item.margin}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStockHistoryCard(ItemDetails item) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stock History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...item.stockHistory.map((entry) => _buildStockHistoryRow(entry)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStockHistoryRow(StockHistoryEntry entry) {
    bool isStockIn = entry.quantityChange > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.description, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isStockIn ? '+' : ''}${entry.quantityChange} units',
                style: TextStyle(color: isStockIn ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
              ),
              Text(entry.date, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.transparent, // Or your scaffold background color
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to Edit Item screen
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Item'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Show Adjust Stock overlay
              },
              child: const Text('Adjust Stock'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}