import 'package:bizzmirth_app/controllers/admin_customer_controller.dart';
import 'package:bizzmirth_app/data_source/admin_cust_pending_data_source.dart';
import 'package:bizzmirth_app/data_source/admin_cust_registered_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/customer/add_customer.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustPage extends StatefulWidget {
  const CustPage({super.key});

  @override
  State<CustPage> createState() => _CustPageState();
}

class _CustPageState extends State<CustPage> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      controller.apifetchPendingEmployee();
      controller.apiFetchRegisteredCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminCustomerController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'All Customers',
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
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Divider(thickness: 1, color: Colors.black26),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "All Pending Customer List:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                              columnSpacing: 30,
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
                              source: MyAdminCustPendingDataSource(
                                  context, controller.pendingCustomer),
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "All Registered Customer List:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                              columnSpacing: 30,
                              dataRowMinHeight: 40,
                              columns: [
                                DataColumn(label: Text("Image")),
                                DataColumn(label: Text("ID")),
                                DataColumn(label: Text("Full Name")),
                                DataColumn(label: Text("Ref. ID")),
                                DataColumn(label: Text("Ref. Name")),
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("Joining Date")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Action"))
                              ],
                              source: MyAdminCustRegDataSource(
                                  context, controller.registeredCustomer),
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
                MaterialPageRoute(builder: (context) => AddcustPage()),
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
      },
    );
  }
}
