import 'package:bizzmirth_app/data_source/cust_product_payout_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustProductPayoutsPage extends StatefulWidget {
  const CustProductPayoutsPage({super.key});

  @override
  State<CustProductPayoutsPage> createState() => _CustProductPayoutsPageState();
}

class _CustProductPayoutsPageState extends State<CustProductPayoutsPage> {
  String selectedDate = "Select month, year";
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

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

  void showPayoutDialog(BuildContext context, String payoutType, String date,
      String amount, String userId, String userName) {
    final payoutDataSource = PayoutDataSource();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('Show '),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton<int>(
                                  value: 10,
                                  underline: const SizedBox(),
                                  items: [5, 10, 15, 20, 25]
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.toString()),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    // Handle rows per page change
                                  },
                                ),
                              ),
                              const Text(' entries'),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Search: '),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Paginated Data Table
                      Expanded(
                          child: payoutDataSource.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "No data available in table",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: PaginatedDataTable(
                                      header: null,
                                      rowsPerPage: 10,
                                      availableRowsPerPage: const [
                                        5,
                                        10,
                                        15,
                                        20,
                                        25
                                      ],
                                      onRowsPerPageChanged: (value) {
                                        // Handle rows per page change
                                      },
                                      columns: const [
                                        DataColumn(label: Text('Date')),
                                        DataColumn(
                                            label: Text('Payout Details')),
                                        DataColumn(label: Text('Amount')),
                                        DataColumn(label: Text('TDS')),
                                        DataColumn(
                                            label: Text('Total Payable')),
                                        DataColumn(label: Text('Remark')),
                                      ],
                                      source: payoutDataSource),
                                ))
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Product Payouts',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1, color: Colors.black26),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Payouts:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(thickness: 1, color: Colors.black26),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: payoutCard("Previous Payout", "January, 2025",
                            "Rs. 0/-", "Paid", Colors.green.shade100)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: payoutCard("Next Payout", "February, 2025",
                            "Rs. 0/-", "Pending", Colors.orange.shade100)),
                  ],
                ),
                const SizedBox(height: 16),
                totalPayoutCard(),
                const SizedBox(height: 50),
                Divider(thickness: 1, color: Colors.black26),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "All Payouts:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(thickness: 1, color: Colors.black26),
                FilterBar2(),
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
                        DataColumn(label: Text("Total Payable")),
                        DataColumn(label: Text("Remarks")),
                      ],
                      source:
                          MyTEProductionPayoutDataSource(TErecruitmentpayout),
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
        ));
  }

  Widget payoutCard(String title, String date, String amount, String status,
      Color statusColor) {
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
                onTap: () => showPayoutDialog(
                  context,
                  title,
                  date,
                  amount,
                  'CU240001', // Replace with actual user ID
                  'Harbhajan Naik', // Replace with actual user name
                ),
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

  Widget totalPayoutCard() {
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
              const Text("Rs. 0/-",
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
                      'Rs. 0/-',
                      'CU240001', // Replace with actual user ID
                      'Harbhajan Naik', // Replace with actual user name
                    ),
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
