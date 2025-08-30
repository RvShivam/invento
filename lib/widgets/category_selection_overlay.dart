// lib/widgets/category_selection_overlay.dart
import 'package:flutter/material.dart';
import '../services/category_service.dart';

class CategorySelectionOverlay extends StatefulWidget {
  final String? currentlySelected;

  const CategorySelectionOverlay({super.key, this.currentlySelected});

  @override
  State<CategorySelectionOverlay> createState() => _CategorySelectionOverlayState();
}

class _CategorySelectionOverlayState extends State<CategorySelectionOverlay> {
  List<String> _allCategories = [];
  List<String> _filteredCategories = [];
  String? _tempSelectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategory = widget.currentlySelected;
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await CategoryService().fetchCategories();
    setState(() {
      _allCategories = ['All Categories', ...categories]; // Add 'All' to the list
      _filteredCategories = _allCategories;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = _allCategories;
    } else {
      _filteredCategories = _allCategories
          .where((category) => category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This is the main container for the bottom sheet
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Take up 70% of screen height
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1F2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          TextField(
            onChanged: _filterCategories,
            decoration: InputDecoration(
              hintText: 'Search category',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          // Category List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: _filteredCategories.map((category) {
                      return RadioListTile<String?>(
                        title: Text(category),
                        // Use null for 'All Categories' to clear the filter
                        value: category == 'All Categories' ? null : category,
                        groupValue: _tempSelectedCategory,
                        onChanged: (String? value) {
                          setState(() {
                            _tempSelectedCategory = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
          ),
          // Done Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_tempSelectedCategory);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}