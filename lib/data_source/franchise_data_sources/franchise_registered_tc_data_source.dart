import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:flutter/material.dart';

class FranchiseRegisteredTcDataSource extends DataTableSource {
  final List<FranchiseeRegisteredTc> data;
  FranchiseRegisteredTcDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text('${order.tcId} - ${order.tcName}')),
        DataCell(Text('${order.refId} - ${order.refName}')),
        DataCell(Text(order.phone ?? 'N/A')),
        DataCell(Text(order.joiningDate ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.status ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
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
      case 'active':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
