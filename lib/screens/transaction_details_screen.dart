import 'package:flutter/material.dart';
import 'package:invento_app/services/receipt_service.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/sales_transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final SalesTransaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for ${transaction.orderId}'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildOrderSummaryCard(),
          const SizedBox(height: 16),
          _buildAllItemsCard(),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('Customer:', transaction.customerName),
            _buildDetailRow('Date:', transaction.date),
            _buildDetailRow('Order ID:', transaction.orderId),
            const Divider(height: 24),
            _buildDetailRow(
              'Total Amount:',
              '₹${transaction.totalAmount.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAllItemsCard() {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All Items Sold', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.separated(
              itemCount: transaction.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                final item = transaction.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${item.quantity}x ${item.name}'),
                  trailing: Text('₹${(item.quantity * item.price).toStringAsFixed(2)}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 20 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          final pdfBytes = await ReceiptService().generateReceipt(transaction);
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdfBytes,
          );
        },
        icon: const Icon(Icons.print_outlined),
        label: const Text('Print / Share Receipt'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}