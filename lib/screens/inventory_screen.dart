// lib/screens/inventory_screen.dart
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import 'item_details_screen.dart';
import '../widgets/filter_sort_overlay.dart';
import '../models/filter_options.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isLoading = true;
  List<InventoryItem> _allItems = []; // Holds the master list of items
  List<InventoryItem> _displayedItems = []; // Holds the filtered and sorted list
  FilterOptions _currentFilters = FilterOptions();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _searchController.addListener(() {
      _applyFiltersAndSort();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    setState(() { _isLoading = true; });
    try {
      final items = await InventoryService().fetchInventoryItems();
      setState(() {
        _allItems = items;
        _applyFiltersAndSort(); // Apply default filters initially
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  void _applyFiltersAndSort() {
    List<InventoryItem> tempItems = List.from(_allItems);
    String searchQuery = _searchController.text.toLowerCase();

    // 1. Apply Search Query Filter
    if (searchQuery.isNotEmpty) {
      tempItems = tempItems.where((item) {
        final nameMatches = item.name.toLowerCase().contains(searchQuery);
        final skuMatches = item.sku.toLowerCase().contains(searchQuery);
        return nameMatches || skuMatches;
      }).toList();
    }

    // 2. Apply Status Filter
    switch (_currentFilters.filterStatus) {
      case FilterStatus.lowStock:
        tempItems.retainWhere((item) => item.quantity > 0 && item.quantity <= 10);
        break;
      case FilterStatus.outOfStock:
        tempItems.retainWhere((item) => item.quantity == 0);
        break;
      case FilterStatus.all:
      default:
        break;
    }

    // 3. Apply Category and Supplier Filters
    if (_currentFilters.category != null) {
      tempItems.retainWhere((item) => item.category == _currentFilters.category);
    }
    if (_currentFilters.supplier != null) {
      tempItems.retainWhere((item) => item.supplier == _currentFilters.supplier);
    }

    // 4. Apply Sorting
    switch (_currentFilters.sortOption) {
      case SortOption.nameAZ:
        tempItems.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.stockHighToLow:
        tempItems.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case SortOption.stockLowToHigh:
        tempItems.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
    }

    setState(() {
      _displayedItems = tempItems;
    });
  }

  void _showFilterOverlay() async {
    final newFilters = await showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FilterSortOverlay(initialFilters: _currentFilters);
      },
    );

    if (newFilters != null) {
      setState(() {
        _currentFilters = newFilters;
        _applyFiltersAndSort();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchAndFilter(),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displayedItems.isEmpty
              ? const Center(child: Text("No items match your filters.", style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _displayedItems.length,
                  itemBuilder: (context, index) {
                    return _buildInventoryItemCard(_displayedItems[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to the Add Item screen
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
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
          onPressed: _showFilterOverlay,
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

  Widget _buildInventoryItemCard(InventoryItem item) {
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemDetailsScreen(sku: item.sku),
            ),
          );
        },
      ),
    );
  }
}