import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCustomersPage extends StatefulWidget {
  const ViewCustomersPage({super.key});

  @override
  State<ViewCustomersPage> createState() => _ViewCustomersPageState();
}

class _ViewCustomersPageState extends State<ViewCustomersPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Referral Customers',
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
                    "All Pending Referral Customer's List:",
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
                      DataColumn(label: Text("           ")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Ref. ID")),
                      DataColumn(label: Text("Ref. Name")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyrefCustPendingDataSource(orders, this.context),
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
                  "All Registered Referral Customer's List:",
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
                      DataColumn(label: Text("           ")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Reg. ID")),
                      DataColumn(label: Text("Reg. Name")),
                      DataColumn(label: Text("Joining Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyrefCustRegDataSource(orders1, this.context),
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
    );
  }
}
