import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_list_model.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<TcTopupRequestList> transactions;

  const TransactionHistoryPage({
    super.key,
    required this.transactions,
  });

  // Function to get status color based on status label or code
  Color _getStatusColor(String statusLabel) {
    switch (statusLabel.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      case 'pending':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final approvedTransactions = transactions
        .where((t) => (t.statusLabel ?? '').toLowerCase() != 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: approvedTransactions.isEmpty
          ? const Center(child: Text('No transaction history found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: approvedTransactions.length,
              itemBuilder: (context, index) {
                final transaction = approvedTransactions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction number
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaction #${transaction.srNo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            // Status label with background color
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                    transaction.statusLabel ?? ''),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transaction.statusLabel ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Amount
                        Text(
                          'Top-up Amount: ₹${transaction.topUpAmount}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 4),

                        // Dates
                        Text(
                          'Created: ${formatDate(transaction.createdDate)}',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13),
                        ),
                        Text(
                          'Updated: ${formatDate(transaction.updatedDate)}',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13),
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
