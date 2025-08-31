import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class RecordSaleScreen extends StatefulWidget {
  final Map<InventoryItem, int> selectedItems;

  const RecordSaleScreen({super.key, required this.selectedItems});

  @override
  State<RecordSaleScreen> createState() => _RecordSaleScreenState();
}

class _RecordSaleScreenState extends State<RecordSaleScreen> {
  final _customerNameController = TextEditingController();
  double _total = 0.0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double total = 0;
    widget.selectedItems.forEach((item, quantity) {
      total += item.price * quantity;
    });
    
    setState(() {
      _total = total;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record New Sale'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerDetails(),
            const SizedBox(height: 24),
            _buildItemsSummary(),
            const SizedBox(height: 24),
            _buildTotalsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildCustomerDetails() {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Sale Date',
                ),
                child: Text(
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSummary() {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Items in Sale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...widget.selectedItems.entries.map((entry) {
              final item = entry.key;
              final quantity = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${quantity}x ${item.name}'),
                    Text('₹${(quantity * item.price).toStringAsFixed(2)}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Total', '₹${_total.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: isTotal ? 18 : 16)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 20 : 16)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
              child: const Text('Save Sale'),
            ),
          ),
        ],
      ),
    );
  }
}