import 'package:flutter/material.dart';

class CustBookingPointsDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  CustBookingPointsDataSource(this.data);
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(item['name'] ?? '')),
      DataCell(Text(item['phone']?.toString() ?? '')),
      DataCell(Text(item['phone1'] ?? '')),
      DataCell(Text(item['design'] ?? '')),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
