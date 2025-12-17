import 'package:flutter/material.dart';

class FranchiseRegisteredCustomerDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  FranchiseRegisteredCustomerDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
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
      case 'cancelled':
        return Colors.red;
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
