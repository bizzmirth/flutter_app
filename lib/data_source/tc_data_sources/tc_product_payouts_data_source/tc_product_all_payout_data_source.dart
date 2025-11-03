import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_all_product_payout_model.dart';
import 'package:flutter/material.dart';

class TcProductAllPayoutDataSource extends DataTableSource {
  List<TcAllProductPayoutModel> data;
  TcProductAllPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final payout = data[index];
    return DataRow(
      cells: [
        DataCell(Text(payout.date ?? 'N/A')),
        DataCell(Text(payout.message ?? 'N/A')),
        DataCell(Text(payout.markup ?? 'N/A')),
        DataCell(Text(payout.amount ?? 'N/A')),
        DataCell(Text(payout.tds?.toString() ?? 'N/A')),
        DataCell(Text(payout.totalPayable?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(payout.status ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              payout.status ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
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
