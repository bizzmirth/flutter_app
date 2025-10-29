// this data source will be used to display all the cu membership payout details.

import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/payout_data.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TcCuAllPayoutDataCource extends DataTableSource {
  final List<PayoutData> data;
  TcCuAllPayoutDataCource(this.data);
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final payout = data[index];

    return DataRow(cells: [
      DataCell(Text(formatDate(payout.date))),
      DataCell(
        SizedBox(
          width: 200,
          child: Text(
            payout.payoutDetails,
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
            color: _getStatusColor(payout.remark),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            payout.remark,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ]);
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
