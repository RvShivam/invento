import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:invento_app/widgets/adjust_stock_overlay.dart';
import '../models/inventory_item.dart';
import '../models/low_stock_report_data.dart';
import '../services/low_stock_service.dart';
import '../services/report_generation_service.dart';

class LowStockReportScreen extends StatefulWidget {
  const LowStockReportScreen({super.key});

  @override
  State<LowStockReportScreen> createState() => _LowStockReportScreenState();
}

class _LowStockReportScreenState extends State<LowStockReportScreen> {
  late Future<LowStockReportData> _lowStockFuture;

  @override
  void initState() {
    super.initState();
    _lowStockFuture = LowStockService().fetchLowStockReport();
  }

  Future<void> _downloadReport(LowStockReportData data) async {
    final csvData = ReportGenerationService().generateLowStockReportCsv(data);
    final Uint8List bytes = Uint8List.fromList(csvData.codeUnits);
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

    try {
      await FileSaver.instance.saveFile(
        name: 'low-stock-report-$timestamp',
        bytes: bytes,
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report downloaded successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading report: $e')),
        );
      }
    }
  }

  void _showAdjustStockOverlay(InventoryItem item) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AdjustStockOverlay(currentStock: item.quantity);
      },
    );

    if (result == true) {
      setState(() {
        _lowStockFuture = LowStockService().fetchLowStockReport();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Report'),
        backgroundColor: Colors.transparent,
        actions: [
          FutureBuilder<LowStockReportData>(
            future: _lowStockFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadReport(snapshot.data!),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: FutureBuilder<LowStockReportData>(
        future: _lowStockFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text('No items are low on stock.'));
          }

          final reportData = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildTotalItemsCard(reportData.totalLowStockItems),
              const SizedBox(height: 16),
              ...reportData.items.map((item) => _buildLowStockItemCard(item)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalItemsCard(int totalItems) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Items Low on Stock', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text(totalItems.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItemCard(InventoryItem item) {
    final bool isOutOfStock = item.quantity == 0;
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('SKU: ${item.sku}', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.quantity} units left',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isOutOfStock ? Colors.red : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Supplier: ${item.supplier}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _showAdjustStockOverlay(item),
                child: const Text('Adjust Stock'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}