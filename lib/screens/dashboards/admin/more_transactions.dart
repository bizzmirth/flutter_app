import 'package:bizzmirth_app/models/transactions.dart';
import 'package:flutter/material.dart';

class Moretransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const Moretransactions(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    final int maxTransactionsToShow = 1000;
    final bool hasMoreTransactions =
        transactions.length > maxTransactionsToShow;
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hasMoreTransactions
                    ? maxTransactionsToShow
                    : transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading:
                        const Icon(Icons.attach_money, color: Colors.green),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Payment made towards the '),
                          TextSpan(
                            text: transaction.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' paid amount '),
                          TextSpan(
                            text: '₹${transaction.amount}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' towards '),
                          TextSpan(
                            text: transaction.whom,
                          ),
                          const TextSpan(text: ' via '),
                          TextSpan(
                            text: transaction.via,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' on '),
                          TextSpan(
                            text: transaction.date,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
