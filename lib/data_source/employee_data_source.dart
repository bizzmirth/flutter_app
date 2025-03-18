import 'dart:io';

import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/all_employees/add_employees.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';

class EmployeeDataSource extends DataTableSource {
  final BuildContext context;
  List<PendingEmployeeModel> pendingEmployees;

  EmployeeDataSource(this.context, this.pendingEmployees);

  final IsarService isarService = IsarService();

  Future<void> deleteEmployee(idToDelete, {bool showToast = true}) async {
    try {
      Logger.warning("Delete process started $idToDelete ------");
      // await isarService.delete<PendingEmployeeModel>(idToDelete);
      await isarService.updateStatus<PendingEmployeeModel>(idToDelete, 0);
      Navigator.pop(context);
      if (showToast) {
        ToastHelper.showSuccessToast(
            context: context, title: "Pending Employee Deleted.");
      }
      Logger.warning("Delete process completed");
    } catch (e) {
      Logger.error("Failed to delete employee: $e");
    }
  }

  Future<void> registerEmployee(PendingEmployeeModel empRegister) async {
    try {
      Logger.warning("Registering the employee ${empRegister.name}");
      final registerEmployee = RegisteredEmployeeModel()
        ..id = empRegister.id
        ..name = empRegister.name
        ..mobileNumber = empRegister.mobileNumber
        ..email = empRegister.email
        ..address = empRegister.address
        ..gender = empRegister.gender
        ..dateOfBirth = empRegister.dateOfBirth
        ..dateOfJoining = empRegister.dateOfJoining
        ..status = 1
        ..department = empRegister.department
        ..designation = empRegister.designation
        ..zone = empRegister.zone
        ..branch = empRegister.branch
        ..reportingManager = empRegister.reportingManager
        ..profilePicture = empRegister.profilePicture
        ..idProof = empRegister.idProof
        ..bankDetails = empRegister.bankDetails;

      await isarService.save<RegisteredEmployeeModel>(registerEmployee);
      removeEmployeeFromTable(empRegister.id, showToast: false);
      ToastHelper.showSuccessToast(
          context: context, title: "Employee Registered.");
      // Navigator.pop(context);
      Logger.success("----------- Employee Regisered ${empRegister.name}");
    } catch (e) {
      Logger.error("Failed to register the employee:: $e");
    }
  }

  Future<void> removeEmployeeFromTable(idToRemove,
      {bool showToast = true}) async {
    try {
      Logger.warning("Delete process started $idToRemove ------");
      await isarService.delete<PendingEmployeeModel>(idToRemove);
      // await isarService.updateStatus<PendingEmployeeModel>(idToDelete, 0);
      Navigator.pop(context);
      if (showToast) {
        ToastHelper.showSuccessToast(
            context: context, title: "Employee Deleted.");
      }
      Logger.warning("Delete process completed");
    } catch (e) {
      Logger.error("Failed to delete employee: $e");
    }
  }

  Future<void> restoreEmployee(
    idToRestore,
  ) async {
    try {
      await isarService.updateStatus<PendingEmployeeModel>(idToRestore, 2);
      Navigator.pop(context);
      Logger.success("-------- $context -------- ");
    } catch (e) {
      Logger.error("Failed to restore employee: $e");
    }
  }

  Widget _buildActionMenu(PendingEmployeeModel employee) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];

        // If status is 1 (Completed), show all options
        if (employee.status == 2) {
          menuItems = [
            PopupMenuItem(
              value: "view",
              child: ListTile(
                  leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
                  title: Text("View"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddEmployeePage(
                                pendingEmployee: employee,
                                isViewMode: true,
                              )),
                    );
                  }),
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
                        pendingEmployee: employee,
                        isEditMode: true,
                      ),
                    ),
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
                  Logger.warning(
                      "------------ Delete ${employee.name}------------");
                  deleteEmployee(employee.id, showToast: true);
                },
              ),
            ),
            PopupMenuItem(
              value: "register",
              child: ListTile(
                leading: Icon(Icons.app_registration,
                    color: const Color.fromARGB(255, 0, 238, 127)),
                title: Text("Register"),
                onTap: () {
                  Logger.warning(
                      "------------ Register ${employee.name}------------");
                  registerEmployee(employee);
                },
              ),
            ),
          ];
        }
        // If status is 3 (Cancelled), show only "Restore"
        else if (employee.status == 0) {
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

  void getStatus() {}

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
        case 0:
          return "Cancelled";
        default:
          return "Unknown";
      }
    }

    // Default fallback
    return status.toString();
  }

  Color _getStatusColor(String status) {
    String statusText = _getStatusText(status).toLowerCase();
    switch (statusText) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.grey;
      case "pending":
        return Colors.orange;
      case "0":
        return Colors.red;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.yellowAccent;
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= pendingEmployees.length) return null;

    final pendingEmployee = pendingEmployees[index];
    var newStatus = "";
    final status = pendingEmployee.status.toString();
    if (status == '2') {
      newStatus = "Pending";
    } else if (status == '0') {
      newStatus = "Deleted";
    }

    return DataRow(cells: [
      DataCell(
        Center(
          child: CircleAvatar(
            radius: 20,
            backgroundImage: _getProfileImage(pendingEmployee.profilePicture),
          ),
        ),
      ),
      DataCell(Text(pendingEmployee.id.toString())),
      DataCell(Text(pendingEmployee.name ?? "N/A")),
      DataCell(Text(pendingEmployee.mobileNumber ?? "N/A")),
      DataCell(Text(pendingEmployee.mobileNumber ?? "n/A")),
      DataCell(Text(pendingEmployee.designation ?? "N/A")),
      DataCell(Text(pendingEmployee.dateOfJoining ?? "N/A")),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(pendingEmployee.status.toString()),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            newStatus,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      DataCell(_buildActionMenu(pendingEmployee)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pendingEmployees.length;

  @override
  int get selectedRowCount => 0;
}
