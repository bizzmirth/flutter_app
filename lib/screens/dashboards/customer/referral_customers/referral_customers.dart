import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/data_source/cust_pending_data_source.dart';
import 'package:bizzmirth_app/data_source/cust_reg_data_source.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewCustomersPage extends StatefulWidget {
  const ViewCustomersPage({super.key});

  @override
  State<ViewCustomersPage> createState() => _ViewCustomersPageState();
}

class _ViewCustomersPageState extends State<ViewCustomersPage> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().apiGetRegisteredCustomers();
      context.read<CustomerController>().apiGetPendingCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerController>(
        builder: (context, customerController, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'View Referral Customersaa',
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
        body: customerController.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
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
                            "All Pending Referral Customer's List:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                              DataColumn(label: Text("Image")),
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Full Name")),
                              DataColumn(label: Text("Ref. ID")),
                              DataColumn(label: Text("Ref. Name")),
                              DataColumn(label: Text("Joining Date")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Action"))
                            ],
                            source: MyrefCustPendingDataSource(
                                customerController.pendingCustomers,
                                this.context),
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                              DataColumn(label: Text("Image")),
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Full Name")),
                              DataColumn(label: Text("Reg. ID")),
                              DataColumn(label: Text("Reg. Name")),
                              DataColumn(label: Text("Joining Date")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Action"))
                            ],
                            source: MyrefCustRegDataSource(
                                customerController.registeredCustomers,
                                this.context),
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
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddReferralCustomer()),
            );

            context.read<CustomerController>().apiGetRegisteredCustomers();
            context.read<CustomerController>().apiGetPendingCustomers();
          },
          backgroundColor: const Color.fromARGB(255, 153, 198, 250),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          tooltip: "Add New Referral Customer",
          child: Icon(Icons.add, size: 30),
        ),
      );
    });
  }
}
