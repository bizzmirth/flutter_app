import 'package:bizzmirth_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PackageMarkupPage extends StatefulWidget {
  const PackageMarkupPage({super.key});

  @override
  State<PackageMarkupPage> createState() => _PackageMarkupPageState();
}

class _PackageMarkupPageState extends State<PackageMarkupPage> {
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
          'Package Markup',
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
                    "All Pending Markup:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // No border line
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  child: PaginatedDataTable(
                    columnSpacing: 40,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("P_ID")),
                      DataColumn(label: Text("P_Name")),
                      DataColumn(label: Text("TA Name")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Markup Price")),
                      DataColumn(label: Text("Markup Added")),
                      DataColumn(label: Text("Selling Price")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyPackageMarkupDataSource(packagemarkup),
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
                  "All Approved Markup:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // No border line
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    columnSpacing: 40,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("P_ID")),
                      DataColumn(label: Text("P_Name")),
                      DataColumn(label: Text("TA Name")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Markup Price")),
                      DataColumn(label: Text("Markup Added")),
                      DataColumn(label: Text("Selling Price")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: MyPackageMarkupApprovedDataSource(packagemarkup),
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
