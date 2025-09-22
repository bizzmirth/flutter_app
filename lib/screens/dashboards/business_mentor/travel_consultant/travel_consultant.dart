import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/travel_consultant/add_travel_consultants.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';

class ViewTCPage extends StatefulWidget {
  const ViewTCPage({super.key});

  @override
  State<ViewTCPage> createState() => _ViewTCPageState();
}

class _ViewTCPageState extends State<ViewTCPage> {
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
          'View Travel Consultant',
          style: Appwidget.poppinsAppBarTitle(),
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
              const Divider(thickness: 1, color: Colors.black26),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'All Pending Travel Consultant List:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),
              const FilterBar(),

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
                    columnSpacing: 20,
                    dataRowMinHeight: 40,
                    columns: const [
                      DataColumn(label: Text('           ')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Ref. ID')),
                      DataColumn(label: Text('Ref. Name')),
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action'))
                    ],
                    source: MyViewTCDataSource(tcorders),
                    rowsPerPage: _rowsPerPage,
                    availableRowsPerPage: const [5, 10, 15, 20, 25],
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

              const SizedBox(height: 35),
              const Divider(thickness: 1, color: Colors.black26),
              // Upcoming Events Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'All Registered Travel Consultant List:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),

              const FilterBar(),
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
                    columnSpacing: 20,
                    dataRowMinHeight: 40,
                    columns: const [
                      DataColumn(label: Text('           ')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Ref. ID')),
                      DataColumn(label: Text('Ref. Name')),
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Packages Sold')),
                      DataColumn(label: Text('Action')),
                    ],
                    source: MyViewTCRegDataSource(tcvieworders1),
                    rowsPerPage: _rowsPerPage1,
                    availableRowsPerPage: const [5, 10, 15, 20, 25],
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
            MaterialPageRoute(builder: (context) => const AddViewTEPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add New TC',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
