import 'package:bizzmirth_app/controllers/cust_product_payout_controller.dart';
import 'package:bizzmirth_app/data_source/cust_product_all_payout_data_source.dart';
import 'package:bizzmirth_app/data_source/cust_product_payout_data_source.dart';
import 'package:bizzmirth_app/models/cust_product_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustProductPayoutsPage extends StatefulWidget {
  final String? userName;
  const CustProductPayoutsPage({super.key, this.userName});

  @override
  State<CustProductPayoutsPage> createState() => _CustProductPayoutsPageState();
}

class _CustProductPayoutsPageState extends State<CustProductPayoutsPage> {
  String selectedDate = "Select month, year";
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  late String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllData();
    });
  }

  void getAllData() async {
    final controller =
        Provider.of<CustProductPayoutController>(context, listen: false);
    userId = await SharedPrefHelper().getCurrentUserCustId();
    controller.getAllPayouts(userId);
    controller.apiGetPreviousPayouts();
    controller.apiGetNextMonthPayouts();
    controller.apiGetTotalPayouts();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Loading Product Payouts...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please wait while we fetch your data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat("MMMM, yyyy").format(picked);
      });
    }
  }

  String getMonthName(String? monthNumber) {
    if (monthNumber == null) return '';

    const monthNames = {
      '01': 'January',
      '02': 'February',
      '03': 'March',
      '04': 'April',
      '05': 'May',
      '06': 'June',
      '07': 'July',
      '08': 'August',
      '09': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
    };

    return monthNames[monthNumber] ?? '';
  }

  void showPayoutDialog(
      BuildContext context,
      String payoutType,
      String date,
      String amount,
      String userId,
      String userName,
      CustProductPayoutController controller) {
    List<CustProductPayoutModel> getPayoutList() {
      switch (payoutType.toLowerCase()) {
        case 'previous payout':
        case 'previous payouts':
          return controller.previousMonthAllPayouts;
        case 'next payout':
        case 'next payouts':
        case 'next month payout':
        case 'next month payouts':
          return controller.nextMonthAllPayouts;
        case 'total payout':
        case 'total payouts':
        case 'all payouts':
          return controller.totalAllPayouts;
        default:
          return controller.totalAllPayouts;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final payoutList = getPayoutList();
        final isMobile = MediaQuery.of(context).size.width < 600;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.95,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          payoutType,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payout summary cards
                  if (isMobile)
                    Column(
                      children: [
                        // Payout amount card
                        _buildPayoutCard(payoutType, amount, date),
                        const SizedBox(height: 12),
                        // User details card
                        _buildUserCard(userId, userName, amount),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _buildPayoutCard(payoutType, amount, date)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildUserCard(userId, userName, amount)),
                      ],
                    ),

                  const SizedBox(height: 16),
                  const Divider(thickness: 1, color: Colors.black26),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        "$payoutType Details",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  const FilterBar(),
                  const SizedBox(height: 8),

                  // Payout list
                  if (payoutList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No payout data available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (int i = 0; i < payoutList.length; i++)
                          _buildPayoutItem(
                              payoutList[i], i == payoutList.length - 1),
                      ],
                    ),

                  // Close button
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Helper methods for building UI components
  Widget _buildPayoutCard(String payoutType, String amount, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payoutType,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String userId, String userName, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ID: $userId',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Name: $userName',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $userName',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Rs.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        amount.replaceAll('Rs. ', ''),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutItem(CustProductPayoutModel payout, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date: ${payout.date ?? 'N/A'}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Details: ${payout.message ?? 'N/A'}"),
          const SizedBox(height: 4),
          Text("Amount: Rs. ${payout.amount ?? '0.00'}"),
          const SizedBox(height: 4),
          Text("TDS: Rs. ${payout.tds ?? '0.00'}"),
          const SizedBox(height: 4),
          Text("Total Payable: Rs. ${payout.totalPayable ?? '0.00'}"),
          const SizedBox(height: 4),
          Text("Remarks: ${payout.status ?? 'N/A'}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustProductPayoutController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Product Payouts',
              style: Appwidget.poppinsAppBarTitle(),
            ),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            elevation: 0,
          ),
          body: controller.isLoading
              ? _buildLoadingState()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(thickness: 1, color: Colors.black26),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Payouts:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.black26),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              // Phone view
                              return Column(
                                children: [
                                  payoutCard(
                                      "Previous Payout",
                                      controller.prevMonth ?? "",
                                      "Rs. ${controller.previousMonthPayout}/-",
                                      "Paid",
                                      Colors.green.shade100,
                                      controller),
                                  const SizedBox(height: 16),
                                  payoutCard(
                                      "Next Payout",
                                      controller.nextMonth ?? "",
                                      "Rs. ${controller.nextMonthPayout}/-",
                                      "Pending",
                                      Colors.orange.shade100,
                                      controller),
                                ],
                              );
                            } else {
                              // Tablet/Desktop view
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: payoutCard(
                                        "Previous Payout",
                                        controller.prevMonth ?? "",
                                        "Rs. ${controller.previousMonthPayout}/-",
                                        "Paid",
                                        Colors.green.shade100,
                                        controller),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: payoutCard(
                                        "Next Payout",
                                        controller.nextMonth ?? "",
                                        "Rs. ${controller.nextMonthPayout}/-",
                                        "Pending",
                                        Colors.orange.shade100,
                                        controller),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        totalPayoutCard(
                            controller.totalPayout ?? "0.00", controller),
                        const SizedBox(height: 50),
                        Divider(thickness: 1, color: Colors.black26),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "All Payouts:",
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
                            child: controller.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : PaginatedDataTable(
                                    columnSpacing: 50,
                                    dataRowMinHeight: 40,
                                    columns: [
                                      DataColumn(label: Text("Date")),
                                      DataColumn(label: Text("Payout Details")),
                                      DataColumn(label: Text("Total")),
                                      DataColumn(label: Text("TDS")),
                                      DataColumn(label: Text("Total Payable")),
                                      DataColumn(label: Text("Remarks")),
                                    ],
                                    source: CustProductAllPayoutDataSource(
                                        controller.allPayouts),
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
      },
    );
  }

  Widget payoutCard(String title, String date, String amount, String status,
      Color statusColor, CustProductPayoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          Text(date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: statusColor, borderRadius: BorderRadius.circular(4)),
                child: Text(status,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showPayoutDialog(context, title, date, amount,
                    userId!, widget.userName ?? "", controller),
                child: const Text(
                  "View Payout",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Downloading Payout...")),
                ),
                child: const Icon(Icons.download, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalPayoutCard(
      String? totalPayout, CustProductPayoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Payout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text("Rs. $totalPayout/-",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => showPayoutDialog(
                        context,
                        'Total Payout',
                        selectedDate,
                        totalPayout!,
                        userId!,
                        widget.userName ?? "",
                        controller),
                    child: const Text(
                      "View Payout",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Downloading Payout...")),
                    ),
                    child: const Icon(Icons.download, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDate,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
