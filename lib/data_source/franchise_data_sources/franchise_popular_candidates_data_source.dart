import 'package:bizzmirth_app/models/franchise_models/franchisee_candidate_count.dart';
import 'package:flutter/material.dart';

class FranchisePopularCandidatesDataSource extends DataTableSource {
  final List<FranchiseeCandidateCount> data;
  FranchisePopularCandidatesDataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customers = data[index];
    return DataRow(cells: [
      DataCell(Text(customers.type ?? 'N/A')),
      DataCell(Text(customers.pending.toString())),
      DataCell(Text(customers.registered.toString())),
      DataCell(Text(customers.deleted.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
