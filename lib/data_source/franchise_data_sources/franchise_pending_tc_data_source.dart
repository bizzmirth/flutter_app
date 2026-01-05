import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
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
        DataCell(Text(order.name ?? 'N/A')),
        DataCell(Text('${order.refId ?? 'N/A'} - ${order.refName ?? 'N/A'}')),
        DataCell(Text(order.phone ?? 'N/A')),
        DataCell(Text(order.joiningDate ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order.statusBadge ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.status ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
