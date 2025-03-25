import 'dart:async';

import 'package:bizzmirth_app/data_source/pending_techno_enterprise_data_source.dart';
import 'package:bizzmirth_app/entities/pending_techno_enterprise/pending_techno_enterprise_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/techno_enterprise/add_techno_enterprise.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewTEPage extends StatefulWidget {
  const ViewTEPage({super.key});

  @override
  State<ViewTEPage> createState() => _ViewTEPageState();
}

class _ViewTEPageState extends State<ViewTEPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  final IsarService isarService = IsarService();
  List<PendingTechnoEnterpriseModel> technoEnterprise = [];
  late StreamSubscription<void> _pendingTechnoEnterprise;

  @override
  void initState() {
    super.initState();
    _pendingTechnoEnterprise =
        isarService.watchCollection<PendingTechnoEnterpriseModel>().listen((_) {
      getTechnoEnterprise();
    });
    getTechnoEnterprise();
  }

  @override
  void dispose() {
    _pendingTechnoEnterprise.cancel();
    super.dispose();
  }

  Future<void> getTechnoEnterprise() async {
    final getTechnoEnterprise =
        await isarService.getAll<PendingTechnoEnterpriseModel>();
    setState(() {
      technoEnterprise = getTechnoEnterprise;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Techno Enterprise',
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
                    "All Pending Techno Enterprise's List:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              FilterBar1(),

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
                    columnSpacing: 40,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(
                          label:
                              Text("Ref. Name")), // Fixed duplicate column name
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action")),
                    ],
                    source: MyViewTechnoPendingDataSource(
                        context, technoEnterprise),
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

              SizedBox(height: 25),
              Divider(thickness: 1, color: Colors.black26),
              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "All Registered Techno Enterprise List:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              FilterBar1(),
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
                    columnSpacing: 40,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(
                          label:
                              Text("Ref. Name")), // Fixed duplicate column name
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action")),
                    ],
                    source: MyViewTechnoRegDataSource(orderstechno1),
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
            MaterialPageRoute(builder: (context) => AddViewTechnoPage()),
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
