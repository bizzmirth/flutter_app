import 'package:bizzmirth_app/models/cust_redeemable_wallet_history_model.dart';
import 'package:flutter/material.dart';

class CustRedeemableTableDataSource extends DataTableSource {
  final List<CustRedeemableWalletHistory> data;
  CustRedeemableTableDataSource(this.data);
  Color _getStatusColor(String status) {
    final String statusText = status.toLowerCase();
    switch (statusText) {
      case 'paid':
        return Colors.green;
      case 'not approved':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.yellowAccent;
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(
        Text(item.message!),
      ),
      DataCell(Text(item.amount!)),
      DataCell(Text(item.date!)),
      DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(item.status!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.status!,
            style: const TextStyle(color: Colors.white),
          ))),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
