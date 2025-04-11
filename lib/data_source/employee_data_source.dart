import 'dart:convert';

import 'package:bizzmirth_app/controllers/employee_controller.dart';
import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/all_employees/add_employees.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeDataSource extends DataTableSource {
  final BuildContext context;
  List<PendingEmployeeModel> pendingEmployees;

  EmployeeDataSource(this.context, this.pendingEmployees);

  final IsarService isarService = IsarService();
  final EmployeeController employeeController = EmployeeController();
  var isLoading = false;
  String name = "";
  final Map<String, String?> _departmentNameCache = {};

  void getRefNameByID(String refId) {}

  Future<void> deleteEmployee(idToDelete, {bool showToast = true}) async {
    try {
      // await isarService.delete<PendingEmployeeModel>(idToDelete);
      await isarService.updateStatus<PendingEmployeeModel>(idToDelete, 0);
      employeeController.deletePendingEmployee(idToDelete);
      Navigator.pop(context);
      if (showToast) {
        ToastHelper.showSuccessToast(
            context: context, title: "Pending Employee Deleted.");
      }
    } catch (e) {
      Logger.error("Failed to delete employee: $e");
    }
  }

  void showLoadingDialog(BuildContext context,
      {String message = "Processing..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  Future<void> registerEmployee(
      context, PendingEmployeeModel empRegister) async {
    // showLoadingDialog(context, message: "Registering employee...");
    try {
      isLoading = true;
      Logger.warning("Registering the employee ${empRegister.name}");
      final registerEmployee = RegisteredEmployeeModel()
        ..id = empRegister.id
        ..regId = empRegister.regId
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
        ..reportingManagerName = empRegister.reportingManagerName
        ..profilePicture = empRegister.profilePicture
        ..idProof = empRegister.idProof
        ..bankDetails = empRegister.bankDetails;

      await isarService.save<RegisteredEmployeeModel>(registerEmployee);

      await removeEmployeeFromTable(empRegister.id, showToast: false);
      await employeeController.apiUpdateEmployeeStatus(
          context, empRegister.id, empRegister.email);

      ToastHelper.showSuccessToast(
          context: context, title: "Employee Registered.");
      isLoading = false;
      // Navigator.of(context, rootNavigator: true).pop();
      Logger.success("----------- Employee Regisered ${empRegister.name}");
    } catch (e) {
      Logger.error("Failed to register the employee:: $e");
      isLoading = false;
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

  Widget _buildActionMenu(context, PendingEmployeeModel employee) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];

        if (employee.status == 2) {
          menuItems = [
            PopupMenuItem(
              value: "view",
              child: ListTile(
                  leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
                  title: Text("View"),
                  onTap: () {
                    Logger.error('${employee.profilePicture}');
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
                  // Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              value: "complete",
              child: ListTile(
                leading: Icon(Icons.app_registration,
                    color: const Color.fromARGB(255, 0, 238, 127)),
                title: Text("Complete"),
                onTap: () {
                  Logger.warning(
                      "------------ Register ${employee.name}------------");
                  registerEmployee(context, employee);
                  // Navigator.pop(context);
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

  String extractPathSegment(String fullPath, String folderPrefix) {
    int index = fullPath.lastIndexOf(folderPrefix);
    if (index != -1) {
      return fullPath.substring(index);
    }
    return fullPath;
  }

  Widget getProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            "assets/default_profile.png",
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final String imageUrl;
    if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
      imageUrl = profilePicture;
    } else {
      final newpath = extractPathSegment(profilePicture, 'profile_pic/');
      imageUrl = "https://testca.uniqbizz.com/uploading/$newpath";
    }

    Logger.success("Final image URL: $imageUrl");

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Logger.error("Failed to load image: $error");S
            return Image.asset(
              "assets/default_profile.png",
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Future<String> getReportingManagerName(String? managerId) async {
    if (managerId == null || managerId.isEmpty) {
      return "N/A";
    }

    // Check if we already have this department name cached
    if (_departmentNameCache.containsKey(managerId)) {
      return _departmentNameCache[managerId] ?? "N/A";
    }

    // If not cached, fetch it
    final deptName = await getDepartmentNameById(managerId);
    // Store in cache for future use
    _departmentNameCache[managerId] = deptName;

    return deptName ?? "N/A";
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

  Future<String> getDepartmentNameById(String departmentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final departmentDataString = prefs.getString('departmentData');

      if (departmentDataString != null) {
        final List<dynamic> departmentData = json.decode(departmentDataString);
        final departmentInfo = departmentData.firstWhere(
          (dept) => dept['id'].toString() == departmentId,
          orElse: () => {'id': departmentId, 'dept_name': null},
        );

        return departmentInfo['dept_name']?.toString() ?? "N/A";
      }
    } catch (e) {
      Logger.error('Error looking up department name: $e');
    }
    return "N/A";
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
            child: getProfileImage(pendingEmployee.profilePicture),
          ),
        ),
      ),
      DataCell(Text(pendingEmployee.id
          .toString())), //changed this for time being because it was showing null
      DataCell(Text(pendingEmployee.name ?? "N/A")),
      DataCell(Text(pendingEmployee.reportingManager ?? "N/A")),
      DataCell(FutureBuilder<String?>(
        future: getReportingManagerNameById(pendingEmployee.reportingManager!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          } else if (snapshot.hasError) {
            return Text("Error");
          } else {
            return Text(snapshot.data ?? "N/A");
          }
        },
      )),
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
      DataCell(_buildActionMenu(context, pendingEmployee)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pendingEmployees.length;

  @override
  int get selectedRowCount => 0;
}
