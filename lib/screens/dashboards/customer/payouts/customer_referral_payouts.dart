import 'package:bizzmirth_app/controllers/cust_referral_payout_controller.dart';
import 'package:bizzmirth_app/data_source/cust_all_payout_data_source.dart';
import 'package:bizzmirth_app/models/cust_referral_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerReferralPayouts extends StatefulWidget {
  final String? username;
  const CustomerReferralPayouts({super.key, this.username});

  @override
  State<CustomerReferralPayouts> createState() =>
      _CustomerReferralPayoutsState();
}

class _CustomerReferralPayoutsState extends State<CustomerReferralPayouts> {
  String selectedDate = "Select month, year";
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  String? userId;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllStatData();
    });
  }

  void getAllStatData() async {
    final controller =
        Provider.of<CustReferralPayoutController>(context, listen: false);
    userId = await SharedPrefHelper().getCurrentUserCustId();
    controller.getAllPayouts(userId);
    controller.apiGetPreviousMonthPayouts();
    controller.apiGetNextMonthPayouts();
    controller.apiGetTotalPayouts();
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
      CustReferralPayoutController controller) {
    List<CustReferralPayoutModel> getPayoutList() {
      switch (payoutType.toLowerCase()) {
        case 'previous payouts':
        case 'previous payout':
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
          // Default to total payouts if type doesn't match
          return controller.totalAllPayouts;
      }
    }

    // final payoutDataSource = PayoutDataSource(referralPayout);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        payoutType,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 20),

                  // Payout summary cards
                  Row(
                    children: [
                      // Left card - Payout amount
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
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
                                  Text(
                                    amount,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Right card - User details
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'ID: $userId',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Name: $userName',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: $userName',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Rs.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          amount.replaceAll('Rs. ', ''),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Table section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show entries and search

                        // Paginated Data Table
                        Divider(thickness: 1, color: Colors.black26),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              payoutType,
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
                            child: PaginatedDataTable(
                              columnSpacing: 50,
                              dataRowMinHeight: 40,
                              columns: [
                                DataColumn(label: Text("Date")),
                                DataColumn(label: Text("Payout Details")),
                                DataColumn(label: Text("Amount")),
                                DataColumn(label: Text("TDS")),
                                DataColumn(label: Text("Total Payable")),
                                DataColumn(label: Text("Remarks")),
                              ],
                              source: CustReferenceAllPayoutDataSource(
                                  getPayoutList()),
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
                          vertical: 12,
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
              'Loading Referral Payouts...',
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CustReferralPayoutController>(
      builder: (context, controller, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          Logger.info(
              "Screen dimensions - Width: $screenWidth, Height: $screenHeight");
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Referral Payouts',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: payoutCard(
                                    "Previous Payout",
                                    "${getMonthName(controller.prevMonth)}, ${controller.year}",
                                    "Rs. ${controller.previousMonthPayout}/-",
                                    "Paid",
                                    Colors.green.shade100,
                                    controller)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: payoutCard(
                                    "Next Payout",
                                    "${getMonthName(controller.nextMonth)}, ${controller.year}",
                                    "Rs. ${controller.nextMonthPayout}/-",
                                    "Pending",
                                    Colors.orange.shade100,
                                    controller)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        totalPayoutCard(controller.totalPayout, controller),
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
                        FilterBar(
                          userCount: controller.allPayouts.length.toString(),
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
                              columnSpacing: 50,
                              dataRowMinHeight: 40,
                              columns: [
                                DataColumn(label: Text("Date")),
                                DataColumn(label: Text("Payout Details")),
                                DataColumn(label: Text("Product Payout")),
                                DataColumn(label: Text("Total")),
                                DataColumn(label: Text("TDS")),
                                DataColumn(label: Text("Remarks")),
                              ],
                              source: CustReferenceAllPayoutDataSource(
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
      Color statusColor, CustReferralPayoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showPayoutDialog(context, title, date, amount,
                    userId!, widget.username ?? "", controller),
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
      String? totalPayout, CustReferralPayoutController controller) {
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => showPayoutDialog(
                        context,
                        'Total Payout',
                        selectedDate,
                        'Rs. $totalPayout/-',
                        userId!,
                        widget.username ?? "",
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
