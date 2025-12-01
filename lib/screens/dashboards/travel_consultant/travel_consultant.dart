import 'package:bizzmirth_app/controllers/tc_controller/tc_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_current_booking_data_source.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_top_customers_data_source.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/customers/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_cu_membership_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/payouts/tc_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/product_markup/travel_consultant_product_markup_page.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/booking_tracker.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
// import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:fl_chart/fl_chart.dart';
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

  // charts data send from dashboard
  String selectedYear = DateTime.now().year.toString();
  List<String> availableYears = [];

  bool hasError = false;
  String? errorMessage;
  List<FlSpot> chartData = [];

  Future<void> _initData() async {
    try {
      // final customerController =
      //     Provider.of<CustomerController>(context, listen: false);

      // load available years
      final regDate = await SharedPrefHelper().getCurrentUserRegDate();
      final years = _generateYearList(regDate);
      setState(() {
        availableYears = years;
        selectedYear = years.last;
      });

      // load chart data
      await _loadChartData(selectedYear);
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadChartData(String year) async {
    final customerController =
        Provider.of<TcController>(context, listen: false);
    setState(() {});

    await customerController.apiGetChartData(year);
    final data = customerController.getChartSpots();

    setState(() {
      chartData = data;
      // isLoading = false;
    });
  }

  List<String> _generateYearList(String? regDate) {
    final currentYear = DateTime.now().year;
    int startYear = currentYear;
    if (regDate != null && regDate.isNotEmpty) {
      final parts = regDate.split('-');
      if (parts.length == 3) {
        startYear =
            parts[0].length == 4 ? int.parse(parts[0]) : int.parse(parts[2]);
      }
    }
    return [for (int y = startYear; y <= currentYear; y++) y.toString()];
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final tcController = Provider.of<TcController>(context);
    if (tcController.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastHelper.showErrorToast(title: tcController.error!);
        tcController.clearError();
      });
    }
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
                      drawerItem(
                        context,
                        Icons.payment,
                        'Product Payouts',
                        const TCProductPayoutsPage(),
                        padding: true,
                      ),
                      drawerItem(
                        context,
                        Icons.inventory_2,
                        'CU Membership Payout',
                        const TcCuMembershipPayouts(),
                        padding: true,
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                    ),
                    title: const Text('Order History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderHistory()),
                      );
                    },
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
                  ImprovedLineChart(
                    chartData: chartData,
                    availableYears: availableYears,
                    selectedYear: selectedYear,
                    // isLoading: isLoading,
                    hasError: hasError,
                    errorMessage: errorMessage,
                    onYearChanged: (year) async {
                      setState(() => selectedYear = year ?? '');
                      await _loadChartData(year ?? '');
                    },
                  ),
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
                                  data: tcController.tcTopCustomerReferrals),
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
                      : _buildTopCustomerList(tcController),

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
                      : _buildCurrentBookingList(tcController),
                ],
              ),
            ),
    );
  }

  Widget _buildTopCustomerList(TcController controller) {
    return ListView.builder(
      itemCount: controller.tcTopCustomerReferrals.length,
      shrinkWrap: true,
      physics: controller.tcTopCustomerReferrals.length > 5
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final topCus = controller.tcTopCustomerReferrals[index];

        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer name
                Text(
                  topCus.name ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),

                // ID
                Text(
                  'ID: ${topCus.id ?? "N/A"}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Registration date
                Text(
                  "Date Reg.: ${topCus.registerDate ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Active / Inactive counts
                Row(
                  children: [
                    const Text(
                      'Active / Inactive: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${topCus.activeCount ?? 0}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: ' / ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '${topCus.inactiveCount ?? 0}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentBookingList(TcController controller) {
    return ListView.builder(
      physics: controller.tcTopBookings.length > 5
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: controller.tcTopBookings.length,
      itemBuilder: (context, index) {
        final booking = controller.tcTopBookings[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.name ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Booking ID: ${booking.orderId}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Customer Name: ${booking.name ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Package Name: ${booking.packageName}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Amount: ${booking.amount ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Travel Date: ${booking.travelDate ?? "N/A"}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
