import 'package:flutter/material.dart';

class TcTopCustomersDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TcTopCustomersDataSource({required this.data});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customers = data[index];
    return DataRow(cells: [
      DataCell(Text(customers['id'])),
      DataCell(Text(customers['name'])),
      DataCell(Text(customers['dateReg'])),
      DataCell(Text(customers['totalCURef']?.toString() ?? 'N/A')),
      DataCell(Text(customers['status'])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
