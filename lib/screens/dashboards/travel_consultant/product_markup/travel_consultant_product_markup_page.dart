import 'package:bizzmirth_app/data_source/travel_consultant_product_markup_data_source.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Markup',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 530),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: null,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // No border line
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
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
                    source: MyProductMarkupDataSource(productmarkup),
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
