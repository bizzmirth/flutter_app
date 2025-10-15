import 'package:bizzmirth_app/controllers/tc_controller/tc_customer_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_pending_customer_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/customers/add_customer_tc.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewTcCustomers extends StatefulWidget {
  const ViewTcCustomers({super.key});

  @override
  State<ViewTcCustomers> createState() => _ViewTcCustomersState();
}

class _ViewTcCustomersState extends State<ViewTcCustomers> {
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;

  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  void initState() {
    super.initState();
    // Trigger the API call once the page loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<TcCustomerController>().apiGetTcPendingCustomers();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Customers', style: Appwidget.poppinsAppBarTitle()),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<TcCustomerController>(
        builder: (context, tcController, _) {
          if (tcController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tcController.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tcController.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      tcController.apiGetTcPendingCustomers();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ✅ Show data (pending customers)
          final pendingCustomers = tcController.pendingCustomers;

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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  const FilterBar(),

                  /// 🧾 Pending Customer Table
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
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Full Name')),
                          DataColumn(label: Text('Ref. ID')),
                          DataColumn(label: Text('Ref. Name')),
                          DataColumn(label: Text('Joining Date')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        source: TcPendingCustomerDataSource(
                          data: pendingCustomers,
                          context: context,
                        ),
                        rowsPerPage: _rowsPerPage,
                        availableRowsPerPage: const [5, 10, 15, 20, 25],
                        onRowsPerPageChanged: (value) {
                          if (value != null) {
                            setState(() => _rowsPerPage = value);
                          }
                        },
                        arrowHeadColor: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),
                  const Divider(thickness: 1, color: Colors.black26),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "All Registered Customer's List:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),

                  const FilterBar(),

                  // 🧾 Registered Customer Table (if available)
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
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Full Name')),
                          DataColumn(label: Text('Reg. ID')),
                          DataColumn(label: Text('Reg. Name')),
                          DataColumn(label: Text('Joining Date')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        source: MyBDMCustRegDataSource([], context),
                        rowsPerPage: _rowsPerPage1,
                        availableRowsPerPage: const [5, 10, 15, 20, 25],
                        onRowsPerPageChanged: (value) {
                          if (value != null) {
                            setState(() => _rowsPerPage1 = value);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCustomerTc()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add New Customer',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
