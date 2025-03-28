import 'package:bizzmirth_app/controllers/designation_department_controller.dart';
import 'package:bizzmirth_app/models/department_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyDepartDataSource extends DataTableSource {
  final List<Department> _departments;
  MyDepartDataSource(this._departments);

  @override
  DataRow? getRow(int index) {
    if (index >= _departments.length) return null;
    final department = _departments[index];

    return DataRow(
      cells: [
        DataCell(Text(department.id)),
        DataCell(Text(department.deptName)),
        DataCell(_buildActionMenu(department)),
      ],
    );
  }

  void Adddepartment(BuildContext context,
      {Department? department,
      bool isViewMode = false,
      bool isEditMode = false}) {
    final DesignationDepartmentController controller =
        DesignationDepartmentController();
    final TextEditingController nameController =
        TextEditingController(text: department?.deptName ?? '');
    var title = "";
    if (isViewMode) {
      title = 'View Department';
    } else if (isEditMode) {
      title = 'Edit Department';
    } else {
      title = 'Add Department';
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
                'Department Name *',
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
                    hintText: "Enter department name...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: isViewMode ? Colors.grey[200] : Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
          actions: isViewMode
              ? [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close',
                        style: GoogleFonts.poppins(color: Colors.red)),
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
                              await controller.apiEditDepartment(
                                  department?.id,
                                  nameController.text.trim(),
                                  department
                                      ?.status // Assuming you want to keep the existing status
                                  );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final controller = Provider.of<
                                        DesignationDepartmentController>(
                                    context,
                                    listen: false);
                                Future.wait([
                                  controller.fetchDepartments(),
                                ]);
                              });
                              Navigator.of(context).pop();
                              ToastHelper.showSuccessToast(
                                  context: context,
                                  title: "Department edited successfully!.");
                              controller.notifyListeners();
                            } catch (e) {
                              Logger.error('Error editing data: $e');
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

// Action Menu Widget
  Widget _buildActionMenu(Department department) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "view",
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text("View"),
            onTap: () {
              Logger.success("View Departments ${department.id}");
              Navigator.pop(context);
              Adddepartment(context, department: department, isViewMode: true);
            },
          ),
        ),
        PopupMenuItem(
          value: "edit",
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text("Edit"),
            onTap: () {
              Logger.success("Editing ${department.id}");
              Navigator.pop(context);
              Adddepartment(context, department: department, isEditMode: true);
            },
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete"),
          ),
        ),
      ],
      icon: Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => _departments.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
