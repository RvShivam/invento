import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:invento_app/services/report_generation_service.dart';
import '../models/sales_report_data.dart';
import '../services/report_service.dart';

// Enum to manage the selected date range
enum DateRange { today, last7Days, last30Days }

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  late Future<SalesReportData> _reportFuture;
  DateRange _selectedRange = DateRange.last7Days; // Default selection

  @override
  void initState() {
    super.initState();
    _reportFuture = ReportService().fetchSalesReport(range: _selectedRange);
  }

  void _onDateRangeSelected(DateRange range) {
    setState(() {
      _selectedRange = range;
      _reportFuture = ReportService().fetchSalesReport(range: _selectedRange);
    });
  }

  Future<void> _downloadReport(SalesReportData data) async {
    final csvData = ReportGenerationService().generateSalesReportCsv(data);
    final Uint8List bytes = Uint8List.fromList(csvData.codeUnits);
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

    try {
      String? path = await FileSaver.instance.saveFile(
        name: 'sales-report-$timestamp',
        bytes: bytes,
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved successfully to $path')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        backgroundColor: Colors.transparent,
        actions: [
          FutureBuilder<SalesReportData>(
            future: _reportFuture,
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
      body: Column(
        children: [
          _buildDateRangeSelector(),
          Expanded(
            child: FutureBuilder<SalesReportData>(
              future: _reportFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No report data available.'));
                }

                final reportData = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildMetrics(reportData),
                    const SizedBox(height: 24),
                    _buildTopSellingList(reportData.topSellingProducts),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      children: [
        _buildFilterChip('Today', DateRange.today),
        const SizedBox(width: 8),
        _buildFilterChip('Last 7 Days', DateRange.last7Days),
        const SizedBox(width: 8),
        _buildFilterChip('Last 30 Days', DateRange.last30Days),
      ],
    ),
  );
}



  Widget _buildFilterChip(String label, DateRange value) {
    final isSelected = _selectedRange == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) _onDateRangeSelected(value);
        },
        backgroundColor: const Color(0xFF1C1F2E),
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
        shape: const StadiumBorder(),
      ),
    );
  }

Widget _buildMetrics(SalesReportData data) {
    return Row(
      children: [
        Flexible(child: _buildMetricCard('Total Revenue', '₹${data.totalRevenue.toStringAsFixed(2)}')),
        const SizedBox(width: 16),
        Flexible(child: _buildMetricCard('Number of Sales', data.numberOfSales.toString())),
      ],
    );
  }


  Widget _buildMetricCard(String title, String value) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingList(List<TopSellingProduct> products) {
    return Card(
      color: const Color(0xFF1C1F2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top-Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(product.name),
                  subtitle: Text('Quantity Sold: ${product.quantitySold}'),
                  trailing: Text(
                    '₹${product.totalRevenue.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}