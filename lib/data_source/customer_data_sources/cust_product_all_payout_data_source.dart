import 'package:bizzmirth_app/models/cust_product_payout_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustProductAllPayoutDataSource extends DataTableSource {
  final List<CustProductPayoutModel> data;
  CustProductAllPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final payout = data[index];

    return DataRow(
      cells: [
        // Date
        DataCell(Text(formatDate(payout.date))),

        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              payout.message,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),

        DataCell(Text('₹${payout.amount}')),

        DataCell(Text(payout.tds == 'NA' ? 'N/A' : '₹${payout.tds}')),
        DataCell(Text('₹${payout.totalPayable}')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(payout.status),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              payout.status,
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
