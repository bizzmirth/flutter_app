import 'dart:async';

import 'package:bizzmirth_app/controllers/admin_busniess_mentor_controller.dart';
import 'package:bizzmirth_app/data_source/pending_busniess_mentors_data_source.dart';
import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/business_mentor/add_business_mentor.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessMentorPage extends StatefulWidget {
  const BusinessMentorPage({super.key});

  @override
  State<BusinessMentorPage> createState() => _BusinessMentorPageState();
}

class _BusinessMentorPageState extends State<BusinessMentorPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  List<PendingBusinessMentorModel> pendingBusinessMentor = [];
  final IsarService isarService = IsarService();
  late StreamSubscription<void> _pendingBusinessMentor;
  final AdminBusniessMentorController adminBusniessMentorController =
      AdminBusniessMentorController();
  @override
  void initState() {
    super.initState();
    _pendingBusinessMentor =
        isarService.watchCollection<PendingBusinessMentorModel>().listen((_) {
      getBusniessMenotrs();
    });
    getBusniessMenotrs();
    loadBusniessMenotrs();
  }

  @override
  void dispose() {
    _pendingBusinessMentor.cancel();
    super.dispose();
  }

  Future<void> loadBusniessMenotrs() async {
    try {
      await adminBusniessMentorController.fetchAndSavePendingBusinessMentor();

      getBusniessMenotrs();
    } catch (e) {
      Logger.error("Error fetching pending business mentors : $e");
    }
  }

  Future<void> getBusniessMenotrs() async {
    try {
      final getBusmiessMentors =
          await isarService.getAll<PendingBusinessMentorModel>();
      setState(() {
        pendingBusinessMentor = getBusmiessMentors;
      });
    } catch (e) {
      Logger.error("Error fetching pending business mentors : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Mentors',
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
                    "All Pending Business Mentor List:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              FilterBar(),

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
                    columnSpacing: 35,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("Image")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(label: Text("Ref. Name")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyBMDataSource(pendingBusinessMentor),
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
                  "All Registered Business Mentor List:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              FilterBar(),
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
                    columnSpacing: 35,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("           ")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(label: Text("Ref. Name")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyBMRegDataSource(orders1BM),
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
      ), //AddViewTEPage
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddbmPage()),
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
