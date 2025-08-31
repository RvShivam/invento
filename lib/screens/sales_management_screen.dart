import 'package:flutter/material.dart';
import '../models/sales_transaction.dart';
import '../services/sales_service.dart';
import 'select_item_for_sale_screen.dart';
import 'transaction_details_screen.dart';

class SalesManagementScreen extends StatefulWidget {
  const SalesManagementScreen({super.key});

  @override
  State<SalesManagementScreen> createState() => _SalesManagementScreenState();
}

class _SalesManagementScreenState extends State<SalesManagementScreen> {
  bool _isLoading = true;
  List<SalesTransaction> _allTransactions = [];
  List<SalesTransaction> _displayedTransactions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _searchController.addListener(_applySearchFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    try {
      final transactions = await SalesService().fetchSalesHistory();
      setState(() {
        _allTransactions = transactions;
        _displayedTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedTransactions = _allTransactions.where((transaction) {
        final customerMatches = transaction.customerName.toLowerCase().contains(query);
        final orderIdMatches = transaction.orderId.toLowerCase().contains(query);
        return customerMatches || orderIdMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Management'),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by customer or Order ID...',
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
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displayedTransactions.isEmpty
              ? const Center(child: Text('No sales history found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _displayedTransactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionCard(_displayedTransactions[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SelectItemsForSaleScreen()),
          );
        },
        label: const Text('Record New Sale'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionCard(SalesTransaction transaction) {
    return Card(
      color: const Color(0xFF1C1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(transaction: transaction),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.orderId,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${transaction.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Customer: ${transaction.customerName}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Date: ${transaction.date}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Divider(height: 24, color: Colors.grey),
              ...transaction.items.take(2).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.name}'),
                    Text('₹${(item.quantity * item.price).toStringAsFixed(2)}'),
                  ],
                ),
              )),
              if (transaction.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '+ ${transaction.items.length - 2} more item(s)',
                    style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}