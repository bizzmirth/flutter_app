import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_product_payout_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TcPayoutCommmonDataSource extends DataTableSource {
  final List<TcProductPayoutModel> payoutList;
  TcPayoutCommmonDataSource({required this.payoutList});
  @override
  DataRow? getRow(int index) {
    if (index >= payoutList.length) return null;
    final payout = payoutList[index];
    return DataRow(
      cells: [
        DataCell(Text(formatDate(payout.date))),
        DataCell(Text(payout.message ?? 'N/A')),
        DataCell(Text(payout.markup ?? 'N/A')),
        DataCell(Text('₹${payout.amount}')),
        DataCell(Text(payout.tds == null ? 'N/A' : '₹${payout.tds}')),
        DataCell(Text('₹${payout.totalPayable}')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(payout.status ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              payout.status ?? '',
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
  int get rowCount => payoutList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
