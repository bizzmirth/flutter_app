import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_controller.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/add_franchise_tc.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/status_badge.dart';
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
          StatusBadge(status: order.status!),
        ),
        DataCell(_buildActionMenu(context, order)),
      ],
    );
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
      itemBuilder: (context) {
  final List<PopupMenuEntry<String>> menuItems = [];

  // STATUS = 1 → Active
  if (registeredTc.status == '1') {
    menuItems.addAll([
      PopupMenuItem(
        value: 'view',
        child: ListTile(
          leading:
              const Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
          title: const Text('View'),
          onTap: () {
            Logger.info(
                'View action for TC ID: ${registeredTc.caTravelagencyId} and Name: ${registeredTc.firstname}');
            Navigator.pop(context);
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
          leading: const Icon(
            Icons.edit,
            color: Color.fromARGB(255, 0, 105, 190),
          ),
          title: const Text('Edit'),
          onTap: () {
            Navigator.pop(context);
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
          onTap: () async {
            Logger.info(
                'Delete action for TC ID: ${registeredTc.caTravelagencyId} and Name: ${registeredTc.firstname} and Id : ${registeredTc.id}');
            Navigator.pop(context);
            await controller.apiDeleteRegisteredTc(registeredTc, 'registered');
            await controller.fetchRegisteredTcs();
            await controller.fetchPendingTcs();
          },
        ),
      ),
    ]);
  }

  // STATUS = 3 → Inactive (Restore)
  else if (registeredTc.status == '3') {
    menuItems.add(
      PopupMenuItem(
        value: 'restore',
        child: ListTile(
          leading: const Icon(Icons.restore, color: Colors.green),
          title: const Text('Restore'),
          onTap: () async {
            Navigator.pop(context);
            await controller.apiDeleteRegisteredTc(registeredTc, 'deactivate');
            await controller.fetchRegisteredTcs();
            await controller.fetchPendingTcs();
          },
        ),
      ),
    );
  }

  // STATUS = 0 → Deleted (no actions or optional View only)
  else if (registeredTc.status == '0') {
    menuItems.add(
      PopupMenuItem(
        value: 'view',
        child: ListTile(
          leading:
              const Icon(Icons.remove_red_eye_sharp, color: Colors.grey),
          title: const Text('View'),
          onTap: () {
            Navigator.pop(context);
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
    );
  }

  return menuItems;
},

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
