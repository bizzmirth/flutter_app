import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/tc_cu_all_payout_model.dart';
import 'package:flutter/material.dart';

class TcCuMembershipAllDataSource extends DataTableSource {
  final List<TcCuAllPayoutModel> data;
  TcCuMembershipAllDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order.date ?? 'N/A')),
        DataCell(Text(order.payoutDetails ?? 'N/A')),
        DataCell(Text(order.amount ?? 'N/A')),
        DataCell(Text(order.tds ?? 'N/A')),
        DataCell(Text(order.totalPayable ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order.remark ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.remark ?? 'Unknown',
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
        return Colors.grey;
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
