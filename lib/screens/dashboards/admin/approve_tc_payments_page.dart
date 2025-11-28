import 'package:flutter/material.dart';

class ApprovePaymentsPage extends StatefulWidget {
  final List<Map<String, String>> pendingTransactions;
  final Function(int) approveTransaction;
  final Function(int) rejectTransaction;

  const ApprovePaymentsPage({
    super.key,
    required this.pendingTransactions,
    required this.approveTransaction,
    required this.rejectTransaction,
  });

  @override
  State<ApprovePaymentsPage> createState() => _ApprovePaymentsPageState();
}

class _ApprovePaymentsPageState extends State<ApprovePaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Approval Page',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.pendingTransactions.length,
        itemBuilder: (context, index) {
          final transaction = widget.pendingTransactions[index];
          return Card(
            child: ListTile(
              title: Text(transaction['name'] ?? 'N/A'),
              subtitle: Text(
                  "Amount: ${transaction["amount"]} | Mode: ${transaction["mode"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.approveTransaction(index);
                      Navigator.pop(context);
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.pendingTransactions.removeAt(index);
                      });
                    },
                    child: const Text('Reject',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
