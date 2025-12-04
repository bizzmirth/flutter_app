import 'package:bizzmirth_app/data_source/franchise_data_sources/fanchise_pending_customer_data_source.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_pending_customer_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';

class FranchiseCustomer extends StatefulWidget {
  const FranchiseCustomer({super.key});

  @override
  State<FranchiseCustomer> createState() => _ViewCustomersPageState1();
}

class _ViewCustomersPageState1 extends State<FranchiseCustomer> {
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
          'View Customers',
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
                    "All Pending Customer's List:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),
              const FilterBar(),

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
                    columns: const [
                      DataColumn(label: Text('Sr. No.')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Ref. ID')),
                      DataColumn(label: Text('Ref. Name')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                    ],
                    source:
                        FanchisePendingCustomerDataSource(orders, this.context),
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
                  "All Registered Customer's List:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),

              // MyEmployeeRegDataSource

              const FilterBar(),

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
                    columns: const [
                      DataColumn(label: Text('Customer ID and Name')),
                      DataColumn(label: Text('Reference ID and Name')),
                      DataColumn(label: Text('Type/Complementory')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Joining Date')),
                      DataColumn(label: Text('Status')),
                    ],
                    source: FranchisePendingCustomerDataSource(
                      orders1,
                      this.context,
                    ),
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
    );
  }
}
