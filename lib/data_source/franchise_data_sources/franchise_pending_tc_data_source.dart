import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/status_badge.dart';
import 'package:flutter/material.dart';

class FranchisePendingTcDataSource extends DataTableSource {
  final List<FranchiseePendingTc> data;
  FranchisePendingTcDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order.id ?? 'N/A')),
        DataCell(Text('${order.firstname} ${order.lastname}')),
        DataCell(Text(
            '${order.referenceNo ?? 'N/A'} - ${order.registrant ?? 'N/A'}')),
        DataCell(Text(order.contactNo ?? 'N/A')),
        DataCell(Text(formatDate(order.addedOn))),
        DataCell(
          StatusBadge(status: order.status!),
        ),
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
