// lib/widgets/filter_sort_overlay.dart
import 'package:flutter/material.dart';
import '../models/filter_options.dart';
import 'category_selection_overlay.dart';
import 'supplier_selection_overlay.dart';

class FilterSortOverlay extends StatefulWidget {
  final FilterOptions initialFilters;

  const FilterSortOverlay({super.key, required this.initialFilters});

  @override
  State<FilterSortOverlay> createState() => _FilterSortOverlayState();
}

class _FilterSortOverlayState extends State<FilterSortOverlay> {
  late FilterOptions _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = FilterOptions(
      sortOption: widget.initialFilters.sortOption,
      filterStatus: widget.initialFilters.filterStatus,
      category: widget.initialFilters.category,
      supplier: widget.initialFilters.supplier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1F2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSortBySection(),
          const SizedBox(height: 24),
          _buildFilterBySection(),
          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Filter & Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildSortOption(label: 'Name (A-Z)', value: SortOption.nameAZ),
        _buildSortOption(label: 'Stock Level (High to Low)', value: SortOption.stockHighToLow),
        _buildSortOption(label: 'Stock Level (Low to High)', value: SortOption.stockLowToHigh),
      ],
    );
  }

  Widget _buildSortOption({required String label, required SortOption value}) {
    return RadioListTile<SortOption>(
      title: Text(label),
      value: value,
      groupValue: _selectedFilters.sortOption,
      onChanged: (SortOption? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedFilters.sortOption = newValue;
          });
        }
      },
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFilterBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFilterChip('All Items', FilterStatus.all),
            _buildFilterChip('Low Stock', FilterStatus.lowStock),
            _buildFilterChip('Out of Stock', FilterStatus.outOfStock),
          ],
        ),
        const SizedBox(height: 16),
        _buildFilterRow('Category'),
        const Divider(color: Colors.grey),
        _buildFilterRow('Supplier'),
      ],
    );
  }

  Widget _buildFilterChip(String label, FilterStatus value) {
    bool isSelected = _selectedFilters.filterStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilters.filterStatus = value;
          });
        }
      },
      backgroundColor: Colors.transparent,
      selectedColor: Theme.of(context).colorScheme.primary,
      shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey)),
    );
  }

  Widget _buildFilterRow(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title == 'Category' ? (_selectedFilters.category ?? 'All') : (_selectedFilters.supplier ?? 'All'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () async {
        if (title == 'Category') {
          final selectedCategory = await showModalBottomSheet<String?>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CategorySelectionOverlay(
              currentlySelected: _selectedFilters.category,
            ),
          );
          if (selectedCategory != _selectedFilters.category) {
            setState(() => _selectedFilters.category = selectedCategory);
          }
        } else if (title == 'Supplier') {
          final selectedSupplier = await showModalBottomSheet<String?>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SupplierSelectionOverlay(
              currentlySelected: _selectedFilters.supplier,
            ),
          );
          if (selectedSupplier != _selectedFilters.supplier) {
            setState(() => _selectedFilters.supplier = selectedSupplier);
          }
        }
      },
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedFilters = FilterOptions();
              });
            },
            child: const Text('Clear All'),
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
              Navigator.of(context).pop(_selectedFilters);
            },
            child: const Text('Apply Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}