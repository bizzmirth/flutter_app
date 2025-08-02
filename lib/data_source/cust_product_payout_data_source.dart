import 'package:bizzmirth_app/entities/product_payouts/cust_product_payouts_model.dart';
import 'package:flutter/material.dart';

class PayoutDataSource extends DataTableSource {
  final List<CustProductPayoutsModel> _data = [
    CustProductPayoutsModel(
        date: '2025-06-15',
        payoutDetails: 'Product Commission - Electronics',
        amount: 2500.0,
        tds: 250.0,
        totalPayable: 2250.0,
        remark: 'Completed'),
    CustProductPayoutsModel(
        date: '2025-06-22',
        payoutDetails: 'Product Commission - Fashion',
        amount: 1800.0,
        tds: 180.0,
        totalPayable: 1620.0,
        remark: 'Processing'),
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];
    return DataRow(cells: [
      DataCell(Text(item.date)),
      DataCell(Text(item.payoutDetails)),
      DataCell(Text('Rs. ${item.amount}/-')),
      DataCell(Text('Rs. ${item.tds}/-')),
      DataCell(Text('Rs. ${item.totalPayable}/-')),
      DataCell(Text(item.remark)),
    ]);
  }

  bool get isEmpty => _data.isEmpty;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
