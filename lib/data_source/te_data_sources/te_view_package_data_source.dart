import 'package:flutter/material.dart';

class TEViewPackageDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TEViewPackageDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['aprice']?.toString() ?? 'N/A')),
        DataCell(Text(order['cprice']?.toString() ?? 'N/A')),
        DataCell(Text(order['sprice']?.toString() ?? 'N/A')),
      ],
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
