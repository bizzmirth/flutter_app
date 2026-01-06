import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
import 'package:bizzmirth_app/utils/constants.dart';
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(order.status!).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: getStatusColor(order.status!).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              getStatusText(order.status!),
              style: TextStyle(
                color: getStatusColor(order.status!),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Active';
      case '2':
        return 'Pending';
      case '3':
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
