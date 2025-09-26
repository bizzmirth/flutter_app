import 'package:bizzmirth_app/models/transactions.dart';
import 'package:flutter/material.dart';

class AllTransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const AllTransactionsPage(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.green),
            title: const Text('Payment made towards the'),
            subtitle: Text('₹${transaction.amount} - ${transaction.date}'),
          );
        },
      ),
    );
  }
}
