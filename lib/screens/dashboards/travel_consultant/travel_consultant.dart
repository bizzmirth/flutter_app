import 'package:bizzmirth_app/controllers/tc_controller/tc_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_current_booking_data_source.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_top_customers_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/customers/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_cu_membership_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/product_markup/travel_consultant_product_markup_page.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/widgets/booking_tracker.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    final tcController = Provider.of<TcController>(context);
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
              color: const Color.fromARGB(255, 81, 131, 246),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/user_image.jpg'),
                      radius: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, Travel Consultant!',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Manage everything efficiently',
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
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TCDashboardPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Markup'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductMarkupPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Customer'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewTcCustomers()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.wallet),
                    title: const Text('TopUp Wallet'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TopUpWalletPage(
                                  title: 'Top Up Wallet',
                                )),
                      );
                    },
                  ),
                  //ProductPayoutsPage
                  ExpansionTile(
                    title: const Text('Payouts'),
                    leading: const Icon(Icons.payment),
                    children: [
                      _drawerItem(context, Icons.payment, 'Product Payouts',
                          const TCProductPayoutsPage(),
                          padding: true),
                      _drawerItem(context, Icons.inventory_2,
                          'CU Membership Payout', const TcCuMembershipPayouts(),
                          padding: true),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                    ),
                    title: const Text('Profile Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
                      );
                    },
                  ),

                  const Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.red,
                      ),
                      title: const Text('Log Out'),
                      onTap: () async {
                        await performLogout(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: tcController.isLoading // Add loading check
          ? const Center(child: CircularProgressIndicator())
          : tcController.error != null // Add error check
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tcController.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: tcController.getDashboardDataCounts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildHeader(),
                      const SizedBox(height: 20),
                      CustomAnimatedSummaryCards(
                        cardData: [
                          // SummaryCardData(
                          //     title: 'CUSTOMER REGISTERED',
                          //     value: tcController.totalRegisteredCustomers ?? '0',
                          //     thisMonthValue: tcController.monthlyRegisteredCustomers ?? '0',
                          //     icon: Icons.people),
                          // SummaryCardData(
                          //     title: 'TOTAL BOOKING',
                          //     value: '9',
                          //     thisMonthValue: '0',
                          //     icon: Icons.calendar_today),
                          // SummaryCardData(
                          //     title: 'Topup Wallet',
                          //     value: '₹ 2000',
                          //     thisMonthValue: '₹ 100',
                          //     icon: Icons.account_balance_wallet),
                          // SummaryCardData(
                          //   title: 'COMPLETED TOURS',
                          //   value: tcController.totalCompletedTours ?? '0',
                          //   thisMonthValue:
                          //       tcController.monthlyCompletedTours ?? '0',
                          //   icon: Icons.check_circle,
                          // ),
                          // SummaryCardData(
                          //   title: 'UPCOMING TOURS',
                          //   value: tcController.totalUpcomingTours ?? '0',
                          //   thisMonthValue:
                          //       tcController.monthlyUpcomingTours ?? '0',
                          //   icon: Icons.calendar_today,
                          // ),
                          // SummaryCardData(
                          //   title: 'CONFIRMED COMMISSION',
                          //   value:
                          //       '₹ ${tcController.confirmedCommission ?? '0.00'}',
                          //   thisMonthValue:
                          //       '₹ ${tcController.pendingCommission ?? '0.00'}',
                          //   icon: Icons.account_balance_wallet,
                          // ),
                          SummaryCardData(
                            title: 'CUSTOMER REGISTERED',
                            value: tcController.totalRegisteredCustomers ?? '0',
                            thisMonthValue:
                                tcController.monthlyRegisteredCustomers ?? '0',
                            icon: Icons.people,
                          ),
                          SummaryCardData(
                            title: 'COMPLETED TOURS',
                            value: tcController.totalCompletedTours ?? '0',
                            thisMonthValue:
                                tcController.monthlyCompletedTours ?? '0',
                            icon: Icons.check_circle,
                          ),
                          SummaryCardData(
                            title: 'UPCOMING TOURS',
                            value: tcController.totalUpcomingTours ?? '0',
                            thisMonthValue:
                                tcController.monthlyUpcomingTours ?? '0',
                            icon: Icons.calendar_today,
                          ),
                          SummaryCardData(
                            title: 'CONFIRMED COMMISSION',
                            value:
                                '₹ ${tcController.confirmedCommission ?? '0.00'}',
                            thisMonthValue:
                                '₹ ${tcController.pendingCommission ?? '0.00'}',
                            icon: Icons.account_balance_wallet,
                          ),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // ProgressTrackerCard(
                      //   totalSteps: 10,
                      //   currentStep: 3,
                      //   message: "Keep going! You're doing great!",
                      //   progressColor: Colors.orange,
                      // ),
                      const SizedBox(height: 20),
                      ReferralTrackerCard(
                        totalSteps: 10,
                        currentStep: int.tryParse(
                                tcController.totalRegisteredCustomers ?? '0') ??
                            0,
                        progressColor: Colors.green,
                      ),

                      const SizedBox(height: 20),
                      // const ReferralTrackerCard(
                      //   totalSteps: 10,
                      //   currentStep: 6,
                      //   progressColor: Colors.purpleAccent,
                      // ),
                      BookingTrackerCard(
                          title: 'Booking tracker',
                          bookingCount: int.tryParse(
                                  tcController.totalCompletedTours ?? '0') ??
                              0),
                      const SizedBox(height: 20),
                      const ImprovedLineChart(),
                      const SizedBox(height: 20),
                      // _buildTopPerformersSection(),
                      const Divider(thickness: 1, color: Colors.black26),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Top Customer's List:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1, color: Colors.black26),
                      // const FilterBar(),
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
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Full Name')),
                                    DataColumn(label: Text('Date Reg.')),
                                    DataColumn(label: Text('Total CU Ref')),
                                    DataColumn(label: Text('Active/Inactive')),
                                  ],
                                  source: TcTopCustomersDataSource(
                                      data:
                                          tcController.tcTopCustomerReferrals),
                                  rowsPerPage: _rowsPerPage,
                                  availableRowsPerPage:
                                      AppData.availableRowsPerPage,
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

                      const SizedBox(height: 20),
                      // _buildTopPerformersSection1(),
                      const Divider(thickness: 1, color: Colors.black26),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Current Booking's:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1, color: Colors.black26),
                      // const FilterBar(),
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
                                  columns: const [
                                    DataColumn(label: Text('Booking ID')),
                                    DataColumn(label: Text('Customer Name')),
                                    DataColumn(label: Text('Package Name')),
                                    DataColumn(label: Text('Amount')),
                                    DataColumn(label: Text('Booking Date')),
                                    DataColumn(label: Text('Travel Date')),
                                  ],
                                  source: TcCurrentBookingDataSource(
                                    data: tcController.tcTopBookings,
                                  ),
                                  rowsPerPage: _rowsPerPage,
                                  availableRowsPerPage:
                                      AppData.availableRowsPerPage,
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
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final topCus = customersTA[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topCus['name'] ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${topCus['id']}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Date Reg.: ${topCus['dateReg'] ?? "N/A"}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total CU Ref: ${topCus['totalCURef'].toString()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Status: '),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(topCus['status'])
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: getStatusColor(topCus['status'])
                                .withValues(alpha: 0.3),
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
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: tcCurrentBookingDummyData.length,
      itemBuilder: (context, index) {
        final booking = tcCurrentBookingDummyData[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customerName'] ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: ${booking['bookingId']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ref. ID: ${booking['packageName'] ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ref. Name: ${booking['amount'].toString()}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Joining Date: ${booking['bookingDate'] ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Travel Date: ${booking['travelDate'] ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
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
