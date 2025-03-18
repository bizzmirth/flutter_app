import 'package:bizzmirth_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmenitiesPage extends StatefulWidget {
  const AmenitiesPage({super.key});

  @override
  State<AmenitiesPage> createState() => _AmenitiesPageState();
}

class _AmenitiesPageState extends State<AmenitiesPage> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  int _rowsPerPage2 = 5;
  int _rowsPerPage3 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Amenities',
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
                    "Manage Star Types:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  SizedBox(width: 590),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Add Stay Types",
                          style: TextStyle(color: Colors.white)),
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
                    columnSpacing: 280,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Action")),
                    ],
                    source: MyAmenityStarTypeDataSource(aminitiesstay),
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
              SizedBox(height: 50),
              Divider(thickness: 1, color: Colors.black26),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Manage Meals:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  SizedBox(width: 590),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Add Meals",
                          style: TextStyle(color: Colors.white)),
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
                    columnSpacing: 220,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Action")),
                    ],
                    source: MyAmenityStarTypeDataSource(aminitiesmeals),
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
              Divider(thickness: 1, color: Colors.black26),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Manage Vehicles:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  SizedBox(width: 590),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Add Vehicles",
                          style: TextStyle(color: Colors.white)),
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
                  height: (_rowsPerPage2 * dataRowHeight) +
                      headerHeight +
                      paginationHeight,
                  child: PaginatedDataTable(
                    columnSpacing: 280,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Action")),
                    ],
                    source: MyAmenityVehiclesTypeDataSource(aminitiesvehicles),
                    rowsPerPage: _rowsPerPage2,
                    availableRowsPerPage: [5, 10, 15, 20, 25],
                    onRowsPerPageChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rowsPerPage2 = value;
                        });
                      }
                    },
                    arrowHeadColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Divider(thickness: 1, color: Colors.black26),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Manage Occupancy:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  SizedBox(width: 590),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Add Occupancy",
                          style: TextStyle(color: Colors.white)),
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
                  height: (_rowsPerPage3 * dataRowHeight) +
                      headerHeight +
                      paginationHeight,
                  child: PaginatedDataTable(
                    columnSpacing: 280,
                    dataRowMinHeight: 40,
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Action")),
                    ],
                    source:
                        MyAmenityOccupancyTypeDataSource(aminitiesoccupancy),
                    rowsPerPage: _rowsPerPage3,
                    availableRowsPerPage: [5, 10, 15, 20, 25],
                    onRowsPerPageChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rowsPerPage3 = value;
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
