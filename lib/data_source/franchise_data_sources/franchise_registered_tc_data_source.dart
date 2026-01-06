import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_controller.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/add_franchise_tc.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FranchiseRegisteredTcDataSource extends DataTableSource {
  final BuildContext context;
  final List<FranchiseeRegisteredTc> data;
  FranchiseRegisteredTcDataSource(this.context, this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(
            '${order.caTravelagencyId} - ${order.firstname} ${order.lastname}')),
        DataCell(Text('${order.referenceNo} - ${order.registrant}')),
        DataCell(Text(order.contactNo ?? 'N/A')),
        DataCell(Text(formatDate(order.registerDate))),
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
        DataCell(_buildActionMenu(context, order)),
      ],
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
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
      case '3':
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

// Action Menu Widget
  Widget _buildActionMenu(
      BuildContext context, FranchiseeRegisteredTc registeredTc) {
    final controller =
        Provider.of<FranchiseeTcController>(context, listen: false);
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
              Logger.info(
                  'View action for TC ID: ${registeredTc.caTravelagencyId} and Name: ${registeredTc.firstname}');
              Navigator.pop(context);
              // Navigate to view details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFranchiseTc(
                    isViewMode: true,
                    franchiseeRegisteredTc: registeredTc,
                  ),
                ),
              );
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
                  builder: (context) => AddFranchiseTc(
                    isEditMode: true,
                    franchiseeRegisteredTc: registeredTc,
                  ),
                ),
              );
            },
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              Logger.info(
                  'Delete action for TC ID: ${registeredTc.caTravelagencyId} and Name: ${registeredTc.firstname} and Id : ${registeredTc.id}');
              Navigator.pop(context);
            },
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
