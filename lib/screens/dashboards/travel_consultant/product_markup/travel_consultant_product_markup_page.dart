import 'package:bizzmirth_app/controllers/tc_controller/tc_markup_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_product_markup_data_source.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductMarkupPage extends StatefulWidget {
  const ProductMarkupPage({super.key});

  @override
  State<ProductMarkupPage> createState() => _ProductMarkupPageState();
}

class _ProductMarkupPageState extends State<ProductMarkupPage> {
  int _rowsPerPage = 10; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  // Dropdown related
  String _selectedTravelType = 'ALL';
  final List<String> _travelTypes = AppData.travelTypes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Markup',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<TcMarkupController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: SingleChildScrollView());
          }
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
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
                        'Product Markup',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          'Select Travel Type:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 20),
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: _selectedTravelType,
                              items: _travelTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedTravelType = value;
                                  });
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const FilterBar(),

                  // Dropdown Section for Travel Type

                  // Data Table Section
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
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Package Name')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Commission')),
                          DataColumn(label: Text('Markup')),
                          DataColumn(label: Text('Selling Price')),
                          DataColumn(label: Text('Action'))
                        ],
                        source: TcProductMarkupDataSource(
                            controller.tcMarkupDetails, context),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
