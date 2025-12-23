import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_controller.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_popular_candidates_data_source.dart';
import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_top_tc_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/customers/franchise_customer.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/cu_membership_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/tc_recruitment_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/franchise_tc.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FranchiseDashboardPage extends StatefulWidget {
  const FranchiseDashboardPage({super.key});

  @override
  State<FranchiseDashboardPage> createState() => _FranchiseDashboardPageState();
}

class _FranchiseDashboardPageState extends State<FranchiseDashboardPage> {
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
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

  Future<void> _loadChartData(String year) async {
    final customerController =
        Provider.of<FranchiseeController>(context, listen: false);
    setState(() {});

    await customerController.apiGetChartData(year);
    final data = customerController.getChartSpots();

    setState(() {
      chartData = data;
      // isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<FranchiseeController>();

      controller.fetchDashboardCounts();
      controller.fetchCandidateCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Franchise Dashboard',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      // ---------------- Side nav starts here ----------------
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 81, 131, 246),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                            builder: (context) =>
                                const FranchiseDashboardPage()),
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
                  // TODO: packages shall be added later
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text('Travel Consultant'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FranchiseTc()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_alt),
                    title: const Text('Customer'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FranchiseCustomer()),
                      );
                    },
                  ),
                  ExpansionTile(
                    title: const Text('Payouts'),
                    leading: const Icon(Icons.payment),
                    children: [
                      drawerItem(
                        context,
                        Icons.account_balance_wallet,
                        'Product Payouts',
                        const ProductPayouts(),
                        padding: true,
                      ),
                      drawerItem(
                        context,
                        Icons.card_membership,
                        'CU Membership Payouts',
                        const CuMembershipPayouts(),
                        padding: true,
                      ),
                      drawerItem(
                        context,
                        Icons.person_add,
                        'TC Recruitment Payouts',
                        const TcRecruitmentPayouts(),
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
                          builder: (context) => const ProfilePage(),
                        ),
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
            )
          ],
        ),
      ),
      // ---------------- Side nav ends here ----------------

      // ---------------- Body starts here ----------------
      body: Consumer<FranchiseeController>(
        builder: (context, controller, _) {
          final isLoading = controller.state == ViewState.loading;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2️⃣ Error
          if (controller.state == ViewState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ToastHelper.showErrorToast(
                    title:
                        controller.failure?.message ?? 'Something went wrong');
              },
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CustomAnimatedSummaryCards(
                  cardData: [
                    SummaryCardData(
                      title: 'TRAVEL CONSULTANT',
                      value: controller.totalTravelConsultants.toString(),
                      thisMonthValue:
                          controller.newCustomersThisMonth.toString(),
                      icon: Icons.people,
                    ),
                    SummaryCardData(
                      title: 'CUSTOMERS',
                      value: controller.totalCustomers.toString(),
                      thisMonthValue:
                          controller.newCustomersThisMonth.toString(),
                      icon: Icons.people,
                    ),
                    SummaryCardData(
                      title: 'Commision Earned',
                      value: controller.confirmedCommission.toString(),
                      thisMonthValue: controller.pendingCommission.toString(),
                      icon: Icons.people,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const ReferralTrackerCard(
                  totalSteps: 10,
                  currentStep: 3,
                  progressColor: Colors.green,
                ),
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
                const Divider(thickness: 1, color: Colors.black26),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Top Travel Consultants',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black26),
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
                      columnSpacing: 85,
                      dataRowMinHeight: 40,
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Date Reg.')),
                        DataColumn(label: Text('Total TC Ref')),
                        DataColumn(label: Text('Active/Inactive')),
                      ],
                      source: FranchiseTopTcDataSource(data: orderstechno),
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: AppData.availableRowsPerPage,
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
                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Colors.black26),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Popular Candidate's List:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black26),
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
                      columnSpacing: 150,
                      dataRowMinHeight: 40,
                      columns: const [
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Pending')),
                        DataColumn(label: Text('Registered')),
                        DataColumn(label: Text('Deleted')),
                      ],
                      source: FranchisePopularCandidatesDataSource(
                        data: controller.candidateCount,
                      ),
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: AppData.availableRowsPerPage,
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
          );
        },
      ),
    );
  }
}
