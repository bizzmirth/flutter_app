import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/data_source/cust_pending_data_source.dart';
import 'package:bizzmirth_app/data_source/cust_reg_data_source.dart';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/filter_bar.dart';

class ViewCustomersPage extends StatefulWidget {
  const ViewCustomersPage({super.key});

  @override
  State<ViewCustomersPage> createState() => _ViewCustomersPageState();
}

class _ViewCustomersPageState extends State<ViewCustomersPage> {
  bool showLoader = true;
  int _rowsPerPage = 5;
  int _rowsPerPage1 = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? fromDateError;
  String? toDateError;

  // Change to proper type
  List<RegisteredCustomer> filteredCustomers = [];
  List<PendingCustomer> filteredPendingCustomers = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          showLoader = false;
        });
      }
    });

    searchController.addListener(_applyFilters);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerController = context.read<CustomerController>();
      customerController.apiGetRegisteredCustomers().then((_) {
        // Initialize filtered customers after data is loaded
        _initializeFilteredCustomers();
      });
      customerController.apiGetPendingCustomers();
    });
  }

  void _initializeFilteredCustomers() {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    setState(() {
      filteredCustomers =
          List<RegisteredCustomer>.from(customerController.registeredCustomers);
    });
  }

  void _onPendingSearchChanged(String searchTerm) {
    _applyPendingFilters(searchTerm: searchTerm);
  }

  void _onPendingDateRangeChanged(DateTime? fromDate, DateTime? toDate) {
    _applyPendingFilters(fromDate: fromDate, toDate: toDate);
  }

  void _initializeFilteredPendingCustomers() {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    setState(() {
      filteredPendingCustomers = List.from(customerController.pendingCustomers);
    });
  }

  void _onPendingClearFilters() {
    _initializeFilteredPendingCustomers();
  }

  void _applyPendingFilters(
      {String? searchTerm, DateTime? fromDate, DateTime? toDate}) {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);

    if (customerController.pendingCustomers.isEmpty) {
      return;
    }

    setState(() {
      filteredPendingCustomers =
          customerController.pendingCustomers.where((customer) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter
        if (searchTerm != null && searchTerm.isNotEmpty) {
          String searchTermLower = searchTerm.toLowerCase();
          matchesSearch = customer.firstname
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.referenceNo?.toLowerCase().contains(searchTermLower) ==
                  true ||
              customer.taReferenceName
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.taReferenceNo?.toLowerCase().contains(searchTermLower) ==
                  true;
        }

        // Date range filter
        if (fromDate != null || toDate != null) {
          if (customer.registerDate != null &&
              customer.registerDate!.isNotEmpty) {
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy");
              DateTime? customerDate =
                  inputFormat.parse(customer.registerDate!);

              if (fromDate != null && customerDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  customerDate.isAfter(toDate.add(Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              print(
                  "Error parsing pending customer date: ${customer.registerDate} - $e");
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    DateTime lastDate = isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            fromDateError = "From Date can't be after To Date";
          } else {
            fromDate = pickedDate;
            fromDateError = null;
            _applyFilters();
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
            _applyFilters();
          }
        }
      });
    }
  }

  void _applyFilters() {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);

    // Check if data is available
    if (customerController.registeredCustomers.isEmpty) {
      return;
    }

    setState(() {
      filteredCustomers =
          customerController.registeredCustomers.where((customer) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter
        if (searchController.text.isNotEmpty) {
          String searchTerm = searchController.text.toLowerCase();
          matchesSearch =
              customer.firstName?.toLowerCase().contains(searchTerm) == true ||
                  customer.referenceNo?.toLowerCase().contains(searchTerm) ==
                      true ||
                  customer.taReferenceName
                          ?.toLowerCase()
                          .contains(searchTerm) ==
                      true ||
                  customer.taReferenceNo?.toLowerCase().contains(searchTerm) ==
                      true;
        }

        // Date range filter
        if (fromDate != null || toDate != null) {
          if (customer.registerDate != null &&
              customer.registerDate!.isNotEmpty) {
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy");
              DateTime? customerDate =
                  inputFormat.parse(customer.registerDate!);

              if (fromDate != null && customerDate.isBefore(fromDate!)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  customerDate.isAfter(toDate!.add(Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              print("Error parsing date: ${customer.registerDate} - $e");
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      searchController.clear();
      fromDate = null;
      toDate = null;
      fromDateError = null;
      toDateError = null;
      _initializeFilteredCustomers(); // Reset to all customers
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void navigateWithLoader(BuildContext context, Widget nextPage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AppLoader(),
    );

    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pop(context); // close loader
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerController>(
        builder: (context, customerController, child) {
      String pendingUserCount = filteredPendingCustomers.isEmpty
          ? customerController.pendingCustomers.length.toString()
          : filteredPendingCustomers.length.toString();
      String userCount = filteredCustomers.isEmpty &&
              (searchController.text.isEmpty &&
                  fromDate == null &&
                  toDate == null)
          ? customerController.registeredCustomers.length.toString()
          : filteredCustomers.length.toString();

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'View Referral Customers',
            style: Appwidget.poppinsAppBarTitle(),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: (showLoader)
            ? const AppLoader()
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
                      FilterBar(
                        userCount: pendingUserCount,
                        onSearchChanged: _onPendingSearchChanged,
                        onDateRangeChanged: _onPendingDateRangeChanged,
                        onClearFilters: _onPendingClearFilters,
                      ),

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
                            ],
                            source: MyrefCustPendingDataSource(
                                // Use filtered pending customers
                                filteredPendingCustomers.isEmpty
                                    ? customerController.pendingCustomers
                                    : filteredPendingCustomers,
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "All Registered Referral Customer's List:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.black26),

                      // Filter Bar
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              // Search Bar
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // From Date Picker
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => _selectDate(context, true),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: fromDateError != null
                                          ? Border.all(
                                              color: Colors.red, width: 1)
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      fromDate == null
                                          ? "From Date"
                                          : DateFormat.yMMMd()
                                              .format(fromDate!),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),

                              Text("  --  "),

                              // To Date Picker
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => _selectDate(context, false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: toDateError != null
                                          ? Border.all(
                                              color: Colors.red, width: 1)
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      toDate == null
                                          ? "To Date"
                                          : DateFormat.yMMMd().format(toDate!),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Count Users
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text("Users: $userCount"),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Clear Filters Button
                              IconButton(
                                onPressed: _clearFilters,
                                icon: Icon(Icons.clear, color: Colors.red),
                                tooltip: "Clear Filters",
                              ),

                              SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),

                      // Error Messages
                      if (fromDateError != null || toDateError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            children: [
                              if (fromDateError != null)
                                Text(
                                  fromDateError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              if (fromDateError != null && toDateError != null)
                                Text(" | ",
                                    style: TextStyle(color: Colors.red)),
                              if (toDateError != null)
                                Text(
                                  toDateError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                            ],
                          ),
                        ),

                      // Paginated Table for Registered List
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
                              DataColumn(label: Text("Customer ID")),
                              DataColumn(label: Text("Full Name")),
                              DataColumn(label: Text("Reg. ID")),
                              DataColumn(label: Text("Reg. Name")),
                              DataColumn(label: Text("Joining Date")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Action"))
                            ],
                            source: MyrefCustRegDataSource(
                                // Use filtered customers if available, otherwise use all customers
                                filteredCustomers.isEmpty &&
                                        (searchController.text.isEmpty &&
                                            fromDate == null &&
                                            toDate == null)
                                    ? customerController.registeredCustomers
                                    : filteredCustomers,
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

            final customerController = context.read<CustomerController>();
            await customerController.apiGetRegisteredCustomers();
            await customerController.apiGetPendingCustomers();
            // Refresh filtered customers after API calls
            _initializeFilteredCustomers();
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
