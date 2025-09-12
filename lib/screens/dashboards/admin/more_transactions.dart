import 'package:bizzmirth_app/models/transactions.dart';
import 'package:flutter/material.dart';

class Moretransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const Moretransactions(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    int maxTransactionsToShow = 1000;
    bool hasMoreTransactions = transactions.length > maxTransactionsToShow;
    return Scaffold(
      appBar: AppBar(title: Text("All Transactions")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hasMoreTransactions
                    ? maxTransactionsToShow
                    : transactions.length,
                itemBuilder: (context, index) {
                  var transaction = transactions[index];
                  return ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Payment made towards the "),
                          TextSpan(
                            text: transaction.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " paid amount "),
                          TextSpan(
                            text: "₹${transaction.amount}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " towards "),
                          TextSpan(
                            text: transaction.whom,
                          ),
                          TextSpan(text: " via "),
                          TextSpan(
                            text: transaction.via,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " on "),
                          TextSpan(
                            text: transaction.date,
                            style: TextStyle(fontWeight: FontWeight.bold),
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
