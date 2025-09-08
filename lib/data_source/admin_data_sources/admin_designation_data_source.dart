import 'package:bizzmirth_app/controllers/admin_controller/admin_designation_department_controller.dart';
import 'package:bizzmirth_app/models/designation_model.dart';
import 'package:bizzmirth_app/utils/department_dropdown.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminDesigDataSource extends DataTableSource {
  final List<Designation> _designations;
  final BuildContext context;
  AdminDesigDataSource(this._designations, this.context);
  bool isLoading = false;

  Future<void> deleteDesignation(Designation designation) async {
    try {
      isLoading = true;
      final controller = Provider.of<AdminDesignationDepartmentController>(
          context,
          listen: false);
      await controller.apiDeleteDesignation(designation);
      await controller.fetchDesignations();
      notifyListeners();
      isLoading = false;
      ToastHelper.showSuccessToast(
          context: context, title: "Designation deleted successfully!");
    } catch (e) {
      Logger.error("Error deleting designation");
      isLoading = false;
    }
  }

  Future<void> restoreDesignation(Designation designation) async {
    try {
      isLoading = true;
      final controller = Provider.of<AdminDesignationDepartmentController>(
          context,
          listen: false);
      await controller.apiRestoreDesignation(designation);
      await controller.fetchDesignations();
      notifyListeners();
      isLoading = false;
      ToastHelper.showSuccessToast(
          context: context, title: "Designation restored successfully!");
    } catch (e) {
      Logger.error("Error restoring designation");
      isLoading = false;
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _designations.length) return null;
    final desigantion = _designations[index];

    return DataRow(
      cells: [
        DataCell(Text(desigantion.id)),
        DataCell(Text(desigantion.deptName)),
        DataCell(Text(desigantion.desgName)),
        DataCell(_buildActionMenu(desigantion)),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu(Designation desgination) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> menuItems = [];

        if (int.tryParse(desgination.status) == 1) {
          menuItems = [
            PopupMenuItem(
              value: "view",
              child: ListTile(
                leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
                title: Text("View"),
                onTap: () {
                  Logger.success("View Designation ${desgination.id}");
                  Navigator.pop(context);
                  addDesignation(context,
                      designation: desgination, isViewMode: true);
                },
              ),
            ),
            PopupMenuItem(
              value: "edit",
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.blueAccent),
                title: Text("Edit"),
                onTap: () {
                  Logger.success("Edit Designation ${desgination.id}");
                  Navigator.pop(context);
                  addDesignation(context,
                      designation: desgination, isEditMode: true);
                },
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete"),
                onTap: () {
                  deleteDesignation(desgination);
                  Navigator.pop(context);
                },
              ),
            ),
          ];
        } else if (int.tryParse(desgination.status) == 2) {
          menuItems = [
            PopupMenuItem(
              value: "restore",
              child: ListTile(
                leading: Icon(Icons.restore, color: Colors.green),
                title: Text("Restore"),
                onTap: () {
                  restoreDesignation(desgination);
                  Navigator.pop(context);
                },
              ),
            )
          ];
        }
        return menuItems;
      },
      icon: Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  void addDesignation(BuildContext context,
      {Designation? designation,
      bool isViewMode = false,
      bool isEditMode = false}) {
    final TextEditingController nameController =
        TextEditingController(text: designation?.desgName ?? '');
    final AdminDesignationDepartmentController controller =
        AdminDesignationDepartmentController();
    String? selectedDepartmentId = designation?.deptId;

    var title = "";
    if (isViewMode) {
      title = "View Designation";
    } else if (isEditMode) {
      title = "Edit Designation";
    } else {
      title = "Add Designation";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Designation Name *',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: nameController,
                  readOnly: isViewMode,
                  decoration: InputDecoration(
                    hintText: "Enter designation name...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: isViewMode ? Colors.grey[200] : Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15), // 🔥 Adjust padding
                  ),
                ),
              ),
              DepartmentDropdown(
                isViewMode: isViewMode,
                initialDepartment:
                    designation?.deptName, // Pass the existing department name
                initialDepartmentId: selectedDepartmentId,
                onDepartmentSelected: (selectedDept) {
                  selectedDepartmentId = selectedDept?['id'];
                },
              ),
            ],
          ),
          actions: isViewMode
              ? [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  )
                ]
              : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isNotEmpty) {
                            try {
                              await controller.apiEditDesignation(
                                  designation?.id,
                                  nameController.text,
                                  designation?.deptId,
                                  designation?.status);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final controller = Provider.of<
                                        AdminDesignationDepartmentController>(
                                    context,
                                    listen: false);
                                Future.wait([
                                  controller.fetchDesignations(),
                                ]);
                              });
                              Navigator.of(context).pop();
                              ToastHelper.showSuccessToast(
                                  context: context,
                                  title: "Designation edited successfully!.");
                              controller.notifyListeners();
                            } catch (e) {
                              Logger.error("Error editing department");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
        );
      },
    );
  }

  @override
  int get rowCount => _designations.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
