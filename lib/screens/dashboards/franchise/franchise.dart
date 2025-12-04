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
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    leading: const Icon(Icons.home),
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
                    leading: const Icon(Icons.home),
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
                        Icons.account_balance_wallet,
                        'CU Membership Payouts',
                        const CuMembershipPayouts(),
                        padding: true,
                      ),
                      drawerItem(
                        context,
                        Icons.account_balance_wallet,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomAnimatedSummaryCards(
              cardData: [
                SummaryCardData(
                  title: 'TRAVEL CONSULTANT',
                  value: '0',
                  thisMonthValue: '0',
                  icon: Icons.people,
                ),
                SummaryCardData(
                  title: 'CUSTOMERS',
                  value: '0',
                  thisMonthValue: '0',
                  icon: Icons.people,
                ),
                SummaryCardData(
                  title: 'COMMISSION EARNED',
                  value: '0',
                  thisMonthValue: '0',
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
            // ImprovedLineChart() TODO: Chart to be added later
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.black26),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Top Travel Consultants',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  columnSpacing: 60,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  columns: const [
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Pending')),
                    DataColumn(label: Text('Registered')),
                    DataColumn(label: Text('Deleted')),
                  ],
                  source: FranchisePopularCandidatesDataSource(
                    data: orderstechno,
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
      ),
    );
  }
}
