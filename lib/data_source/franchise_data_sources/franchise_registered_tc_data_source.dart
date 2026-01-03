import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/add_franchise_tc.dart';
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
        PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: const Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: const Text('View'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to view details page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFranchiseTc()));
            },
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading:
                const Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to view details page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFranchiseTc()));
            },
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
