import 'package:flutter/material.dart';

class PendingTransactionsPage extends StatefulWidget {
  final List<Map<String, String>> pendingTransactions;

  const PendingTransactionsPage({super.key, required this.pendingTransactions});

  @override
  State<PendingTransactionsPage> createState() =>
      _PendingTransactionsPageState();
}

class _PendingTransactionsPageState extends State<PendingTransactionsPage> {
  late List<Map<String, String>> _localPendingTransactions;

  @override
  void initState() {
    super.initState();
    _localPendingTransactions = List.from(widget.pendingTransactions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Pending Transactions', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _localPendingTransactions.isEmpty
          ? Center(
              child: Text(
                "No pending transactions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: _localPendingTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = _localPendingTransactions[index];
                  return _buildTransactionCard(transaction);
                },
              ),
            ),
    );
  }

  Widget _buildTransactionCard(Map<String, String> transaction) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Transaction ID", transaction["id"]!),
            _buildInfoRow("Name", transaction["name"]!),
            _buildInfoRow("Amount", transaction["amount"]!, isBold: true),
            _buildInfoRow("Payment Mode", transaction["mode"]!),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Pending Approval",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
