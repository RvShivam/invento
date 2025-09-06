// lib/widgets/adjust_stock_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AdjustmentType { add, remove }

class AdjustStockOverlay extends StatefulWidget {
  final int currentStock;

  const AdjustStockOverlay({super.key, required this.currentStock});

  @override
  State<AdjustStockOverlay> createState() => _AdjustStockOverlayState();
}

class _AdjustStockOverlayState extends State<AdjustStockOverlay> {
  AdjustmentType _selectedType = AdjustmentType.add;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24.0),
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
            _buildCurrentStock(),
            const SizedBox(height: 24),
            _buildAdjustmentTypeSelector(),
            const SizedBox(height: 16),
            _buildQuantityInput(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Adjust Stock', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildCurrentStock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Current Stock', style: TextStyle(fontSize: 16, color: Colors.white70)),
        Text('${widget.currentStock}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAdjustmentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Adjustment Type', style: TextStyle(fontSize: 16, color: Colors.white70)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTypeChip('Add', AdjustmentType.add)),
            const SizedBox(width: 16),
            Expanded(child: _buildTypeChip('Remove', AdjustmentType.remove)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, AdjustmentType type) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Center(child: Text(label)),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedType = type);
      },
      backgroundColor: const Color(0xFF2A2D3E),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  Widget _buildQuantityInput() {
    return TextField(
      controller: _quantityController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Quantity',
        hintText: 'Enter quantity',
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
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
              final quantity = int.tryParse(_quantityController.text) ?? 0;
              if (quantity == 0) return;

              final adjustment = _selectedType == AdjustmentType.add ? quantity : -quantity;
              
              final result = {
                'quantity': adjustment,
                'description': _selectedType == AdjustmentType.add ? 'Manual Addition' : 'Manual Removal'
              };
              
              Navigator.of(context).pop(result);
            },
            child: const Text('Confirm'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}