// lib/widgets/supplier_selection_overlay.dart
import 'package:flutter/material.dart';
import '../services/supplier_service.dart';

class SupplierSelectionOverlay extends StatefulWidget {
  final String? currentlySelected;

  const SupplierSelectionOverlay({super.key, this.currentlySelected});

  @override
  State<SupplierSelectionOverlay> createState() => _SupplierSelectionOverlayState();
}

class _SupplierSelectionOverlayState extends State<SupplierSelectionOverlay> {
  List<String> _allSuppliers = [];
  List<String> _filteredSuppliers = [];
  String? _tempSelectedSupplier;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tempSelectedSupplier = widget.currentlySelected;
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    final suppliers = await SupplierService().fetchSuppliers();
    setState(() {
      _allSuppliers = ['All Suppliers', ...suppliers];
      _filteredSuppliers = _allSuppliers;
      _isLoading = false;
    });
  }

  void _filterSuppliers(String query) {
    if (query.isEmpty) {
      _filteredSuppliers = _allSuppliers;
    } else {
      _filteredSuppliers = _allSuppliers
          .where((supplier) => supplier.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Supplier', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: _filterSuppliers,
            decoration: InputDecoration(
              hintText: 'Search supplier',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: _filteredSuppliers.map((supplier) {
                      return RadioListTile<String?>(
                        title: Text(supplier),
                        value: supplier == 'All Suppliers' ? null : supplier,
                        groupValue: _tempSelectedSupplier,
                        onChanged: (String? value) {
                          setState(() {
                            _tempSelectedSupplier = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_tempSelectedSupplier);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}