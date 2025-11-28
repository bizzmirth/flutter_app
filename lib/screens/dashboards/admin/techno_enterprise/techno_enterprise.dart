import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/techno_enterprise/add_techno_enterprise.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TechnoEnterprisePage extends StatefulWidget {
  const TechnoEnterprisePage({super.key});

  @override
  State<TechnoEnterprisePage> createState() => _TechnoEnterprisePageState();
}

class _TechnoEnterprisePageState extends State<TechnoEnterprisePage> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Techno Enterprise',
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
                    'All Pending Techno Enterprise List:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),
              const FilterBar1(),

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
                    columns: const [
                      DataColumn(label: Text('           ')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Ref. ID')),
                      DataColumn(
                          label:
                              Text('Ref. Name')), // Fixed duplicate column name
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    source: MyTechnoPendingDataSource(orderstechno),
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

              const SizedBox(height: 25),
              const Divider(thickness: 1, color: Colors.black26),
              // Upcoming Events Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'All Registered Techno Enterprise List:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),

              const FilterBar1(),
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
                    columns: const [
                      DataColumn(label: Text('           ')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Ref. ID')),
                      DataColumn(
                          label:
                              Text('Ref. Name')), // Fixed duplicate column name
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    source: MyTechnoRegDataSource(orderstechno1),
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
            MaterialPageRoute(builder: (context) => const AddTechnoPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add New Mentor',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
