import 'dart:async';

import 'package:bizzmirth_app/data_source/employee_data_source.dart';
import 'package:bizzmirth_app/data_source/registered_employee_data_source.dart';
import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/all_employees/add_employees.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllEmployeesPage extends StatefulWidget {
  const AllEmployeesPage({super.key});

  @override
  State<AllEmployeesPage> createState() => _AllEmployeesPageState();
}

class _AllEmployeesPageState extends State<AllEmployeesPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  late StreamSubscription<void> _pendingEmployeeWatcher;
  late StreamSubscription<void> _registeredEmployeeWatcher;
  List<PendingEmployeeModel> employee = [];
  List<RegisteredEmployeeModel> registeredEmployee = [];

  final IsarService isarService = IsarService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pendingEmployeeWatcher =
        isarService.watchCollection<PendingEmployeeModel>().listen((_) {
      getEmployee();
    });

    _registeredEmployeeWatcher =
        isarService.watchCollection<RegisteredEmployeeModel>().listen((_) {
      getPendingEmployees();
    });
    getEmployee();
    getPendingEmployees();
  }

  @override
  void dispose() {
    _pendingEmployeeWatcher.cancel();
    _registeredEmployeeWatcher.cancel();
    super.dispose();
  }

  void getEmployee() async {
    final getEmployee = await isarService.getAll<PendingEmployeeModel>();
    setState(() {
      employee = getEmployee;
    });
  }

  void getPendingEmployees() async {
    final getEmployee = await isarService.getAll<RegisteredEmployeeModel>();
    setState(() {
      registeredEmployee = getEmployee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Employees',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Divider(thickness: 1, color: Colors.black26),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "All Pending Employees List:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              FilterBar(),

              // Paginated Table for Pending List
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: (_rowsPerPage * dataRowHeight) +
                      headerHeight +
                      paginationHeight,
                  child: PaginatedDataTable(
                    columnSpacing: 36,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(label: Text("Ref. Name")),
                      DataColumn(label: Text("Designation")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: EmployeeDataSource(context, employee),
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
                  ),
                ),
              ),

              SizedBox(height: 35),
              Divider(thickness: 1, color: Colors.black26),
              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "All Registered Employees List:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              // MyEmployeeRegDataSource

              FilterBar(),

              // Paginated Table for Pending List
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
                    columnSpacing: 36,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Reg. ID")),
                      DataColumn(label: Text("Reg. Name")),
                      DataColumn(label: Text("Designation")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source:
                        PendingEmployeeDataSource(context, registeredEmployee),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeePage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: "Add New Mentor",
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
