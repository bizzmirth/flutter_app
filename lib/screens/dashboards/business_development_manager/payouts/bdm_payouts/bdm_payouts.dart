import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BDMPayoutsPage extends StatefulWidget {
  const BDMPayoutsPage({super.key});

  @override
  State<BDMPayoutsPage> createState() => _BDMPayoutsPageState();
}

class _BDMPayoutsPageState extends State<BDMPayoutsPage> {
  String selectedDate = "Select month, year";
  int _rowsPerPage = 5; // Default rows per page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'T.E Recruitment Payouts',
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
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("TDS")),
                        DataColumn(label: Text("Total Payable")),
                        DataColumn(label: Text("Remarks")),
                      ],
                      source:
                          MyBMProductionPayoutDataSource(bMrecruitmentpayout),
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
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("View Payout Clicked!")),
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
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("View Payout Clicked!")),
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
