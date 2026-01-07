import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_customer_controller.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/fanchise_pending_customer_data_source.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_registered_customer_data_source.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FranchiseCustomerPage extends StatefulWidget {
  const FranchiseCustomerPage({super.key});

  @override
  State<FranchiseCustomerPage> createState() => _FranchiseCustomerPageState();
}

class _FranchiseCustomerPageState extends State<FranchiseCustomerPage> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final controller =
        Provider.of<FranchiseeCustomerController>(context, listen: false);
    await controller.fetchFranchiseePendingCustomers();
    await controller.fetchFranchiseeRegisteredCustomers();
  }

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
      body: Consumer<FranchiseeCustomerController>(
        builder: (context, controller, _) {
            final isLoading = controller.state == ViewState.loading;
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2️⃣ Error
          if (controller.state == ViewState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ToastHelper.showErrorToast(
                    title:
                        controller.failure?.message ?? 'Something went wrong');
              },
            );
          }
          return SingleChildScrollView(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        source: FanchisePendingCustomerDataSource(
                          controller.pendingCustomers,
                          this.context,
                        ),
                        rowsPerPage: _rowsPerPage,
                        availableRowsPerPage: AppData.availableRowsPerPage,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        source: FranchiseRegisteredCustomerDataSource( // TODO: complete this module 
                          controller.registeredCustomers,
                          this.context,
                        ),
                        rowsPerPage: _rowsPerPage1,
                        availableRowsPerPage: AppData.availableRowsPerPage,
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
          );
        },
      ),
    );
  }
}
