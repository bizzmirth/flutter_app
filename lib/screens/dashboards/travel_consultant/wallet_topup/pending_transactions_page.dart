import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_list_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class PendingTransactionsPage extends StatelessWidget {
  final List<TcTopupRequestList> pendingTransactions;

  const PendingTransactionsPage({super.key, required this.pendingTransactions});

  // ✅ Function to get status color
  Color _getStatusColor(String statusLabel) {
    switch (statusLabel.toLowerCase()) {
      case 'pending':
        return Colors.orangeAccent;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Filter only pending transactions
    final filteredPending = pendingTransactions
        .where((t) => (t.statusLabel ?? '').toLowerCase() == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Transactions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),

      // ✅ Show message if none
      body: filteredPending.isEmpty
          ? const Center(
              child: Text(
                'No pending transactions found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPending.length,
              itemBuilder: (context, index) {
                final transaction = filteredPending[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction header (ID + Status)
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
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Updated: ${formatDate(transaction.updatedDate)}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
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
