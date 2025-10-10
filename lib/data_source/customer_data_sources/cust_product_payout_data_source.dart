import 'package:bizzmirth_app/models/customer_models/cust_product_payout_model.dart';
import 'package:flutter/material.dart';

class PayoutDataSource extends DataTableSource {
  final List<CustProductPayoutModel> data;
  PayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text(item.date)),
      DataCell(Text(item.message)),
      DataCell(Text('Rs. ${item.amount}/-')),
      DataCell(Text('Rs. ${item.tds}/-')),
      DataCell(Text('Rs. ${item.totalPayable}/-')),
      DataCell(Text(item.status)),
    ]);
  }

  bool get isEmpty => data.isEmpty;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
