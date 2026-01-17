import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_controller.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_pending_tc_data_source.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_registered_tc_data_source.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/add_franchise_tc.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FranchiseTc extends StatefulWidget {
  const FranchiseTc({super.key});

  @override
  State<FranchiseTc> createState() => _FranchiseTcState();
}

class _FranchiseTcState extends State<FranchiseTc> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FranchiseeTcController>(context, listen: false)
          .fetchPendingTcs();
      Provider.of<FranchiseeTcController>(context, listen: false)
          .fetchRegisteredTcs();
    });
  }

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
      body: Consumer<FranchiseeTcController>(
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
                        'All Pending Travel Consultant List:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        columnSpacing: 40,
                        dataRowMinHeight: 40,
                        columns: const [
                          DataColumn(label: Text('Sr. No.')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('BM Ref ID & Name')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Joining Date')),
                          DataColumn(label: Text('Status')),
                        ],
                        source:
                            FranchisePendingTcDataSource(controller.pendingTcs),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        columnSpacing: 40,
                        dataRowMinHeight: 40,
                        columns: const [
                          DataColumn(label: Text('TC ID & Name')),
                          DataColumn(label: Text('BM Ref ID & Name')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Joining Date')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        source: FranchiseRegisteredTcDataSource(context,
                            controller.registeredTcs),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddFranchiseTc()));
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
