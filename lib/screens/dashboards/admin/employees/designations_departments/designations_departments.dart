import 'package:bizzmirth_app/controllers/designation_department_controller.dart';
import 'package:bizzmirth_app/data_source/department_data_source.dart';
import 'package:bizzmirth_app/data_source/designation_data_source.dart';
import 'package:bizzmirth_app/models/department_model.dart';
import 'package:bizzmirth_app/utils/department_dropdown.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DesignationsPage extends StatefulWidget {
  const DesignationsPage({super.key});

  @override
  State<DesignationsPage> createState() => _DesignationsPageState();
}

class _DesignationsPageState extends State<DesignationsPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  final DesignationDepartmentController controller =
      DesignationDepartmentController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
          Provider.of<DesignationDepartmentController>(context, listen: false);
      Future.wait(
          [controller.fetchDepartments(), controller.fetchDesignations()]);
    });
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await controller.fetchDepartments();
      await controller.fetchDesignations();
      setState(() {
        isLoading = false;
      });
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      Logger.success(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DesignationDepartmentController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Departments/Designations',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.03,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading || controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Divider(thickness: 1, color: Colors.black26),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Departments:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    Row(
                      children: [
                        SizedBox(width: 530),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: null,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                                // No border line
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),

                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                          height: (_rowsPerPage * dataRowHeight) +
                              headerHeight +
                              paginationHeight,
                          child: Consumer<DesignationDepartmentController>(
                            builder: (context, value, child) {
                              return PaginatedDataTable(
                                columnSpacing: 255,
                                dataRowMinHeight: 40,
                                columns: [
                                  DataColumn(label: Text("ID")),
                                  DataColumn(label: Text("Department Name")),
                                  DataColumn(label: Text("Action"))
                                ],
                                source: MyDepartDataSource(
                                    controller.departments, context),
                                rowsPerPage: _rowsPerPage,
                                availableRowsPerPage: [5, 10, 15, 20, 25],
                                onRowsPerPageChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _rowsPerPage = value;
                                    });
                                  }
                                },
                                arrowHeadColor: Colors.blue,
                              );
                            },
                          )),
                    ),

                    SizedBox(height: 50),
                    Divider(thickness: 1, color: Colors.black26),
                    // Upcoming Events Section
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Designations:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    Row(
                      children: [
                        SizedBox(width: 530),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: null,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                // No border line
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),

                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: (_rowsPerPage1 * dataRowHeight) +
                            headerHeight +
                            paginationHeight,
                        child: PaginatedDataTable(
                          columnSpacing: 127,
                          dataRowMinHeight: 40,
                          columns: [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Designation")),
                            DataColumn(label: Text("Department")),
                            DataColumn(label: Text("Action"))
                          ],
                          source: MyDesigDataSource(
                              controller.designation, context),
                          rowsPerPage: _rowsPerPage1,
                          availableRowsPerPage: [5, 10, 15, 20, 25],
                          onRowsPerPageChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _rowsPerPage1 = value;
                              });
                            }
                          },
                          arrowHeadColor: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Adddesdialog(context);
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: "Add Department/Designation",
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  void Adddesdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline,
                  size: 40, color: Colors.blueAccent), // Info icon
              SizedBox(height: 10),
              Text(
                'Do you want to add another department or designation?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Adjust this as needed
              children: [
                SizedBox(width: 45),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close popup
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                  ),
                ),
                SizedBox(width: 65), // Adjust spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    Adddepartment(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Add Department',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                ),
                SizedBox(width: 35), // Adjust spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    Adddesignation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Add Designation',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void Adddepartment(BuildContext context,
      {Department? department, bool isViewMode = false}) {
    final TextEditingController nameController = TextEditingController();
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
                isViewMode ? 'Department Details' : 'Add Department',
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
                        onPressed: () {
                          controller.apiAddDepartment(nameController.text);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final controller =
                                Provider.of<DesignationDepartmentController>(
                                    context,
                                    listen: false);
                            Future.wait([
                              controller.fetchDepartments(),
                            ]);
                          });
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

  void Adddesignation(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String? selectedDepartment = "";
    String? selectedDepartmentId = "";
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
                'Add Designation',
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
              SizedBox(height: 10), // 🔥 Add spacing
              SizedBox(
                height: 50, // 🔥 Increase TextBox height
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter designation name...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15), // 🔥 Adjust padding
                  ),
                ),
              ),
              DepartmentDropdown(
                onDepartmentSelected: (selectedDept) {
                  // selectedDept is now a Map with 'id' and 'name'
                  selectedDepartmentId = selectedDept?['id'];
                  selectedDepartment = selectedDept?['name'];
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.apiAddDesignation(
                        nameController.text, selectedDepartmentId);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final controller =
                          Provider.of<DesignationDepartmentController>(context,
                              listen: false);
                      Future.wait([
                        controller.fetchDesignations(),
                      ]);
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ToastHelper.showSuccessToast(
                        context: context,
                        title: "Designation added successfully!.");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Submit',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
