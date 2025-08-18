import 'dart:async';

import 'package:bizzmirth_app/controllers/cust_wallet_controller.dart';
import 'package:bizzmirth_app/data_source/cust_booking_points_data_source.dart';
import 'package:bizzmirth_app/data_source/cust_redeemable_table_data_source.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletDetailsPage extends StatefulWidget {
  const WalletDetailsPage({super.key});

  @override
  _WalletDetailsPageState createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends State<WalletDetailsPage> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  int _currentColorIndex = 0;
  Timer? _timer;
  int _rowsPerPage = 5;

  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  String? _customerType;

  @override
  void initState() {
    super.initState();
    getCustomerWalletDetails();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  void getCustomerWalletDetails() async {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);
    _customerType = await SharedPrefHelper().getCurrentUserCustId();
    controller.apiGetWalletDetails();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustWalletController>(
        builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'My Wallet',
            style: Appwidget.poppinsAppBarTitle(),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, color: Colors.black26),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Wallet Options",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.black26),

                      SizedBox(height: 16),

                      // Wallet Options
                      Row(
                        children: [
                          if (_customerType == 'Prime' &&
                              _customerType == 'Premium')
                            Expanded(
                              child: _buildWalletOptionCard(
                                title: 'Redeemable Count',
                                amount: controller.referenceCountTotal ?? "",
                                thisMonthAmount:
                                    controller.referenceCountThisMonth ?? "",
                                icon: Icons.person_outline,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopUpWalletPage(
                                              title: "Top Up Wallet",
                                            )),
                                  );
                                },
                                isClickable: false,
                              ),
                            )
                          else ...[
                            Expanded(
                              child: _buildWalletOptionCard(
                                title: 'Redeemable Count',
                                amount: controller.referenceCountTotal ?? "",
                                thisMonthAmount:
                                    controller.referenceCountThisMonth ?? "",
                                icon: Icons.person_outline,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopUpWalletPage(
                                              title: "Top Up Wallet",
                                            )),
                                  );
                                },
                                isClickable: false,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildWalletOptionCard(
                                title: 'Bookings\nWALLET',
                                amount:
                                    controller.bookingPointsCountTotal ?? "",
                                icon: Icons.people_outline,
                                thisMonthAmount:
                                    controller.bookingPointsCountThisMonth ??
                                        "",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TopUpWalletPage(
                                              title: "Referral Wallet",
                                            )),
                                  );
                                },
                                isClickable: false,
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 20),
                      if (_customerType == 'Prime' &&
                          _customerType == 'Premium')
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Divider(thickness: 1, color: Colors.black26),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Redeemable Wallet History",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.black26),
                              FilterBar(
                                userCount: controller
                                    .custRedeemableWalletHistory.length
                                    .toString(),
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
                                    columns: [
                                      DataColumn(label: Text("SR No.")),
                                      DataColumn(label: Text("Payout Message")),
                                      DataColumn(label: Text("Payout Amount")),
                                      DataColumn(label: Text("Earned ON")),
                                      DataColumn(label: Text("Status")),
                                    ],
                                    source: CustRedeemableTableDataSource(
                                        controller.custRedeemableWalletHistory),
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
                              )
                            ],
                          ),
                        )
                      else ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Divider(thickness: 1, color: Colors.black26),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Redeemable Wallet History",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.black26),
                              FilterBar(
                                userCount: controller
                                    .custRedeemableWalletHistory.length
                                    .toString(),
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
                                    columns: [
                                      DataColumn(label: Text("SR No.")),
                                      DataColumn(label: Text("Payout Message")),
                                      DataColumn(label: Text("Payout Amount")),
                                      DataColumn(label: Text("Earned ON")),
                                      DataColumn(label: Text("Status")),
                                    ],
                                    source: CustRedeemableTableDataSource(
                                        controller.custRedeemableWalletHistory),
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
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Divider(thickness: 1, color: Colors.black26),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Booking Points Wallet History",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.black26),
                              FilterBar(
                                userCount: controller
                                    .custBookingWalletHistory.length
                                    .toString(),
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
                                    columns: [
                                      DataColumn(label: Text("SR No.")),
                                      DataColumn(label: Text("Points Message")),
                                      DataColumn(label: Text("Points Value")),
                                      DataColumn(label: Text("Added On")),
                                      DataColumn(label: Text("Status")),
                                    ],
                                    source: CustBookingPointsDataSource(
                                        controller.custBookingWalletHistory),
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
                              )
                            ],
                          ),
                        ),
                      ]

                      // Quick Actions
                      // Container(
                      //   width: double.infinity,
                      //   padding: EdgeInsets.all(20),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.05),
                      //         blurRadius: 8,
                      //         offset: Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Quick Actions',
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey[800],
                      //         ),
                      //       ),
                      //       SizedBox(height: 16),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           _buildQuickActionButton(
                      //             icon: Icons.add,
                      //             label: 'Add Money',
                      //             onTap: () {},
                      //           ),
                      //           _buildQuickActionButton(
                      //             icon: Icons.send,
                      //             label: 'Transfer',
                      //             onTap: () {},
                      //           ),
                      //           _buildQuickActionButton(
                      //             icon: Icons.history,
                      //             label: 'History',
                      //             onTap: () {},
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget _buildWalletOptionCard({
    required String title,
    required String amount,
    required IconData icon,
    required VoidCallback onTap,
    required String thisMonthAmount,
    bool isClickable = true,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colors[_currentColorIndex].withOpacity(0.8),
              colors[(_currentColorIndex + 1) % colors.length].withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row - Title and clickable arrow
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  Spacer(),
                  if (isClickable)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                ],
              ),
              SizedBox(height: 12),
              // Second row - Icon and main amount
              Row(
                children: [
                  Icon(icon, size: 28, color: Colors.white),
                  Spacer(),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Third row - "This Month" text and amount
              Row(
                children: [
                  Text(
                    "This Month",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Spacer(),
                  Text(
                    thisMonthAmount,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildQuickActionButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: colors[_currentColorIndex].withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(
  //             icon,
  //             size: 24,
  //             color: colors[_currentColorIndex],
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
