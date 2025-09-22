import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:flutter/material.dart';

class OrderHistPage extends StatefulWidget {
  const OrderHistPage({super.key});

  @override
  State<OrderHistPage> createState() => _OrderHistPageState();
}

class _OrderHistPageState extends State<OrderHistPage> {
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Packages',
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
                    'Order History:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  const SizedBox(width: 530),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // No border line
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                    columnSpacing: 32,
                    dataRowMinHeight: 40,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Order Date')),
                      DataColumn(label: Text('Cust. Id & Name')),
                      DataColumn(label: Text('Package')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Status')),
                    ],
                    source: MyPackageOrderHistDataSource(packagehist),
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
