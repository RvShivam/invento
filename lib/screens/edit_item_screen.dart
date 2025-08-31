// lib/screens/edit_item_screen.dart
import 'package:flutter/material.dart';
import '../models/item_details.dart'; // We'll pass the detailed item model

class EditItemScreen extends StatefulWidget {
  final ItemDetails item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _categoryController;
  late TextEditingController _supplierController;
  late TextEditingController _stockController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing item's data
    _nameController = TextEditingController(text: widget.item.name);
    _skuController = TextEditingController(text: widget.item.sku);
    _categoryController = TextEditingController(text: widget.item.category);
    _supplierController = TextEditingController(text: widget.item.supplier);
    _stockController = TextEditingController(text: '${widget.item.currentStock}');
    _purchasePriceController = TextEditingController(
        text: widget.item.purchasePrice.toString());
    _sellingPriceController = TextEditingController(
        text: widget.item.sellingPrice.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _supplierController.dispose();
    _stockController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'Item Name', controller: _nameController),
            const SizedBox(height: 16),
            _buildTextField(label: 'SKU', controller: _skuController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Category', controller: _categoryController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Supplier', controller: _supplierController),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Current Stock',
              controller: _stockController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Purchasing Price',
              controller: _purchasePriceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Selling Price',
              controller: _sellingPriceController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  // Helper widget to create a styled text field with a label
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(color: readOnly ? Colors.grey : Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1C1F2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the bottom action buttons
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(), // Just close the screen
              child: const Text('Cancel'),
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
                // TODO: Implement save logic here
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
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
