import 'package:bizzmirth_app/screens/dashboards/franchise/customers/franchise_customer.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/cu_membership_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/payouts/tc_recruitment_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/franchise/travel_consultant/franchise_tc.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FranchiseDashboardPage extends StatefulWidget {
  const FranchiseDashboardPage({super.key});

  @override
  State<FranchiseDashboardPage> createState() => _FranchiseDashboardPageState();
}

class _FranchiseDashboardPageState extends State<FranchiseDashboardPage> {
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
                            builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
