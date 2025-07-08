import 'dart:convert';

import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/referral_customers.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CDashboardPage extends StatefulWidget {
  const CDashboardPage({super.key});

  @override
  State<CDashboardPage> createState() => _CDashboardPageState();
}

class _CDashboardPageState extends State<CDashboardPage> {
  int regCustomerCount = 0;
  @override
  void initState() {
    super.initState();
    getRegCustomerCount();
  }

  void getRegCustomerCount() async {
    try {
      String email = await SharedPrefHelper().getUserEmail() ?? "";
      Logger.success("the stored email is $email");

      final response = await http.get(
        Uri.parse(
            'https://testca.uniqbizz.com/api/customers/customers.php?action=registered_cust'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          List<dynamic> customers = jsonData['data'];

          String? userTaReferenceNo;
          String? userCustomerId;

          for (var customer in customers) {
            if (customer['email'] == email) {
              userTaReferenceNo = customer['ta_reference_no'];
              userCustomerId = customer['ca_customer_id'];
              await SharedPrefHelper().saveCurrentUserCustId(userCustomerId!);
              Logger.success("Found user with ca_customer_id: $userCustomerId");
              Logger.success("User's ta_reference_no: $userTaReferenceNo");
              break;
            }
          }

          if (userCustomerId != null) {
            int count = 0;
            for (var customer in customers) {
              if (customer['reference_no'] == userCustomerId) {
                count++;
              }
            }

            setState(() {
              regCustomerCount = count;
            });

            Logger.success(
                "Total customers with ta_reference_no '$userTaReferenceNo': $regCustomerCount");
          } else {
            Logger.error("No customer found with email: $email");
            setState(() {
              regCustomerCount = 0;
            });
          }
        } else {
          Logger.error("API returned error status: ${jsonData['status']}");
        }
      } else {
        Logger.error("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      Logger.error("Error in getRegCustomerCount: $e");
      setState(() {
        regCustomerCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Dashboard',
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
                      "Welcome, Customer!",
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
                            builder: (context) => CDashboardPage()),
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
                    leading: Icon(Icons.people),
                    title: Text('Referral Customers'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCustomersPage()),
                      );
                    },
                  ),
                  ExpansionTile(
                    title: const Text("Payouts"),
                    leading: const Icon(Icons.payment),
                    children: [
                      _drawerItem(context, Icons.payment, "Product Payout",
                          CustProductPayoutsPage(),
                          padding: true),
                    ],
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
                      onTap: () async {
                        SharedPrefHelper().removeUserEmailAndType();
                        await Navigator.pushAndRemoveUntil(
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
                    title: 'REFERRAL CUSTOMER REGISTERED',
                    value: '$regCustomerCount',
                    icon: Icons.people),
                SummaryCardData(
                    title: 'TOTAL BOOKING',
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
      {"name": "Referral Customer", "performers": _getDummyPerformers1()},
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
