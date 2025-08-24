import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/controllers/profile_controller.dart';
import 'package:bizzmirth_app/data_source/cust_top_referral_customers.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_referral_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/referral_customers.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/coupons_tracker.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/neo_select_benefits.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:bizzmirth_app/widgets/user_type_widget.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
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
  // String customerType = '';
  String custtype = '';
  late ConfettiController _confettiController;

  bool _isDashboardInitialized = false;
  bool _isInitializing = false;
  String? _cachedRegDate;

  @override
  void initState() {
    super.initState();
    _initializeDashboardData();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _initializeDashboardData() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      await getCustomerType();

      final customerController = context.read<CustomerController>();
      final profileController = context.read<ProfileController>();

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
        customerController.getDashboardStatCounts(),
        customerController.apiGetTopCustomerRefererals(),
        profileController.apiGetUserDetails(),
        profileController.apiGetPersonalDetails(),
        if (_cachedRegDate != null)
          customerController.apiGetChartData(DateTime.now().year.toString()),
      ]);

      if (profileController.customerType != null &&
          profileController.customerType!.isNotEmpty) {
        // Use the fresh customer_type from API instead of SharedPreferences
        custtype = profileController.customerType!;
        // Save it to SharedPreferences for future use
        await SharedPrefHelper().saveCustomerType(custtype);
        Logger.success("Using customer_type from API: $custtype");
      }

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

  Widget bodywidget(String type) {
    if (type == "Premium") {
      return premiumWidget(type);
    } else if (type == "Premium Select") {
      return premiumSelectWidget(type);
    } else if (type == "Neo Select") {
      return neoSelectWidget(type);
    } else {
      // Show toast and return a placeholder widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastHelper.showErrorToast(
            context: context, title: "No User Type Found");
      });
      return Center(child: Text('No content available'));
    }
  }

  Widget premiumWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PremiumSelectCard(
        title: "Premium Customer",
        description:
            "Use points and vouchers to unlock premium & standard travel experiences.",
        firstButtonText: "Premium Select Deals",
        secondButtonText: "View Your Packages",
      ),
      SizedBox(height: 20),
      CustomAnimatedSummaryCards(
        cardData: [
          SummaryCardData(
              title: 'Registered Customers',
              value: customerController.registerCustomerTotal!,
              thisMonthValue: customerController.registerCustomerThisMonth,
              icon: Icons.people),
          SummaryCardData(
              title: 'Completed Tours',
              value: customerController.completedTourTotal!,
              thisMonthValue: customerController.completedTourThisMonth,
              icon: Icons.map_outlined),
          SummaryCardData(
              title: 'Upcoming Tours',
              value: customerController.upcomingTourTotal!,
              thisMonthValue: customerController.upcomingTourThisMonth,
              icon: Icons.history),
          SummaryCardData(
              title: 'Commision Earned',
              value: customerController.commisionEarnedTotal!,
              thisMonthValue: customerController.pendingCommissionTotal,
              icon: Icons.money),
        ],
      ),
      SizedBox(height: 20),
      CouponProgressBar(
        currentStep: 4,
        confettiController: _confettiController,
        scaleFactor: 0.8,
      ),
      SizedBox(height: 16),
      ReferralTrackerCard(
        totalSteps: 10,
        currentStep: 10,
        progressColor: Colors.green,
      ),
      buildTripOrRefundNote(userType: type, context: context),
      SizedBox(height: 20),
      if (_isDashboardInitialized)
        ImprovedLineChart(
          initialYear: _cachedRegDate ?? customerController.userRegDate,
          key: ValueKey(
              'chart_${_cachedRegDate ?? customerController.userRegDate}'),
        )
      else
        SizedBox(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount:
                  customerController.topCustomerRefererals.length.toString(),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: isTablet
                  ? SizedBox(
                      height: (_rowsPerPage * dataRowHeight) +
                          headerHeight +
                          paginationHeight,
                      child: customerController.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PaginatedDataTable(
                              columns: [
                                DataColumn(label: Text("Rank")),
                                DataColumn(label: Text("Profile Picture")),
                                DataColumn(label: Text("Full Name")),
                                DataColumn(label: Text("Date Reg")),
                                DataColumn(label: Text("Total CU Ref")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Active/Inactive")),
                              ],
                              source: CustTopReferralCustomers(
                                  customers:
                                      customerController.topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              customerController.topCustomerRefererals.length,
                          itemBuilder: (context, index) {
                            final customer =
                                customerController.topCustomerRefererals[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header with rank and profile
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Rank badge
                                        Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: (index + 1) <= 3
                                                ? Colors.amber.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: (index + 1) <= 3
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: (index + 1) <= 3
                                                  ? Colors.amber[800]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),

                                        // Profile picture
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.transparent,
                                          child: getProfileImage(
                                              customer.profilePic),
                                        ),
                                        SizedBox(width: 12),

                                        // Name and date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.name ?? 'N/A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                customer.registeredDate ??
                                                    'N/A',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16),

                                    // Stats row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Total referrals
                                        _buildStatItem(
                                          Icons.people,
                                          'Total',
                                          '${customer.totalReferals ?? 0}',
                                          Colors.blue,
                                        ),

                                        // Active referrals
                                        _buildStatItem(
                                          Icons.check_circle,
                                          'Active',
                                          '${customer.activeReferrals ?? 0}',
                                          Colors.green,
                                        ),

                                        // Inactive referrals
                                        _buildStatItem(
                                          Icons.cancel,
                                          'Inactive',
                                          '${customer.inActiveReferrals ?? 0}',
                                          Colors.red,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // Status badge
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(customer.status!)
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _getStatusColor(
                                                    customer.status!)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(customer.status!),
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                customer.status!),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget premiumSelectWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PremiumSelectCard(
        title: "Premium Select Lite Customer",
        description:
            "Use points and vouchers to unlock premium & standard travel experiences.",
        firstButtonText: "Premium Select Deals",
        secondButtonText: "View Your Packages",
      ),
      SizedBox(height: 20),
      CustomAnimatedSummaryCards(
        cardData: [
          SummaryCardData(
              title: 'Registered Customers',
              value: customerController.registerCustomerTotal!,
              thisMonthValue: customerController.registerCustomerThisMonth,
              icon: Icons.people),
          SummaryCardData(
              title: 'Completed Tours',
              value: customerController.completedTourTotal!,
              thisMonthValue: customerController.completedTourThisMonth,
              icon: Icons.map_outlined),
          SummaryCardData(
              title: 'Upcoming Tours',
              value: customerController.upcomingTourTotal!,
              thisMonthValue: customerController.upcomingTourThisMonth,
              icon: Icons.history),
          SummaryCardData(
              title: 'Commision Earned',
              value: customerController.commisionEarnedTotal!,
              thisMonthValue: customerController.pendingCommissionTotal,
              icon: Icons.money),
        ],
      ),
      SizedBox(height: 20),
      NeoSelectBenefits(
        type: "Premium Select Lite",
        amount: 21000,
        numberOfCoupons: 5,
        valueCoupons: 25000,
        saveAmt: 4000,
      ),
      SizedBox(height: 16),
      buildTripOrRefundNote(userType: type, context: context),
      SizedBox(height: 20),
      if (_isDashboardInitialized)
        ImprovedLineChart(
          initialYear: _cachedRegDate ?? customerController.userRegDate,
          key: ValueKey(
              'chart_${_cachedRegDate ?? customerController.userRegDate}'),
        )
      else
        SizedBox(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount:
                  customerController.topCustomerRefererals.length.toString(),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: isTablet
                  ? SizedBox(
                      height: (_rowsPerPage * dataRowHeight) +
                          headerHeight +
                          paginationHeight,
                      child: customerController.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PaginatedDataTable(
                              columns: [
                                DataColumn(label: Text("Rank")),
                                DataColumn(label: Text("Profile Picture")),
                                DataColumn(label: Text("Full Name")),
                                DataColumn(label: Text("Date Reg")),
                                DataColumn(label: Text("Total CU Ref")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Active/Inactive")),
                              ],
                              source: CustTopReferralCustomers(
                                  customers:
                                      customerController.topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              customerController.topCustomerRefererals.length,
                          itemBuilder: (context, index) {
                            final customer =
                                customerController.topCustomerRefererals[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header with rank and profile
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Rank badge
                                        Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: (index + 1) <= 3
                                                ? Colors.amber.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: (index + 1) <= 3
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: (index + 1) <= 3
                                                  ? Colors.amber[800]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),

                                        // Profile picture
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.transparent,
                                          child: getProfileImage(
                                              customer.profilePic),
                                        ),
                                        SizedBox(width: 12),

                                        // Name and date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.name ?? 'N/A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                customer.registeredDate ??
                                                    'N/A',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16),

                                    // Stats row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Total referrals
                                        _buildStatItem(
                                          Icons.people,
                                          'Total',
                                          '${customer.totalReferals ?? 0}',
                                          Colors.blue,
                                        ),

                                        // Active referrals
                                        _buildStatItem(
                                          Icons.check_circle,
                                          'Active',
                                          '${customer.activeReferrals ?? 0}',
                                          Colors.green,
                                        ),

                                        // Inactive referrals
                                        _buildStatItem(
                                          Icons.cancel,
                                          'Inactive',
                                          '${customer.inActiveReferrals ?? 0}',
                                          Colors.red,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // Status badge
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(customer.status!)
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _getStatusColor(
                                                    customer.status!)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(customer.status!),
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                customer.status!),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget neoSelectWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PremiumSelectCard(
        title: "Neo Select Customer",
        description:
            "Use points and vouchers to unlock premium & standard travel experiences.",
        firstButtonText: "Premium Select Deals",
        secondButtonText: "View Your Packages",
      ),
      SizedBox(height: 20),
      CustomAnimatedSummaryCards(
        cardData: [
          SummaryCardData(
              title: 'Registered Customers',
              value: customerController.registerCustomerTotal!,
              thisMonthValue: customerController.registerCustomerThisMonth,
              icon: Icons.people),
          SummaryCardData(
              title: 'Completed Tours',
              value: customerController.completedTourTotal!,
              thisMonthValue: customerController.completedTourThisMonth,
              icon: Icons.map_outlined),
          SummaryCardData(
              title: 'Upcoming Tours',
              value: customerController.upcomingTourTotal!,
              thisMonthValue: customerController.upcomingTourThisMonth,
              icon: Icons.history),
          SummaryCardData(
              title: 'Commision Earned',
              value: customerController.commisionEarnedTotal!,
              thisMonthValue: customerController.pendingCommissionTotal,
              icon: Icons.money),
        ],
      ),
      SizedBox(height: 20),
      NeoSelectBenefits(
        type: "Neo Select",
        amount: 11000,
        numberOfCoupons: 5,
        valueCoupons: 15000,
        saveAmt: 4000,
      ),
      SizedBox(height: 16),
      buildTripOrRefundNote(userType: type, context: context),
      SizedBox(height: 20),
      if (_isDashboardInitialized)
        ImprovedLineChart(
          initialYear: _cachedRegDate ?? customerController.userRegDate,
          key: ValueKey(
              'chart_${_cachedRegDate ?? customerController.userRegDate}'),
        )
      else
        SizedBox(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount:
                  customerController.topCustomerRefererals.length.toString(),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: isTablet
                  ? SizedBox(
                      height: (_rowsPerPage * dataRowHeight) +
                          headerHeight +
                          paginationHeight,
                      child: customerController.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PaginatedDataTable(
                              columns: [
                                DataColumn(label: Text("Rank")),
                                DataColumn(label: Text("Profile Picture")),
                                DataColumn(label: Text("Full Name")),
                                DataColumn(label: Text("Date Reg")),
                                DataColumn(label: Text("Total CU Ref")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Active/Inactive")),
                              ],
                              source: CustTopReferralCustomers(
                                  customers:
                                      customerController.topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              customerController.topCustomerRefererals.length,
                          itemBuilder: (context, index) {
                            final customer =
                                customerController.topCustomerRefererals[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header with rank and profile
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Rank badge
                                        Container(
                                          width: 36,
                                          height: 36,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: (index + 1) <= 3
                                                ? Colors.amber.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: (index + 1) <= 3
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: (index + 1) <= 3
                                                  ? Colors.amber[800]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),

                                        // Profile picture
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.transparent,
                                          child: getProfileImage(
                                              customer.profilePic),
                                        ),
                                        SizedBox(width: 12),

                                        // Name and date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.name ?? 'N/A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                customer.registeredDate ??
                                                    'N/A',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16),

                                    // Stats row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Total referrals
                                        _buildStatItem(
                                          Icons.people,
                                          'Total',
                                          '${customer.totalReferals ?? 0}',
                                          Colors.blue,
                                        ),

                                        // Active referrals
                                        _buildStatItem(
                                          Icons.check_circle,
                                          'Active',
                                          '${customer.activeReferrals ?? 0}',
                                          Colors.green,
                                        ),

                                        // Inactive referrals
                                        _buildStatItem(
                                          Icons.cancel,
                                          'Inactive',
                                          '${customer.inActiveReferrals ?? 0}',
                                          Colors.red,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // Status badge
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(customer.status!)
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _getStatusColor(
                                                    customer.status!)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(customer.status!),
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                customer.status!),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ]);
  }

  Future<void> getCustomerType() async {
    try {
      custtype = await SharedPrefHelper().getCustomerType() ?? '';
      Logger.success("customer type: $custtype");
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
    final isTablet = MediaQuery.of(context).size.width > 600; // breakpoint
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: profileController.profilePic ?? "",
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 30,
                          ),
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 30,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundImage:
                                const AssetImage("assets/default_profile.png"),
                            radius: 30,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome, ${profileController.firstName}!",
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
                    if (custtype != 'Free')
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
                        _drawerItem(
                            context,
                            Icons.inventory_2,
                            "Product Payout",
                            CustProductPayoutsPage(
                              userName:
                                  "${profileController.firstName} ${profileController.lastName}",
                            ),
                            padding: true),
                        _drawerItem(
                            context,
                            Icons.people_alt,
                            "Referral Payout",
                            CustomerReferralPayouts(
                                username:
                                    "${profileController.firstName} ${profileController.lastName}"),
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
                          Icons.person,
                        ),
                        title: Text("Profile Page"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        },
                      ),
                    ),
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
                  return Stack(
                    children: [
                      // Main content
                      SingleChildScrollView(
                          padding: EdgeInsets.all(16.0),
                          child: bodywidget(custtype)),

                      // Confetti overlay (on top of everything)
                      if (custtype == "Premium")
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConfettiWidget(
                                confettiController: _confettiController,
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                shouldLoop: false,
                                emissionFrequency: 0.05,
                                numberOfParticles: 100,
                                gravity: 0.4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget getProfileImage(String? profilePicture) {
    const double imageSize = 40;

    if (profilePicture == null || profilePicture.isEmpty) {
      return Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          "assets/default_profile.png",
          fit: BoxFit.cover,
        ),
      );
    }

    final String imageUrl;
    if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
      imageUrl = profilePicture;
    } else {
      final newpath = extractPathSegment(profilePicture, 'profile_pic/');
      imageUrl = "https://testca.uniqbizz.com/uploading/$newpath";
    }

    Logger.success("Final image URL: $imageUrl");

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
        errorWidget: (context, url, error) => Image.asset(
          "assets/default_profile.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Active';
      case '3':
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
