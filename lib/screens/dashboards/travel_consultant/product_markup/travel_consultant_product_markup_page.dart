import 'package:bizzmirth_app/data_source/tc_data_sources/tc_product_markup_data_source.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';

class ProductMarkupPage extends StatefulWidget {
  const ProductMarkupPage({super.key});

  @override
  State<ProductMarkupPage> createState() => _ProductMarkupPageState();
}

class _ProductMarkupPageState extends State<ProductMarkupPage> {
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  // Dropdown related
  String _selectedTravelType = 'ALL';
  final List<String> _travelTypes = ['ALL', 'International', 'Domestic'];

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
                    "Product Markup",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Text(
                      "Select Travel Type:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 20),
                    DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
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
                          isExpanded: false,
                          icon: Icon(Icons.arrow_drop_down),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FilterBar(),

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
                    columns: [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Package Name")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Commission")),
                      DataColumn(label: Text("Markup")),
                      DataColumn(label: Text("Selling Price")),
                      DataColumn(label: Text("Action"))
                    ],
                    source: TcProductMarkupDataSource(productmarkup),
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
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> productmarkup = [
  {
    "id": "1",
    "pname": "Shimla",
    "price": "32000",
    "com": "2000",
    "sprice": "34000",
  },
  {
    "id": "2",
    "pname": "Shimla",
    "price": "32000",
    "com": "2000",
    "sprice": "34000",
  },
  {
    "id": "3",
    "pname": "Shimla",
    "price": "32000",
    "com": "2000",
    "sprice": "34000",
  },
  {
    "id": "4",
    "pname": "Shimla",
    "price": "32000",
    "com": "2000",
    "sprice": "34000",
  },
  {
    "id": "5",
    "pname": "Shimla",
    "price": "32000",
    "com": "2000",
    "sprice": "34000",
  },
];
