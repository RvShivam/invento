import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import 'record_sale_screen.dart';

class SelectItemsForSaleScreen extends StatefulWidget {
  const SelectItemsForSaleScreen({super.key});

  @override
  State<SelectItemsForSaleScreen> createState() => _SelectItemsForSaleScreenState();
}

class _SelectItemsForSaleScreenState extends State<SelectItemsForSaleScreen> {
  bool _isLoading = true;
  List<InventoryItem> _allItems = [];
  List<InventoryItem> _displayedItems = [];
  final _searchController = TextEditingController();
  final Map<InventoryItem, int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    final items = await InventoryService().fetchInventoryItems();
    setState(() {
      _allItems = items;
      _displayedItems = items;
      _isLoading = false;
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedItems = _allItems.where((item) {
        return item.name.toLowerCase().contains(query) ||
               item.sku.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _updateQuantity(InventoryItem item, int change) {
    setState(() {
      int currentQty = _selectedItems[item] ?? 0;
      int newQty = currentQty + change;

      if (newQty > 0) {
        if (newQty <= item.quantity) {
          _selectedItems[item] = newQty;
        }
      } else {
        _selectedItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Items'),
        actions: [
          TextButton(
            onPressed: _selectedItems.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecordSaleScreen(selectedItems: _selectedItems),
                      ),
                    );
                  },
            child: const Text('Next'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF2A2D3E),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: _displayedItems.length,
                    itemBuilder: (context, index) {
                      final item = _displayedItems[index];
                      final quantity = _selectedItems[item] ?? 0;
                      return _buildItemTile(item, quantity);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(InventoryItem item, int quantity) {
    return Card(
      color: quantity > 0 ? const Color(0xFF2A2D3E) : const Color(0xFF1C1F2E),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('In Stock: ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: quantity > 0 ? () => _updateQuantity(item, -1) : null,
            ),
            Text(quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: quantity < item.quantity ? () => _updateQuantity(item, 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}