import 'dart:io';

import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/all_employees/add_employees.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';

class PendingEmployeeDataSource extends DataTableSource {
  final BuildContext context;
  List<RegisteredEmployeeModel> registeredEmployees;

  PendingEmployeeDataSource(this.context, this.registeredEmployees);
  final IsarService isarService = IsarService();

  Future<void> deleteEmployee(idToDelete, {bool showToast = true}) async {
    try {
      Logger.warning("Delete process started $idToDelete ------");
      // await isarService.delete<RegisteredEmployeeModel>(idToDelete);
      await isarService.updateStatus<RegisteredEmployeeModel>(idToDelete, 3);
      Navigator.pop(context);
      if (showToast) {
        ToastHelper.showSuccessToast(
            context: context, title: "Registered Employee Deleted.");
      }
    } catch (e) {
      Logger.error("Error deleting the employee: $e");
    }
  }

  Future<void> unRegisterEmployee(RegisteredEmployeeModel empRegister) async {
    try {
      Logger.warning("Registering the employee ${empRegister.name}");
      final unRegisterEmployee = PendingEmployeeModel()
        ..id = empRegister.id
        ..name = empRegister.name
        ..mobileNumber = empRegister.mobileNumber
        ..email = empRegister.email
        ..address = empRegister.address
        ..gender = empRegister.gender
        ..dateOfBirth = empRegister.dateOfBirth
        ..dateOfJoining = empRegister.dateOfJoining
        ..status = 2
        ..department = empRegister.department
        ..designation = empRegister.designation
        ..zone = empRegister.zone
        ..branch = empRegister.branch
        ..reportingManager = empRegister.reportingManager
        ..profilePicture = empRegister.profilePicture
        ..idProof = empRegister.idProof
        ..bankDetails = empRegister.bankDetails;

      await isarService.save<PendingEmployeeModel>(unRegisterEmployee);
      removeEmployeeFromTable(empRegister.id, showToast: false);
      ToastHelper.showSuccessToast(
          context: context, title: "Employee Un-Registered.");
      Logger.success("----------- Employee Un-Regisered ${empRegister.name}");
    } catch (e) {
      Logger.error("Error unregistering the employee ${empRegister.name}: $e");
    }
  }

  Future<void> removeEmployeeFromTable(idToRemove,
      {bool showToast = true}) async {
    try {
      Logger.warning("Removing employee from table $idToRemove");
      await isarService.delete<RegisteredEmployeeModel>(idToRemove);
      Navigator.pop(context);
      if (showToast) {
        ToastHelper.showSuccessToast(
            context: context, title: "Employee Removed.");
      }
    } catch (e) {
      Logger.error("Error removing employee from table: $e");
    }
  }

  Future<void> restoreEmployee(idToRestore) async {
    try {
      await isarService.updateStatus<RegisteredEmployeeModel>(idToRestore, 1);
      Logger.success("Employee ${idToRestore} restored successfully");
      Navigator.pop(context);
    } catch (e) {
      Logger.error("Error restoring employee: $e");
    }
  }

  Widget _buildActionMenu(RegisteredEmployeeModel employee) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];

        if (employee.status == 1) {
          menuItems = [
            PopupMenuItem(
              value: "view",
              child: ListTile(
                leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
                title: Text("View"),
                onTap: () {
                  Logger.info("Viewing..... ${employee.name} ${employee.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeePage(
                        registerEmployee: employee,
                        isViewMode: true,
                      ),
                    ),
                  );
                  // Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              value: "edit",
              child: ListTile(
                leading: Icon(Icons.edit,
                    color: const Color.fromARGB(255, 0, 105, 190)),
                title: Text("Edit"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEmployeePage(
                              registerEmployee: employee,
                              isEditMode: true,
                            )),
                  );
                },
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete"),
                onTap: () {
                  Logger.error("Deleting..... ${employee.name} ${employee.id}");
                  deleteEmployee(employee.id);
                },
              ),
            ),
            PopupMenuItem(
              value: "unregister",
              child: ListTile(
                  leading: Icon(Icons.app_registration,
                      color: const Color.fromARGB(255, 0, 238, 127)),
                  title: Text("Un-Register"),
                  onTap: () {
                    Logger.error(
                        "Un-Registering..... ${employee.name} ${employee.id}");
                    unRegisterEmployee(employee);
                  }),
            ),
          ];
        } else if (employee.status == 3) {
          menuItems = [
            PopupMenuItem(
              value: "restore",
              child: ListTile(
                leading: Icon(Icons.restore, color: Colors.green),
                title: Text("Restore"),
                onTap: () {
                  Logger.warning(
                      "------------ Restore ${employee.name}------------");
                  restoreEmployee(employee.id);
                  // Implement your restore logic here
                  // You can change the employee's status back to 1 or another status value
                  // restoreEmployee(employee);
                },
              ),
            ),
          ];
        }

        return menuItems;
      },
      icon: Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  String _getStatusText(dynamic status) {
    if (status == null) return "Unknown";

    if (status is String) {
      if (status.isEmpty) return "Unknown";
      return status;
    }

    if (status is int || status is double) {
      switch (status) {
        case 1:
          return "Completed";
        case 2:
          return "Pending";
        default:
          return "Unknown";
      }
    }

    // Default fallback
    return status.toString();
  }

  ImageProvider _getProfileImage(String? profilePath) {
    if (profilePath != null && profilePath.isNotEmpty) {
      // Check if the file exists before using it
      File profileFile = File(profilePath);
      if (profileFile.existsSync()) {
        return FileImage(profileFile);
      }
    }
    // Return default image if profile picture is null, empty, or file doesn't exist
    return AssetImage("assets/default_profile.png");
  }

  Color _getStatusColor(String status) {
    String statusText = _getStatusText(status).toLowerCase();
    switch (statusText) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.grey;
      case "3":
        return Colors.red;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= registeredEmployees.length) return null;

    final registeredEmployee = registeredEmployees[index];

    var newStatus = "";
    final status = registeredEmployee.status.toString();
    if (status == '2') {
      newStatus = "Pending";
    } else if (status == '1') {
      newStatus = "Completed";
    } else if (status == '3') {
      newStatus = "Deleted";
    }

    return DataRow(cells: [
      DataCell(
        Center(
          child: CircleAvatar(
            radius: 20,
            backgroundImage:
                _getProfileImage(registeredEmployee.profilePicture),
          ),
        ),
      ),
      DataCell(Text(registeredEmployee.id.toString())),
      DataCell(Text(registeredEmployee.name ?? "N/A")),
      DataCell(Text(registeredEmployee.mobileNumber ?? "N/A")),
      DataCell(Text(registeredEmployee.mobileNumber ?? "n/A")),
      DataCell(Text(registeredEmployee.designation ?? "N/A")),
      DataCell(Text(registeredEmployee.dateOfJoining ?? "N/A")),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(registeredEmployee.status.toString()),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            newStatus,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      DataCell(_buildActionMenu(registeredEmployee)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => registeredEmployees.length;

  @override
  int get selectedRowCount => 0;
}
