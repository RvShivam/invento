import 'package:flutter/material.dart';
import 'package:invento_app/services/inventory_service.dart';
import '../models/item_details.dart';
import '../services/item_details_service.dart';
import 'edit_item_screen.dart';
import '../widgets/adjust_stock_overlay.dart';
import '../widgets/delete_confirmation_overlay.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String sku;
  const ItemDetailsScreen({super.key, required this.sku});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<ItemDetails> _detailsFuture;
  final _inventoryService = InventoryService();

  @override
  void initState() {
    super.initState();
    _detailsFuture = ItemDetailsService().fetchItemDetails(widget.sku);
  }

  void _showAdjustStockOverlay(ItemDetails item) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AdjustStockOverlay(currentStock: item.currentStock);
      },
    );

    if (result != null && mounted) {
      final success = await _inventoryService.adjustStock(
        item.id,
        result['quantity'],
        result['description'],
      );

      if (success) {
        setState(() {
          _detailsFuture = ItemDetailsService().fetchItemDetails(widget.sku);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update stock.')),
        );
      }
    }
  }

  void _showDeleteConfirmation(ItemDetails item) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeleteConfirmationOverlay(itemName: item.name);
      },
    );

    if (confirmed == true) {
      try {
        await _inventoryService.deleteItem(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"${item.name}" was deleted.')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete item: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemDetails>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        if (snapshot.hasData) {
          final item = snapshot.data!;
          
          return Scaffold(
            appBar: AppBar(
              title: Text(item.name), 
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () => _showDeleteConfirmation(item),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            body: SingleChildScrollView(
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
            ),
            bottomNavigationBar: _buildActionButtons(item),
          );
        }
        
        return Scaffold(
          appBar: AppBar(title: const Text('Not Found')),
          body: const Center(child: Text('Item not found.')),
        );
      },
    );
  }

  Widget _buildSummaryCard(ItemDetails item) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
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
            _buildDetailRow('Date Added', item.dateAdded.split('T')[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(ItemDetails item) {
    // Calculate margin
    final margin = item.sellingPrice > 0 
        ? (((item.sellingPrice - item.purchasePrice) / item.sellingPrice) * 100)
        : 0.0;

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
            _buildDetailRow('Margin', '${margin.toStringAsFixed(2)}%'),
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
            if (item.stockHistory.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No stock history available for this item.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              )
            else
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
              Text(entry.date),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(ItemDetails item) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditItemScreen(item: item),
                  ),
                );
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
              onPressed: () => _showAdjustStockOverlay(item),
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