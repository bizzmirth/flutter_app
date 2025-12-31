import 'package:bizzmirth_app/entities/pending_techno_enterprise/pending_techno_enterprise_model.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/techno_enterprise/add_techno_enterprise.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/services/my_navigator.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

class BchPendingTcDataSource extends DataTableSource {
  final BuildContext context;
  final List<PendingTechnoEnterpriseModel> data;
  BchPendingTcDataSource(this.context, this.data);

  final IsarService isarService = IsarService();

  Future<void> deleteTechnoEnterprise(Id idToDelete,
      {bool showToast = true}) async {
    try {
      // await isarService.delete<PendingEmployeeModel>(idToDelete);
      await isarService.updateStatus<PendingTechnoEnterpriseModel>(
          idToDelete, 0);
      // employeeController.deletePendingEmployee(idToDelete);
      MyNavigator.pop();
      if (showToast) {
        ToastHelper.showSuccessToast(
            title: 'Pending Techno Enterprise Deleted.');
      }
    } catch (e) {
      Logger.error('Failed to Pending Techno Enterprise: $e');
    }
  }

  Future<void> restoreTechnoEnterprise(
    Id idToRestore,
  ) async {
    try {
      await isarService.updateStatus<PendingTechnoEnterpriseModel>(
          idToRestore, 2);
      MyNavigator.pop();
      ToastHelper.showSuccessToast(title: 'Techno Enterprise Restored.');
      Logger.success('-------- $context -------- ');
    } catch (e) {
      Logger.error('Failed to restore employee: $e');
    }
  }

  String _getStatusText(dynamic status) {
    if (status == null) return 'Unknown';

    if (status is String) {
      if (status.isEmpty) return 'Unknown';
      return status;
    }

    if (status is int || status is double) {
      switch (status) {
        case 1:
          return 'Completed';
        case 2:
          return 'Pending';
        case 0:
          return 'Cancelled';
        default:
          return 'Unknown';
      }
    }

    return status.toString();
  }

  Color _getStatusColor(String status) {
    final String statusText = _getStatusText(status).toLowerCase();
    switch (statusText) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case '0':
        return Colors.red;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.yellowAccent;
    }
  }

  Widget getProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/default_profile.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    String extractPathSegment(String fullPath, String folderPrefix) {
      final int index = fullPath.lastIndexOf(folderPrefix);
      if (index != -1) {
        return fullPath.substring(index);
      }
      return fullPath;
    }

    final String imageUrl;
    if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
      imageUrl = profilePicture;
    } else {
      final newpath = extractPathSegment(profilePicture, 'profile_pic/');
      imageUrl = 'https://testca.uniqbizz.com/uploading/$newpath';
    }

    Logger.success('Final image URL: $imageUrl');
// Action Menu Widget

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Logger.error("Failed to load image: $error");S
            return Image.asset(
              'assets/default_profile.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget buildActionMenu(PendingTechnoEnterpriseModel technoEnterprise) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> menuItems = [];

        // If status is 1 (Completed), show all options
        if (technoEnterprise.status == 2) {
          menuItems = [
            PopupMenuItem(
              value: 'view',
              child: ListTile(
                  leading: const Icon(Icons.remove_red_eye_sharp,
                      color: Colors.blue),
                  title: const Text('View'),
                  onTap: () {
                    // Logger.success(technoEnterprise.name!);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddViewTechnoPage(
                          isViewMode: true,
                          pendingTechnoEnterprise: technoEnterprise,
                        ),
                      ),
                    );
                  }),
            ),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 0, 105, 190)),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddViewTechnoPage(
                        pendingTechnoEnterprise: technoEnterprise,
                        isEditMode: true,
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
                  Logger.warning(
                      '------------ Delete ${technoEnterprise.name}------------');
                  deleteTechnoEnterprise(technoEnterprise.id!);
                },
              ),
            ),
            PopupMenuItem(
              value: 'register',
              child: ListTile(
                leading: const Icon(Icons.app_registration,
                    color: Color.fromARGB(255, 0, 238, 127)),
                title: const Text('Complete'),
                onTap: () {
                  Logger.warning(
                      '------------ Register ${technoEnterprise.name}------------');
                  // registerEmployee(technoEnterprise);
                },
              ),
            ),
          ];
        }
        // If status is 3 (Cancelled), show only "Restore"
        else if (technoEnterprise.status == 0) {
          menuItems = [
            PopupMenuItem(
              value: 'restore',
              child: ListTile(
                leading: const Icon(Icons.restore, color: Colors.green),
                title: const Text('Restore'),
                onTap: () {
                  Logger.warning(
                      '------------ Restore ${technoEnterprise.name}------------');
                  // restoreEmployee(technoEnterprise.id);
                  // Implement your restore logic here
                  // You can change the technoEnterprise's status back to 1 or another status value
                  restoreTechnoEnterprise(technoEnterprise.id!);
                },
              ),
            ),
          ];
        }

        return menuItems;
      },
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return 'N/A'; // Handle null/empty cases
    }

    try {
      final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final pendingTechnoEnterprise = data[index];
    var newStatus = '';
    final status = pendingTechnoEnterprise.status.toString();
    if (status == '2') {
      newStatus = 'Pending';
    } else if (status == '0') {
      newStatus = 'Deleted';
    }

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              // backgroundImage: NetworkImage(pendingTechnoEnterprise["profilePicture"]),
              radius: 20,
              child: getProfileImage(pendingTechnoEnterprise.profilePicture),
            ),
          ),
        ),
        DataCell(Text(pendingTechnoEnterprise.id.toString())),
        DataCell(Text(pendingTechnoEnterprise.name ?? 'N/A')),
        DataCell(Text(pendingTechnoEnterprise.phoneNumber ?? 'N/A')),
        DataCell(Text(pendingTechnoEnterprise.refName ?? 'N/A')),
        DataCell(Text(formatDate(pendingTechnoEnterprise.dob))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(pendingTechnoEnterprise.status.toString()),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              newStatus,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(buildActionMenu(pendingTechnoEnterprise)),
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
