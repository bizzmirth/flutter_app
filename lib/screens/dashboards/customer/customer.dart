import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/data_source/current_booking_data_source.dart';
import 'package:bizzmirth_app/data_source/cust_top_referral_customers.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/referral_customers.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CDashboardPage extends StatefulWidget {
  const CDashboardPage({super.key});

  @override
  State<CDashboardPage> createState() => _CDashboardPageState();
}

class _CDashboardPageState extends State<CDashboardPage> {
  int regCustomerCount = 0;
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().getRegCustomerCount();
      context.read<CustomerController>().apiGetTopCustomerRefererals();
    });
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
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Top Up Wallet'),
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
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Referral Wallet'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpWalletPage(
                                  title: "Referral Wallet",
                                )),
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
      body: Consumer<CustomerController>(builder: (context, contrller, child) {
        return SingleChildScrollView(
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
                      value: '${contrller.regCustomerCount}',
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
                currentStep: contrller.regCustomerCount,
                message: "Keep going! You're doing great!",
                progressColor: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              ImprovedLineChart(),
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
                          "Top Customers Refereral",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    FilterBar(),
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
                            DataColumn(label: Text("Rank")),
                            DataColumn(label: Text("Profile Picture")),
                            DataColumn(label: Text("Full Name")),
                            DataColumn(label: Text("Joining Date")),
                            DataColumn(label: Text("Count")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Active/Inactive")),
                          ],
                          source: CustTopReferralCustomers(
                              customers: contrller.topCustomerRefererals),
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Divider(thickness: 1, color: Colors.black26),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Current Booking's",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.black26),
                    FilterBar(),
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
                            DataColumn(label: Text("Booking ID")),
                            DataColumn(label: Text("Customer Name")),
                            DataColumn(label: Text("Package Name")),
                            DataColumn(label: Text("Amount")),
                            DataColumn(label: Text("Booking Date")),
                            DataColumn(label: Text("Travel Date")),
                          ],
                          source: CurrentBookingDataSource(bookings),
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
            ],
          ),
        );
      }),
    );
  }

  // Widget _buildTopPerformersSection1() {
  //   List<Map<String, dynamic>> departments = [
  //     {"name": "Booking", "performers": _getDummyPerformers2()},
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       GridView.builder(
  //         shrinkWrap: true,
  //         physics: NeverScrollableScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 1,
  //           crossAxisSpacing: 2,
  //           mainAxisSpacing: 13,
  //           childAspectRatio: 1.7,
  //         ),
  //         itemCount: departments.length,
  //         itemBuilder: (context, index) {
  //           var dept = departments[index];
  //           return _buildDepartmentCard1(dept["name"], dept["performers"]);
  //         },
  //       ),
  //     ],
  //   );
  // }

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

  // Widget _buildDepartmentCard1(
  //     String department, List<Map<String, String>> performers) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     elevation: 3,
  //     child: Padding(
  //       padding: EdgeInsets.all(25),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   "Current $department's",
  //                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Divider(),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               SizedBox(
  //                 height: 15,
  //               )
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               SizedBox(
  //                 width: 15,
  //               ),
  //               Text(
  //                 " Booking ID",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 width: 25,
  //               ),
  //               Text(
  //                 " Customer Name",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 width: 55,
  //               ),
  //               Text(
  //                 "Package Name",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 width: 25,
  //               ),
  //               Text(
  //                 "Amount",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 width: 25,
  //               ),
  //               Text(
  //                 "Booking Date",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 width: 15,
  //               ),
  //               Text(
  //                 "Travel Date",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //           SizedBox(height: 10),
  //           Divider(),
  //           Expanded(
  //             child: ListView.builder(
  //               physics: NeverScrollableScrollPhysics(),
  //               itemCount: performers.length,
  //               itemBuilder: (context, rank) {
  //                 return Row(
  //                   children: [
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Text(performers[rank]["bookingid"]!),
  //                     SizedBox(
  //                       width: 45,
  //                     ),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SizedBox(
  //                           width:
  //                               120, // Set a fixed width to keep all names aligned
  //                           child: Text(
  //                             performers[rank]["name"]!,
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                             overflow: TextOverflow
  //                                 .ellipsis, // Ensures long names don't break layout
  //                             maxLines: 1, // Keeps text on a single line
  //                           ),
  //                         ),
  //                         Text(
  //                           performers[rank]["custid"]!,
  //                           style: TextStyle(color: Color(0xFF495057)),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       width: 50,
  //                     ),
  //                     Text(
  //                       performers[rank]["pname"]!,
  //                     ),
  //                     SizedBox(
  //                       width: 50,
  //                     ),
  //                     Text(
  //                       "₹${performers[rank]["amt"]!}",
  //                     ),
  //                     SizedBox(
  //                       width: 36,
  //                     ),
  //                     Text(
  //                       performers[rank]["bdate"]!,
  //                     ),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Text(
  //                       performers[rank]["tdate"]!,
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //           Center(
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 null;
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 foregroundColor: Colors.white, // White text
  //                 backgroundColor:
  //                     Color.fromARGB(255, 81, 131, 246), // Same blue as header
  //                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
  //                 textStyle:
  //                     TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(25),
  //                 ),
  //                 elevation: 5, // Slight shadow for better UI feel
  //               ),
  //               child: Text('View More'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
