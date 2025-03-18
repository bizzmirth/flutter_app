import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<Map<String, String>> transactions;
  TransactionHistoryPage({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Transaction History', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            child: ListTile(
              title: Text(transaction["name"] ?? "N/A"),
              subtitle: Text(
                  "Amount: ${transaction["amount"]} | Mode: ${transaction["mode"]}"),
              leading: Icon(Icons.account_balance_wallet, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
