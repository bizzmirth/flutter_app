import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/payouts/bm_payouts/bm_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/payouts/product_payouts/bm_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/techno_enterprise/techno_enterprise.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/travel_consultant/travel_consultant.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BMDashboardPage extends StatefulWidget {
  const BMDashboardPage({super.key});

  @override
  State<BMDashboardPage> createState() => _BMDashboardPageState();
}

class _BMDashboardPageState extends State<BMDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Mentor Dashboard',
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
                      'Welcome, Business Mentor!',
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
                            builder: (context) => const BMDashboardPage()),
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
                  ExpansionTile(
                    title: const Text('Payouts'),
                    leading: const Icon(Icons.payment),
                    children: [
                      _drawerItem(context, Icons.payment, 'Product Payout',
                          const BMProductPayoutsPage(),
                          padding: true),
                      _drawerItem(context, Icons.payment, 'BM Payouts',
                          const BMPayoutsPage(),
                          padding: true),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Techno Enterprise'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewTEPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Travel Consultant'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewTCPage()),
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
                            builder: (context) => const ViewCustomersPage1()),
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
                      onTap: () {
                        SharedPrefHelper().removeDetails();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            CustomAnimatedSummaryCards(
              cardData: [
                SummaryCardData(
                    title: 'TECHNO ENTERPRISE REGISTERED',
                    value: '3',
                    icon: Icons.people),
                SummaryCardData(
                    title: 'TRAVEL AGENCY REGISTERED',
                    value: '9',
                    icon: Icons.calendar_today),
                SummaryCardData(
                    title: 'MY WALLET',
                    value: '₹ 2000',
                    icon: Icons.account_balance_wallet),
              ],
            ),
            const SizedBox(height: 20),
            const ProgressTrackerCard(
              totalSteps: 10,
              currentStep: 3,
              message: "Keep going! You're doing great!",
            ),
            const SizedBox(height: 20),
            const ImprovedLineChart(),
            const SizedBox(height: 20),
            _buildTopPerformersSection(),
            const SizedBox(height: 20),
            _buildTopPerformersSection1(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformersSection() {
    final List<Map<String, dynamic>> departments = [
      {'name': 'Travel Agencie', 'performers': _getDummyPerformers1()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 13,
            childAspectRatio: 1.65,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final dept = departments[index];
            return _buildDepartmentCard(dept['name'], dept['performers']);
          },
        ),
      ],
    );
  }

  Widget _buildTopPerformersSection1() {
    final List<Map<String, dynamic>> departments = [
      {'name': 'Booking', 'performers': _getDummyPerformers2()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 13,
            childAspectRatio: 1.7,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final dept = departments[index];
            return _buildDepartmentCard1(dept['name'], dept['performers']);
          },
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(
      String department, List<Map<String, String>> performers) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Top $department's",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  ' Ranks',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  ' Profile Picture',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 25,
                ),
                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Registration Date',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Text(
                  'Count',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                TextButton.icon(
                  onPressed: null, // 🔒 Button is disabled
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  label: const Text('Status',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Active/Inactive',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (context, rank) {
                  return Row(
                    children: [
                      Image.asset(
                        'assets/${rank + 1}.jpg', // Rank Image
                        width: 53,
                        height: 53,
                      ),
                      const SizedBox(width: 40),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(performers[rank]['image']!),
                      ),
                      const SizedBox(width: 55),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                                120, // Set a fixed width to keep all names aligned
                            child: Text(
                              performers[rank]['name']!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow
                                  .ellipsis, // Ensures long names don't break layout
                              maxLines: 1, // Keeps text on a single line
                            ),
                          ),
                          const Text(
                            'id3445345',
                            style: TextStyle(color: Color(0xFF495057)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width:
                            85, // Adjust width as needed for better alignment
                        child: Text(
                          performers[rank]['date']!,
                          textAlign: TextAlign.center, // Center align text
                        ),
                      ),
                      const SizedBox(width: 35),
                      const Spacer(),
                      Center(
                        child: Text(performers[rank]['count']!,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 55),
                      const Text(
                        'Active',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(width: 40),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // First Box (Green Background)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(
                                  alpha: 0.1), // Light green background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(
                                color: Colors.green, // Green text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 5), // Space between boxes

                          const Text('/',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)), // Separator

                          const SizedBox(width: 5), // Space between boxes

                          // Second Box (Red Background)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(
                                  alpha: 0.1), // Light red background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(
                                color: Colors.red, // Red text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildDepartmentCard1(
      String department, List<Map<String, String>> performers) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Current $department's",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                )
              ],
            ),
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  ' Booking ID',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  ' Customer Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 55,
                ),
                Text(
                  'Package Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Amount',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Booking Date',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Travel Date',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (context, rank) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(performers[rank]['bookingid']!),
                      const SizedBox(
                        width: 45,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                                120, // Set a fixed width to keep all names aligned
                            child: Text(
                              performers[rank]['name']!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow
                                  .ellipsis, // Ensures long names don't break layout
                              maxLines: 1, // Keeps text on a single line
                            ),
                          ),
                          Text(
                            performers[rank]['custid']!,
                            style: const TextStyle(color: Color(0xFF495057)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        performers[rank]['pname']!,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        "₹${performers[rank]["amt"]!}",
                      ),
                      const SizedBox(
                        width: 36,
                      ),
                      Text(
                        performers[rank]['bdate']!,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        performers[rank]['tdate']!,
                      ),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  null;
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // White text
                  backgroundColor: const Color.fromARGB(
                      255, 81, 131, 246), // Same blue as header
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5, // Slight shadow for better UI feel
                ),
                child: const Text('View More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Welcome, User!',
      style: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        letterSpacing: 0.2,
      ),
    );
  }
}

List<Map<String, String>> _getDummyPerformers1() {
  return [
    {
      'name': 'John Doe',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'count': '30',
      'date': '26/06/2024'
    },
    {
      'name': 'Jane Smith',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
      'count': '30',
      'date': '26/06/2024'
    },
    {
      'name': 'Alice Brown',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'count': '30',
      'date': '26/06/2024'
    },
    {
      'name': 'Bob White',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
      'count': '30',
      'date': '26/06/2024'
    },
    {
      'name': 'Charlie Black',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'count': '30',
      'date': '26/06/2024'
    },
  ];
}

List<Map<String, String>> _getDummyPerformers2() {
  return [
    {
      'bookingid': 'bid2344234',
      'name': 'John Doe',
      'custid': 'cid234',
      'pname': 'John Doe',
      'amt': '3000',
      'bdate': '26/06/2024',
      'tdate': '26/06/2024'
    },
    {
      'bookingid': 'bid2344234',
      'name': 'John Doe',
      'custid': 'cid234',
      'pname': 'John Doe',
      'amt': '3000',
      'bdate': '26/06/2024',
      'tdate': '26/06/2024'
    },
    {
      'bookingid': 'bid2344234',
      'name': 'John Doe',
      'custid': 'cid234',
      'pname': 'John Doe',
      'amt': '3000',
      'bdate': '26/06/2024',
      'tdate': '26/06/2024'
    },
    {
      'bookingid': 'bid2344234',
      'name': 'John Doe',
      'custid': 'cid234',
      'pname': 'John Doe',
      'amt': '3000',
      'bdate': '26/06/2024',
      'tdate': '26/06/2024'
    },
    {
      'bookingid': 'bid2344234',
      'name': 'John Doe',
      'custid': 'cid234',
      'pname': 'John Doe',
      'amt': '3000',
      'bdate': '26/06/2024',
      'tdate': '26/06/2024'
    },
  ];
}
