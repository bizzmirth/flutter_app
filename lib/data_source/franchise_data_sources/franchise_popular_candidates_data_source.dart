import 'package:flutter/material.dart';

class FranchisePopularCandidatesDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  FranchisePopularCandidatesDataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customers = data[index];
    return DataRow(cells: [
      DataCell(Text(customers['type'] ?? 'N/A')),
      DataCell(Text(customers['pending'] ?? 'N/A')),
      DataCell(Text(customers['registered'] ?? 'N/A')),
      DataCell(Text(customers['deleted'] ?? 'N/A')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
