import 'package:bizzmirth_app/data_source/bch_data_sources/bch_pending_tc_data_source.dart';
import 'package:bizzmirth_app/entities/pending_techno_enterprise/pending_techno_enterprise_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ViewTEPage1 extends StatefulWidget {
  const ViewTEPage1({super.key});

  @override
  State<ViewTEPage1> createState() => _ViewTEPageState1();
}

class _ViewTEPageState1 extends State<ViewTEPage1> {
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
          'View Techno Enterprise',
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
                      DataColumn(label: Text("           ")),
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
                    source: BchPendingTcDataSource(context,
                        orderstechno.cast<PendingTechnoEnterpriseModel>()),
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
                      DataColumn(label: Text("           ")),
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
    );
  }
}
