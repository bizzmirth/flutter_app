import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/business_mentor/business_mentor.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/payouts/bdm_payouts/bdm_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/payouts/product_payouts/bdm_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/techno_enterprise/techno_enterprise.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/travel_consultant/travel_consultant.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BDMDashboardPage extends StatefulWidget {
  const BDMDashboardPage({super.key});

  @override
  State<BDMDashboardPage> createState() => _BDMDashboardPageState();
}

class _BDMDashboardPageState extends State<BDMDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Development Manager Dashboard',
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
                      "Welcome, Business Development Manager!",
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
                            builder: (context) => BDMDashboardPage()),
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
                  ExpansionTile(
                    title: const Text("Payouts"),
                    leading: const Icon(Icons.payment),
                    children: [
                      _drawerItem(context, Icons.payment, "Product Payout",
                          BDMProductPayoutsPage(),
                          padding: true),
                      _drawerItem(context, Icons.payment, "BDM Payouts",
                          BDMPayoutsPage(),
                          padding: true),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Business Mentor'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBusinessMentorPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Techno Enterprise'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewTEPage1()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Travel Consultant'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewTCPage1()),
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
            _buildHeader(),
            SizedBox(height: 20),
            CustomAnimatedSummaryCards(
              cardData: [
                SummaryCardData(
                    title: 'BUSINESS MENTOR REGISTERED',
                    value: '3',
                    icon: Icons.people),
                SummaryCardData(
                    title: 'TECHNO ENTERPRISE REGISTERED',
                    value: '9',
                    icon: Icons.calendar_today),
                SummaryCardData(
                    title: 'MY WALLET',
                    value: '₹ 2000',
                    icon: Icons.account_balance_wallet),
              ],
            ),
            SizedBox(height: 20),
            ProgressTrackerCard(
              totalSteps: 10,
              currentStep: 3,
              message: "Keep going! You're doing great!",
              progressColor: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            ImprovedLineChart(),
            SizedBox(height: 20),
            _buildTopPerformersSection(),
            SizedBox(height: 20),
            _buildTopPerformersSection1(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformersSection() {
    List<Map<String, dynamic>> departments = [
      {"name": "Business Mentor", "performers": _getDummyPerformers1()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 13,
            childAspectRatio: 1.65,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            var dept = departments[index];
            return _buildDepartmentCard(dept["name"], dept["performers"]);
          },
        ),
      ],
    );
  }

  Widget _buildTopPerformersSection1() {
    List<Map<String, dynamic>> departments = [
      {"name": "Booking", "performers": _getDummyPerformers2()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 13,
            childAspectRatio: 1.7,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            var dept = departments[index];
            return _buildDepartmentCard1(dept["name"], dept["performers"]);
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
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Top $department's",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  " Ranks",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  " Profile Picture",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Full Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Registration Date",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Count",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton.icon(
                  onPressed: null, // 🔒 Button is disabled
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  label: Text("Status", style: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Active/Inactive",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (context, rank) {
                  return Row(
                    children: [
                      Image.asset(
                        "assets/${rank + 1}.jpg", // Rank Image
                        width: 53,
                        height: 53,
                      ),
                      SizedBox(width: 40),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(performers[rank]["image"]!),
                      ),
                      SizedBox(width: 55),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                                120, // Set a fixed width to keep all names aligned
                            child: Text(
                              performers[rank]["name"]!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow
                                  .ellipsis, // Ensures long names don't break layout
                              maxLines: 1, // Keeps text on a single line
                            ),
                          ),
                          Text(
                            "id3445345",
                            style: TextStyle(color: Color(0xFF495057)),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width:
                            85, // Adjust width as needed for better alignment
                        child: Text(
                          performers[rank]["date"]!,
                          textAlign: TextAlign.center, // Center align text
                        ),
                      ),
                      SizedBox(width: 35),
                      Spacer(),
                      Center(
                        child: Text(performers[rank]["count"]!,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 55),
                      Text(
                        "Active",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(width: 40),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // First Box (Green Background)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green
                                  .withOpacity(0.1), // Light green background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "0",
                              style: TextStyle(
                                color: Colors.green, // Green text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(width: 5), // Space between boxes

                          Text("/",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)), // Separator

                          SizedBox(width: 5), // Space between boxes

                          // Second Box (Red Background)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red
                                  .withOpacity(0.1), // Light red background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "0",
                              style: TextStyle(
                                color: Colors.red, // Red text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
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
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Current $department's",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  " Booking ID",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  " Customer Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 55,
                ),
                Text(
                  "Package Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Booking Date",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Travel Date",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (context, rank) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(performers[rank]["bookingid"]!),
                      SizedBox(
                        width: 45,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                                120, // Set a fixed width to keep all names aligned
                            child: Text(
                              performers[rank]["name"]!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow
                                  .ellipsis, // Ensures long names don't break layout
                              maxLines: 1, // Keeps text on a single line
                            ),
                          ),
                          Text(
                            performers[rank]["custid"]!,
                            style: TextStyle(color: Color(0xFF495057)),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        performers[rank]["pname"]!,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "₹${performers[rank]["amt"]!}",
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      Text(
                        performers[rank]["bdate"]!,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        performers[rank]["tdate"]!,
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
                  backgroundColor:
                      Color.fromARGB(255, 81, 131, 246), // Same blue as header
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5, // Slight shadow for better UI feel
                ),
                child: Text('View More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Welcome, User!",
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
      "name": "John Doe",
      "image": "https://randomuser.me/api/portraits/men/1.jpg",
      "count": "30",
      "date": "26/06/2024"
    },
    {
      "name": "Jane Smith",
      "image": "https://randomuser.me/api/portraits/women/1.jpg",
      "count": "30",
      "date": "26/06/2024"
    },
    {
      "name": "Alice Brown",
      "image": "https://randomuser.me/api/portraits/women/2.jpg",
      "count": "30",
      "date": "26/06/2024"
    },
    {
      "name": "Bob White",
      "image": "https://randomuser.me/api/portraits/men/2.jpg",
      "count": "30",
      "date": "26/06/2024"
    },
    {
      "name": "Charlie Black",
      "image": "https://randomuser.me/api/portraits/men/3.jpg",
      "count": "30",
      "date": "26/06/2024"
    },
  ];
}

List<Map<String, String>> _getDummyPerformers2() {
  return [
    {
      "bookingid": "bid2344234",
      "name": "John Doe",
      "custid": "cid234",
      "pname": "John Doe",
      "amt": "3000",
      "bdate": "26/06/2024",
      "tdate": "26/06/2024"
    },
    {
      "bookingid": "bid2344234",
      "name": "John Doe",
      "custid": "cid234",
      "pname": "John Doe",
      "amt": "3000",
      "bdate": "26/06/2024",
      "tdate": "26/06/2024"
    },
    {
      "bookingid": "bid2344234",
      "name": "John Doe",
      "custid": "cid234",
      "pname": "John Doe",
      "amt": "3000",
      "bdate": "26/06/2024",
      "tdate": "26/06/2024"
    },
    {
      "bookingid": "bid2344234",
      "name": "John Doe",
      "custid": "cid234",
      "pname": "John Doe",
      "amt": "3000",
      "bdate": "26/06/2024",
      "tdate": "26/06/2024"
    },
    {
      "bookingid": "bid2344234",
      "name": "John Doe",
      "custid": "cid234",
      "pname": "John Doe",
      "amt": "3000",
      "bdate": "26/06/2024",
      "tdate": "26/06/2024"
    },
  ];
}
