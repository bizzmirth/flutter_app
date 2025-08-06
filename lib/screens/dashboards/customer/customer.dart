import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/data_source/cust_top_referral_customers.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_referral_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/referral_customers.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/coupons_tracker.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String customerType = '';

  bool _isDashboardInitialized = false;
  bool _isInitializing = false;
  String? _cachedRegDate;

  @override
  void initState() {
    super.initState();
    _initializeDashboardData();
  }

  Future<void> _initializeDashboardData() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      await getCustomerType();

      final customerController = context.read<CustomerController>();

      int attempts = 0;
      while (customerController.isLoading && attempts < 20) {
        await Future.delayed(Duration(milliseconds: 100));
        attempts++;
      }

      String? regDate = await _getRegistrationDate(customerController);

      if (regDate != null && regDate.isNotEmpty) {
        _cachedRegDate = regDate;
        if (customerController.userRegDate == null ||
            customerController.userRegDate!.isEmpty) {
          customerController.setUserRegDate(regDate);
        }
      }

      await Future.wait([
        customerController.getRegCustomerCount(),
        customerController.apiGetTopCustomerRefererals(),
        if (_cachedRegDate != null)
          customerController.apiGetChartData(DateTime.now().year.toString()),
      ]);

      if (mounted) {
        setState(() {
          _isDashboardInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      Logger.error('Error initializing dashboard: $e');
      if (mounted) {
        setState(() {
          _isDashboardInitialized = true;
          _isInitializing = false;
        });
      }
    }
  }

  Future<String?> _getRegistrationDate(CustomerController controller) async {
    if (controller.userRegDate != null && controller.userRegDate!.isNotEmpty) {
      Logger.info('Using reg date from controller: ${controller.userRegDate}');
      return controller.userRegDate;
    }

    String? sharedPrefDate = await SharedPrefHelper().getCurrentUserRegDate();
    if (sharedPrefDate != null && sharedPrefDate.isNotEmpty) {
      Logger.info('Using reg date from SharedPref: $sharedPrefDate');
      return sharedPrefDate;
    }

    Logger.warning('No registration date found in controller or SharedPref');
    return null;
  }

  Future<void> getCustomerType() async {
    try {
      customerType = await SharedPrefHelper().getCustomerType() ?? '';
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Logger.error('Error getting customer type: $e');
    }
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevents dismissing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Exit App'),
                ],
              ),
              content: const Text(
                'Are you sure you want to exit the app?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false (don't exit)
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true (exit)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed without selection
  }

  // Future<void> _refreshDashboard() async {
  //   setState(() {
  //     _isDashboardInitialized = false;
  //   });
  //   await _initializeDashboardData();
  // }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Loading Dashboard...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please wait while we fetch your data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String title, Widget destination,
      {bool padding = false}) {
    return Padding(
      padding: padding ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.blueAccent, Colors.lightBlue],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(Icons.dashboard, color: Colors.white, size: 30),
  //         SizedBox(width: 16),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Dashboard Overview',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Text(
  //               'Welcome back! Here\'s your performance summary',
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Spacer(),
  //         IconButton(
  //           onPressed: _refreshDashboard,
  //           icon: Icon(Icons.refresh, color: Colors.white),
  //           tooltip: 'Refresh Dashboard',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Show the exit dialog and wait for user response
        final shouldExit = await _showExitDialog();

        if (shouldExit) {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Customer Dashboard',
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
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                        Navigator.pop(
                            context); // Just close drawer if already on dashboard
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
                    if (customerType != 'Free')
                      ListTile(
                        leading: Icon(Icons.account_balance_wallet),
                        title: Text('My Wallet'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletDetailsPage()),
                          );
                        },
                      ),
                    ExpansionTile(
                      title: const Text("Payouts"),
                      leading: const Icon(Icons.payment),
                      children: [
                        _drawerItem(context, Icons.inventory_2,
                            "Product Payout", CustProductPayoutsPage(),
                            padding: true),
                        _drawerItem(context, Icons.people_alt,
                            "Referral Payout", CustomerReferralPayouts(),
                            padding: true),
                      ],
                    ),
                    ListTile(
                      leading: Icon(Icons.history),
                      title: Text('Order History'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderHistory()),
                        );
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        leading: Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.red,
                        ),
                        title: Text("Log Out"),
                        onTap: () async {
                          SharedPrefHelper().removeDetails();
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
        body: _isInitializing
            ? _buildLoadingState()
            : Consumer<CustomerController>(
                builder: (context, controller, child) {
                  // Only rebuild specific parts when needed
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildHeader(),
                        SizedBox(height: 20),

                        CustomAnimatedSummaryCards(
                          cardData: [
                            SummaryCardData(
                                title: 'REFERRAL CUSTOMER REGISTERED',
                                value: '${controller.regCustomerCount}',
                                icon: Icons.people),
                            SummaryCardData(
                                title: 'TOTAL BOOKING',
                                value: '9',
                                icon: Icons.calendar_today),
                            if (controller.customerType != 'Free')
                              SummaryCardData(
                                  title: 'MY WALLET',
                                  value: '',
                                  icon: Icons.account_balance_wallet),
                          ],
                        ),
                        SizedBox(height: 20),

                        CouponProgressBar(
                            currentStep: 4), // Change currentStep dynamically

                        // ProgressTrackerCard(
                        //   totalSteps: 10,
                        //   currentStep: controller.regCustomerCount,
                        //   message: "Keep going! You're doing great!",
                        //   progressColor: Colors.blueAccent,
                        // ),
                        SizedBox(height: 20),

                        if (_isDashboardInitialized)
                          ImprovedLineChart(
                            initialYear:
                                _cachedRegDate ?? controller.userRegDate,
                            key: ValueKey(
                                'chart_${_cachedRegDate ?? controller.userRegDate}'),
                          )
                        else
                          Container(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading chart data...'),
                                ],
                              ),
                            ),
                          ),
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
                                    "Top Customers Referral",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.black26),
                              FilterBar(
                                userCount: controller
                                    .topCustomerRefererals.length
                                    .toString(),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SizedBox(
                                  height: (_rowsPerPage * dataRowHeight) +
                                      headerHeight +
                                      paginationHeight,
                                  child: controller.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : PaginatedDataTable(
                                          columns: [
                                            DataColumn(label: Text("Rank")),
                                            DataColumn(
                                                label: Text("Profile Picture")),
                                            DataColumn(
                                                label: Text("Full Name")),
                                            DataColumn(label: Text("Date Reg")),
                                            DataColumn(
                                                label: Text("Total CU Ref")),
                                            DataColumn(label: Text("Status")),
                                            DataColumn(
                                                label: Text("Active/Inactive")),
                                          ],
                                          source: CustTopReferralCustomers(
                                              customers: controller
                                                  .topCustomerRefererals),
                                          rowsPerPage: _rowsPerPage,
                                          availableRowsPerPage: [
                                            5,
                                            10,
                                            15,
                                            20,
                                            25
                                          ],
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
                },
              ),
      ),
    );
  }
}
