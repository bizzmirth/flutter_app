import 'package:flutter/material.dart';

class FranchiseAllPayoutDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  FranchiseAllPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final payout = data[index];

    return DataRow(
      cells: [
        // Date
        DataCell(Text(payout['date']?.toString() ?? 'N/A')),

        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              payout['payoutDetails']?.toString() ?? 'N/A',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),

        DataCell(Text('₹${payout['amount']?.toString() ?? 'N/A'}')),

        DataCell(Text('₹${payout['tds']?.toString() ?? 'N/A'}')),
        DataCell(Text('₹${payout['totalPayable']?.toString() ?? 'N/A'}')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(payout['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              payout['status']?.toString() ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'credited':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
