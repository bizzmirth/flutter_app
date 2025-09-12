import 'package:bizzmirth_app/data_source/tc_data_sources/tc_current_booking_data_source.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_top_customers_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/customers/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_cu_membership_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/product_markup/travel_consultant_product_markup_page.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TCDashboardPage extends StatefulWidget {
  const TCDashboardPage({super.key});

  @override
  State<TCDashboardPage> createState() => _TCDashboardPageState();
}

class _TCDashboardPageState extends State<TCDashboardPage> {
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  final List<Map<String, dynamic>> tcCurrentBookingDummyData = [
    {
      'bookingId': 'BKG001',
      'customerName': 'John Doe',
      'packageName': 'Beach Holiday',
      'amount': 1200.50,
      'bookingDate': '2025-09-01',
      'travelDate': '2025-09-15',
    },
    {
      'bookingId': 'BKG002',
      'customerName': 'Jane Smith',
      'packageName': 'Mountain Trek',
      'amount': 850.00,
      'bookingDate': '2025-09-03',
      'travelDate': '2025-10-01',
    },
    {
      'bookingId': 'BKG003',
      'customerName': 'Michael Johnson',
      'packageName': 'City Tour',
      'amount': 500.75,
      'bookingDate': '2025-09-05',
      'travelDate': '2025-09-20',
    },
    {
      'bookingId': 'BKG004',
      'customerName': 'Emily Davis',
      'packageName': 'Safari Adventure',
      'amount': 2300.00,
      'bookingDate': '2025-09-07',
      'travelDate': '2025-11-05',
    },
    {
      'bookingId': 'BKG005',
      'customerName': 'Robert Wilson',
      'packageName': 'Cruise Trip',
      'amount': 1500.25,
      'bookingDate': '2025-09-09',
      'travelDate': '2025-10-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Consultant Dashboard',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color.fromARGB(255, 81, 131, 246),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/user_image.jpg'),
                      radius: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome, Travel Consultant!",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Manage everything efficiently",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TCDashboardPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Markup'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductMarkupPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Customer'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCustomersPage1()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.wallet),
                    title: Text('TopUp Wallet'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpWalletPage(
                                  title: "Top Up Wallet",
                                )),
                      );
                    },
                  ),
                  //ProductPayoutsPage
                  ExpansionTile(
                    title: const Text("Payouts"),
                    leading: const Icon(Icons.payment),
                    children: [
                      _drawerItem(context, Icons.payment, "Product Payouts",
                          TCProductPayoutsPage(),
                          padding: true),
                      _drawerItem(context, Icons.inventory_2,
                          "CU Membership Payout", TcCuMembershipPayouts(),
                          padding: true),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                    ),
                    title: Text("Profile Page"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),

                  const Divider(),
                  Padding(
                    padding: false
                        // ignore: dead_code
                        ? const EdgeInsets.only(left: 16.0)
                        : EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.red,
                      ),
                      title: Text("Log Out"),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildHeader(),
            SizedBox(height: 20),
            CustomAnimatedSummaryCards(
              cardData: [
                SummaryCardData(
                    title: 'CUSTOMER REGISTERED',
                    value: '3',
                    thisMonthValue: "0",
                    icon: Icons.people),
                SummaryCardData(
                    title: 'TOTAL BOOKING',
                    value: '9',
                    thisMonthValue: "0",
                    icon: Icons.calendar_today),
                SummaryCardData(
                    title: 'Topup Wallet',
                    value: '₹ 2000',
                    thisMonthValue: '₹ 100',
                    icon: Icons.account_balance_wallet),
              ],
            ),
            // SizedBox(height: 20),
            // ProgressTrackerCard(
            //   totalSteps: 10,
            //   currentStep: 3,
            //   message: "Keep going! You're doing great!",
            //   progressColor: Colors.orange,
            // ),
            SizedBox(height: 20),
            ReferralTrackerCard(
              totalSteps: 10,
              currentStep: 3,
              progressColor: Colors.green,
            ),
            // SizedBox(height: 20),
            // ReferralTrackerCard(
            //   totalSteps: 10,
            //   currentStep: 6,
            //   progressColor: Colors.purpleAccent,
            // ),
            SizedBox(height: 20),
            ImprovedLineChart(),
            SizedBox(height: 20),
            // _buildTopPerformersSection(),
            Divider(thickness: 1, color: Colors.black26),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Top Customer's List:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.black26),
            FilterBar(),
            isTablet
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: (_rowsPerPage * dataRowHeight) +
                          headerHeight +
                          paginationHeight,
                      child: PaginatedDataTable(
                        columnSpacing: 60,
                        dataRowMinHeight: 40,
                        columns: [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Full Name")),
                          DataColumn(label: Text("Date Reg.")),
                          DataColumn(label: Text("Total CU Ref")),
                          DataColumn(label: Text("Active/Inactive")),
                        ],
                        source: TcTopCustomersDataSource(data: customersTA),
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
                : _buildTopCustomerList(),

            SizedBox(height: 20),
            // _buildTopPerformersSection1(),
            Divider(thickness: 1, color: Colors.black26),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Current Booking's:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.black26),
            FilterBar(),
            isTablet
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: (_rowsPerPage * dataRowHeight) +
                          headerHeight +
                          paginationHeight,
                      child: PaginatedDataTable(
                        columnSpacing: 60,
                        dataRowMinHeight: 40,
                        columns: [
                          DataColumn(label: Text("Booking ID")),
                          DataColumn(label: Text("Customer Name")),
                          DataColumn(label: Text("Package Name")),
                          DataColumn(label: Text("Amount")),
                          DataColumn(label: Text("Booking Date")),
                          DataColumn(label: Text("Travel Date")),
                        ],
                        source: TcCurrentBookingDataSource(
                          data: tcCurrentBookingDummyData,
                        ),
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
                : _buildCurrentBookingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCustomerList() {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Active':
          return Colors.green;
        case 'Inactive':
          return Colors.red;
        default:
          return Colors.orange.shade800;
      }
    }

    return ListView.builder(
        itemCount: customersTA.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final topCus = customersTA[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topCus['name'] ?? "N/A",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "ID: ${topCus['id']}",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Date Reg.: ${topCus['dateReg'] ?? "N/A"}",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Total CU Ref: ${topCus['totalCURef'].toString()}",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Status: "),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(topCus['status'])
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: getStatusColor(topCus['status'])
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          topCus['status'],
                          style: TextStyle(
                            color: getStatusColor(topCus['status']),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildCurrentBookingList() {
    return ListView.builder(
      physics: tcCurrentBookingDummyData.length > 5
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: tcCurrentBookingDummyData.length,
      itemBuilder: (context, index) {
        final booking = tcCurrentBookingDummyData[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customerName'] ?? "N/A",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "ID: ${booking['bookingId']}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "Ref. ID: ${booking['packageName'] ?? "N/A"}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Ref. Name: ${booking['amount'].toString()}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "Joining Date: ${booking['bookingDate'] ?? "N/A"}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "Travel Date: ${booking['travelDate'] ?? "N/A"}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String text, Widget page,
      {bool padding = false}) {
    return Padding(
      padding: padding ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
