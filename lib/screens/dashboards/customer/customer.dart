import 'package:bizzmirth_app/controllers/common_controllers/profile_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/data_source/customer_data_sources/cust_top_referral_customers.dart';
import 'package:bizzmirth_app/entities/top_customer_refereral/top_customer_refereral_model.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/screens/contact_us/contact_us.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_product_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/payouts/customer_referral_payouts.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/referral_customers.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/profile_page/profile_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/coupons_tracker.dart';
import 'package:bizzmirth_app/widgets/custom_animated_summary_cards.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/free_user_type_widget.dart';
import 'package:bizzmirth_app/widgets/improved_line_chart.dart';
import 'package:bizzmirth_app/widgets/neo_select_benefits.dart';
import 'package:bizzmirth_app/widgets/referral_tracker_card.dart';
import 'package:bizzmirth_app/widgets/user_type_widget.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
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
  int eligibleCouponsCount = 0;
  late ConfettiController _confettiController;

  // bool _isDashboardInitialized = false;
  bool _isInitializing = false;
  String? _cachedRegDate;

  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? fromDateError;
  String? toDateError;

  List<TopCustomerRefereralModel> filteredCustomers = [];

// charts data send from dashboard
  String selectedYear = DateTime.now().year.toString();
  List<String> availableYears = [];
  bool isLoading = true;
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
        Provider.of<CustomerController>(context, listen: false);
    setState(() => isLoading = true);

    await customerController.apiGetChartData(year);
    final data = customerController.getChartSpots();

    setState(() {
      chartData = data;
      isLoading = false;
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
    _initializeDashboardData();
    _initializeTopFilteredCustomers();
    _initData();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  void _initializeTopFilteredCustomers() {
    final customerController = context.read<CustomerController>();
    setState(() {
      filteredCustomers = List.from(customerController.topCustomerRefererals);
    });
  }

  void _onTopCustomerSearchChanged(String searchTerm) {
    _applyTopCustomerFilters(
        searchTerm: searchTerm, fromDate: fromDate, toDate: toDate);
  }

  void _onTopCustomerDateChanged(DateTime? from, DateTime? to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
    _applyTopCustomerFilters(
        searchTerm: searchController.text, fromDate: from, toDate: to);
  }

  void _onTopCustomerClearFilters() {
    setState(() {
      searchController.clear();
      fromDate = null;
      toDate = null;
      filteredCustomers =
          List.from(context.read<CustomerController>().topCustomerRefererals);
    });
  }

  void _applyTopCustomerFilters(
      {String? searchTerm, DateTime? fromDate, DateTime? toDate}) {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);

    if (customerController.topCustomerRefererals.isEmpty) {
      return;
    }

    setState(() {
      filteredCustomers =
          customerController.topCustomerRefererals.where((customer) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final String searchTermLower = searchTerm.toLowerCase();
          matchesSearch =
              customer.name?.toLowerCase().contains(searchTermLower) == true ||
                  customer.status?.toLowerCase().contains(searchTermLower) ==
                      true;
        }

        // Date range filter
        if (fromDate != null || toDate != null) {
          if (customer.registeredDate != null &&
              customer.registeredDate!.isNotEmpty) {
            try {
              // Assuming the date format is the same as your pending customers
              // If different, adjust the DateFormat accordingly
              final DateTime customerDate =
                  DateTime.parse(customer.registeredDate!);

              if (fromDate != null && customerDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  customerDate.isAfter(toDate.add(const Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              Logger.error(
                  'Error parsing top customer date: ${customer.registeredDate} - $e');
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  Future<void> _onRefreshDashboard() async {
    await _initializeDashboardData();
    _initializeTopFilteredCustomers();
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

    final customerController = context.read<CustomerController>();
    final profileController = context.read<ProfileController>();

    try {
      await getCustomerType();

      int attempts = 0;
      while (customerController.isLoading && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      final String? regDate = await _getRegistrationDate(customerController);

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
        profileController.getCouponDetails(),
        if (_cachedRegDate != null)
          customerController.apiGetChartData(DateTime.now().year.toString()),
      ]);

      eligibleCouponsCount = profileController.eligibleCouponCount;

      if (eligibleCouponsCount == 3 || eligibleCouponsCount > 3) {
        eligibleCouponsCount = 4;
      }

      final loginRes = await SharedPrefHelper().getLoginResponse();
      custtype = loginRes?.custType ?? '';
      Logger.info('Customer type at initialization: $custtype');



      if (mounted) {
        setState(() {
          // _isDashboardInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      Logger.error('Error initializing dashboard: $e');
      if (mounted) {
        setState(() {
          // _isDashboardInitialized = true;
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

    final String? sharedPrefDate =
        await SharedPrefHelper().getCurrentUserRegDate();
    if (sharedPrefDate != null && sharedPrefDate.isNotEmpty) {
      Logger.info('Using reg date from SharedPref: $sharedPrefDate');
      return sharedPrefDate;
    }

    Logger.warning('No registration date found in controller or SharedPref');
    return null;
  }

  Widget bodywidget(String type) {
    if (type == 'Premium') {
      return premiumWidget(type);
    } else if (type == 'Premium Select Lite') {
      return premiumSelectLiteWidget(type);
    } else if (type == 'Neo Select') {
      return neoSelectWidget(type);
    } else if (type == 'Premium Select') {
      return premiumSelectWidget(type);
    } else {
      return freeuser();
    }
  }

  Widget premiumSelectWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    final String userCount = filteredCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.topCustomerRefererals.length.toString()
        : filteredCustomers.length.toString();
    final topCustomers = filteredCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.topCustomerRefererals
        : filteredCustomers;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PremiumSelectCard(
        title: 'Premium Select Customer',
        description:
            'Use points and vouchers to unlock premium & standard travel experiences.',
      ),
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      // NeoSelectBenefits(
      //   type: "Premium Select",
      //   amount: 35000,
      //   numberOfCoupons: 5,
      //   valueCoupons: 25000,
      //   saveAmt: 4000,
      // ),
      // SizedBox(height: 16),
      buildTripOrRefundNote(userType: type, context: context),
      const SizedBox(height: 20),
      // if (_isDashboardInitialized)
      //   ImprovedLineChart(
      //     chartData: chartData,
      //     availableYears: availableYears,
      //     selectedYear: selectedYear,
      //     isLoading: isLoading,
      //     hasError: hasError,
      //     errorMessage: errorMessage,
      //     onYearChanged: (year) async {
      //       setState(() => selectedYear = year ?? '');
      //       await _loadChartData(year ?? '');
      //     },
      //   )
      // else
      const SizedBox(
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
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(thickness: 1, color: Colors.black26),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Top Customers Referral',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount: userCount,
              onSearchChanged: _onTopCustomerSearchChanged,
              onDateRangeChanged: _onTopCustomerDateChanged,
              onClearFilters: _onTopCustomerClearFilters,
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
                          ? const Center(child: CircularProgressIndicator())
                          : customerController.topCustomerRefererals.isEmpty
                              ? _buildEmptyState()
                              : PaginatedDataTable(
                                  columns: const [
                                    DataColumn(label: Text('Rank')),
                                    DataColumn(label: Text('Profile Picture')),
                                    DataColumn(label: Text('Full Name')),
                                    DataColumn(label: Text('Date Reg')),
                                    DataColumn(label: Text('Total CU Ref')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Active/Inactive')),
                                  ],
                                  source: CustTopReferralCustomers(
                                      customers: customerController
                                          .topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        customerController.topCustomerRefererals.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: topCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = topCustomers[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      ? Colors.amber.withValues(
                                                          alpha: 0.2)
                                                      : Colors.grey.withValues(
                                                          alpha: 0.1),
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
                                              const SizedBox(width: 12),

                                              // Profile picture
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: getProfileImage(
                                                    customer.profilePic),
                                              ),
                                              const SizedBox(width: 12),

                                              // Name and date
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer.name ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
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

                                          const SizedBox(height: 16),

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

                                          const SizedBox(height: 12),

                                          // Status badge
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        customer.status!)
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: _getStatusColor(
                                                          customer.status!)
                                                      .withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                _getStatusText(
                                                    customer.status!),
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

  Widget freeuser() {
    final customerController = context.read<CustomerController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with upgrade CTA
          const FreeUserCard(),

          const SizedBox(height: 24),

          // Stats Cards with improved design
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 500 ? 0.489 : 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * cardWidth,
                    child: _buildStatCard(
                      context: context,
                      title: 'Your Referrals',
                      value: 'Upgrade to view',
                      icon: Icons.people_outline,
                      color: Colors.blue,
                      hasData: false,
                      onTap: () => _showUpgradePrompt(context),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * cardWidth,
                    child: _buildStatCard(
                      context: context,
                      title: 'Available Tours',
                      value: 'Sign Up to know more',
                      icon: Icons.explore_outlined,
                      color: Colors.green,
                      hasData: false,
                      onTap: () => _showUpgradePrompt(context),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Premium Features Card
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.grey.shade800, Colors.grey.shade700]
                      : [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [Colors.indigo.shade800, Colors.purple.shade800]
                        : [Colors.indigo.shade50, Colors.purple.shade50],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium,
                              size: 24, color: Colors.amber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Unlock Premium Benefits',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.indigo.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Upgrade your account to access exclusive features:',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white70
                              : Colors.indigo.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Features in a responsive grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                              constraints.maxWidth > 400 ? 2 : 1;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: crossAxisCount == 2 ? 3.5 : 4,
                            children: [
                              _buildFeatureCard(
                                  'Earn Commission',
                                  Icons.monetization_on,
                                  Colors.green,
                                  'Get paid for every successful referral',
                                  context),
                              _buildFeatureCard(
                                  'Premium Tours',
                                  Icons.star,
                                  Colors.amber,
                                  'Access exclusive tour packages',
                                  context),
                              _buildFeatureCard(
                                  'Referral Bonuses',
                                  Icons.card_giftcard,
                                  Colors.purple,
                                  'Special rewards for top referrers',
                                  context),
                              _buildFeatureCard(
                                  'Exclusive Discounts',
                                  Icons.discount,
                                  Colors.blue,
                                  'Member-only pricing on all tours',
                                  context),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // CTA Button with icon
                      ElevatedButton.icon(
                        onPressed: () => _showMembershipOptions(context),
                        icon: const Icon(Icons.rocket_launch, size: 20),
                        label: const Text('Explore Membership Plans'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.amber.shade700
                              : Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 52),
                          elevation: 2,
                          shadowColor: Colors.indigo.withValues(alpha: 0.3),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Limited preview section with improved design
          if (customerController.topCustomerRefererals.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.leaderboard,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Top Referrers Preview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.lock_outline,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upgrade to see the full leaderboard and your ranking',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Show limited preview (first 2 items)
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Upgrade to unlock detailed analytics',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _showUpgradePrompt(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Unlock Analytics'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (customerController.topCustomerRefererals.length > 2)
                      Center(
                        child: TextButton(
                          onPressed: () => _showUpgradePrompt(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Upgrade to see all ${customerController.topCustomerRefererals.length} referrers',
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward,
                                  size: 16, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Analytics preview with improved design
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Your Activity Preview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Upgrade to unlock detailed analytics',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showUpgradePrompt(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Unlock Analytics'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // FAQ section with enhanced design
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.grey.shade800, Colors.grey.shade700]
                      : [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with improved styling
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.help_outline,
                              size: 22, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Everything you need to know about our membership program',
                      style: TextStyle(
                        color:
                            isDarkMode ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Interactive FAQ items
                    _buildExpandableFAQItem(
                        'How do I refer friends & family?',
                        "Upgrade your membership to get started. Once you're a premium member, you can start referring friends and family. You'll earn commissions when they sign up for any tour package.",
                        context),

                    _buildExpandableFAQItem(
                        'What benefits do I get with a membership?',
                        "As a premium member, you'll enjoy: \n• Commission on every successful referral\n• Exclusive access to premium tours\n• Special discounts on all packages\n• Chance to win free trips\n• Referral bonuses and rewards\n• Priority customer support",
                        context),

                    _buildExpandableFAQItem(
                        'How do I upgrade my account?',
                        "Choose a membership plan that fits your needs and contact our team to complete the upgrade process. We'll guide you through the steps to unlock premium features and start earning immediately.",
                        context),

                    const SizedBox(height: 20),

                    // Enhanced CTA section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.blue.shade900
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.support_agent,
                                  size: 20, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Need more help?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Our team is ready to answer all your questions',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.blue.shade700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ContactUsPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Contact Us Now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

// For expandable FAQ items
  Widget _buildExpandableFAQItem(
      String question, String answer, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.grey.shade800,
            ),
          ),
          children: [
            // Fixed alignment: Use Align or Padding with crossAxisAlignment
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer,
                  textAlign: TextAlign.left, // Explicitly set text alignment
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Updated _buildStatCard method
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool hasData,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ),
                if (!hasData)
                  const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
            ),
            if (!hasData) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Upgrade to Access',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color,
      String description, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradePrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Upgrade Required',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'This feature is available for premium members. Upgrade now to access exclusive benefits and analytics.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Later'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showMembershipOptions(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('View Plans'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMembershipOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose Membership',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMembershipOption(
                'Neo Select',
                '₹11,000',
                'Neo Select Customer Benefits - Memership Validity period of 10 Years \n - 5 Travel Coupons, each worth ₹3000/-',
                Icons.star_border,
                Colors.blue,
                context),
            _buildMembershipOption(
                'Premium Select Lite',
                '₹21,000',
                'Premium Select Lite Customer - Memership Validity period of 10 Years \n - 5 Travel Coupons, each worth ₹5000/-',
                Icons.star_half,
                Colors.purple,
                context),
            _buildMembershipOption(
                'Premium',
                '₹30,000',
                'Premium Customer - Memership Validity period of 10 Years \n - 10 Travel Coupons, each worth ₹3000/-',
                Icons.star,
                Colors.amber,
                context),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Contact us for more details:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone, size: 20, color: Colors.blue),
              title: Text('+91 8010892265 / 0832-2438989',
                  style: TextStyle(color: Colors.blue)),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.email, size: 20, color: Colors.blue),
              title: Text('support@uniqbizz.com',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipOption(String title, String price, String description,
      IconData icon, Color color, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 13)),
        trailing: Text(price,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        onTap: () {},
      ),
    );
  }

  Widget premiumWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    final topCustomers = filteredCustomers;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PremiumSelectCard(
        title: 'Premium Customer',
        description:
            'Use points and vouchers to unlock premium & standard travel experiences.',
      ),
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      CouponProgressBar(
        currentStep: eligibleCouponsCount,
        confettiController: _confettiController,
        scaleFactor: 0.8,
      ),
      const SizedBox(height: 16),
      ReferralTrackerCard(
        totalSteps: 10,
        currentStep: int.parse(customerController.registerCustomerTotal!),
        progressColor: Colors.green,
      ),
      buildTripOrRefundNote(userType: type, context: context),
      const SizedBox(height: 20),
      // if (_isDashboardInitialized)
      //   ImprovedLineChart(
      //     chartData: chartData,
      //     availableYears: availableYears,
      //     selectedYear: selectedYear,
      //     isLoading: isLoading,
      //     hasError: hasError,
      //     errorMessage: errorMessage,
      //     onYearChanged: (year) async {
      //       setState(() => selectedYear = year ?? '');
      //       await _loadChartData(year ?? '');
      //     },
      //   )
      // else
      const SizedBox(
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
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(thickness: 1, color: Colors.black26),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Top Customers Referrals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount: filteredCustomers.length.toString(),
              onSearchChanged: _onTopCustomerSearchChanged,
              onDateRangeChanged: _onTopCustomerDateChanged,
              onClearFilters: _onTopCustomerClearFilters,
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
                          ? const Center(child: CircularProgressIndicator())
                          : customerController.topCustomerRefererals.isEmpty
                              ? _buildEmptyState()
                              : PaginatedDataTable(
                                  columns: const [
                                    DataColumn(label: Text('Rank')),
                                    DataColumn(label: Text('Profile Picture')),
                                    DataColumn(label: Text('Full Name')),
                                    DataColumn(label: Text('Date Reg')),
                                    DataColumn(label: Text('Total CU Ref')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Active/Inactive')),
                                  ],
                                  source: CustTopReferralCustomers(
                                      customers: filteredCustomers),
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
                    )
                  : Column(
                      children: [
                        customerController.topCustomerRefererals.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: topCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = topCustomers[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      ? Colors.amber.withValues(
                                                          alpha: 0.2)
                                                      : Colors.grey.withValues(
                                                          alpha: 0.1),
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
                                              const SizedBox(width: 12),

                                              // Profile picture
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: getProfileImage(
                                                    customer.profilePic),
                                              ),
                                              const SizedBox(width: 12),

                                              // Name and date
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer.name ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
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

                                          const SizedBox(height: 16),

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

                                          const SizedBox(height: 12),

                                          // Status badge
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        customer.status!)
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: _getStatusColor(
                                                          customer.status!)
                                                      .withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                _getStatusText(
                                                    customer.status!),
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

  Widget premiumSelectLiteWidget(String type) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final customerController = context.read<CustomerController>();
    final String userCount = filteredCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.topCustomerRefererals.length.toString()
        : filteredCustomers.length.toString();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PremiumSelectCard(
        title: 'Premium Select Lite Customer',
        description:
            'Use points and vouchers to unlock premium & standard travel experiences.',
      ),
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      const NeoSelectBenefits(
        type: 'Premium Select Lite',
        amount: 21000,
        numberOfCoupons: 5,
        valueCoupons: 25000,
        saveAmt: 4000,
      ),
      const SizedBox(height: 16),
      buildTripOrRefundNote(userType: type, context: context),
      const SizedBox(height: 20),
      // if (_isDashboardInitialized)
      //   ImprovedLineChart(
      //     chartData: chartData,
      //     availableYears: availableYears,
      //     selectedYear: selectedYear,
      //     isLoading: isLoading,
      //     hasError: hasError,
      //     errorMessage: errorMessage,
      //     onYearChanged: (year) async {
      //       setState(() => selectedYear = year ?? '');
      //       await _loadChartData(year ?? '');
      //     },
      //   )
      // else
      const SizedBox(
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
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(thickness: 1, color: Colors.black26),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Top Customers Referral',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount: userCount,
              onSearchChanged: _onTopCustomerSearchChanged,
              onDateRangeChanged: _onTopCustomerDateChanged,
              onClearFilters: _onTopCustomerClearFilters,
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
                          ? const Center(child: CircularProgressIndicator())
                          : customerController.topCustomerRefererals.isEmpty
                              ? _buildEmptyState()
                              : PaginatedDataTable(
                                  columns: const [
                                    DataColumn(label: Text('Rank')),
                                    DataColumn(label: Text('Profile Picture')),
                                    DataColumn(label: Text('Full Name')),
                                    DataColumn(label: Text('Date Reg')),
                                    DataColumn(label: Text('Total CU Ref')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Active/Inactive')),
                                  ],
                                  source: CustTopReferralCustomers(
                                      customers: customerController
                                          .topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        customerController.topCustomerRefererals.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: customerController
                                    .topCustomerRefererals.length,
                                itemBuilder: (context, index) {
                                  final customer = customerController
                                      .topCustomerRefererals[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      ? Colors.amber.withValues(
                                                          alpha: 0.2)
                                                      : Colors.grey.withValues(
                                                          alpha: 0.1),
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
                                              const SizedBox(width: 12),

                                              // Profile picture
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: getProfileImage(
                                                    customer.profilePic),
                                              ),
                                              const SizedBox(width: 12),

                                              // Name and date
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer.name ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
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

                                          const SizedBox(height: 16),

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

                                          const SizedBox(height: 12),

                                          // Status badge
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        customer.status!)
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: _getStatusColor(
                                                          customer.status!)
                                                      .withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                _getStatusText(
                                                    customer.status!),
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
    final String userCount = filteredCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.topCustomerRefererals.length.toString()
        : filteredCustomers.length.toString();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PremiumSelectCard(
        title: 'Neo Select Customer',
        description:
            'Use points and vouchers to unlock premium & standard travel experiences.',
      ),
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      const NeoSelectBenefits(
        type: 'Neo Select',
        amount: 11000,
        numberOfCoupons: 5,
        valueCoupons: 15000,
        saveAmt: 4000,
      ),
      const SizedBox(height: 16),
      buildTripOrRefundNote(userType: type, context: context),
      const SizedBox(height: 20),

        ImprovedLineChart(
          chartData: chartData,
          availableYears: availableYears,
          selectedYear: selectedYear,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          onYearChanged: (year) async {
            setState(() => selectedYear = year ?? '');
            await _loadChartData(year ?? '');
          },
        ),
     
   
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(thickness: 1, color: Colors.black26),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Top Customers Referral',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black26),
            FilterBar(
              userCount: userCount,
              onSearchChanged: _onTopCustomerSearchChanged,
              onDateRangeChanged: _onTopCustomerDateChanged,
              onClearFilters: _onTopCustomerClearFilters,
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
                          ? const Center(child: CircularProgressIndicator())
                          : customerController.topCustomerRefererals.isEmpty
                              ? _buildEmptyState()
                              : PaginatedDataTable(
                                  columns: const [
                                    DataColumn(label: Text('Rank')),
                                    DataColumn(label: Text('Profile Picture')),
                                    DataColumn(label: Text('Full Name')),
                                    DataColumn(label: Text('Date Reg')),
                                    DataColumn(label: Text('Total CU Ref')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Active/Inactive')),
                                  ],
                                  source: CustTopReferralCustomers(
                                      customers: customerController
                                          .topCustomerRefererals),
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
                    )
                  : Column(
                      children: [
                        customerController.topCustomerRefererals.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: customerController
                                    .topCustomerRefererals.length,
                                itemBuilder: (context, index) {
                                  final customer = customerController
                                      .topCustomerRefererals[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      ? Colors.amber.withValues(
                                                          alpha: 0.2)
                                                      : Colors.grey.withValues(
                                                          alpha: 0.1),
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
                                              const SizedBox(width: 12),

                                              // Profile picture
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: getProfileImage(
                                                    customer.profilePic),
                                              ),
                                              const SizedBox(width: 12),

                                              // Name and date
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer.name ?? 'N/A',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
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

                                          const SizedBox(height: 16),

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

                                          const SizedBox(height: 12),

                                          // Status badge
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        customer.status!)
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: _getStatusColor(
                                                          customer.status!)
                                                      .withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                _getStatusText(
                                                    customer.status!),
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

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No referral customers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You haven't referred any customers yet",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCustomerType() async {
    try {
      custtype = await SharedPrefHelper().getCustomerType() ?? '';
      Logger.success('customer type: $custtype');
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
          builder: (context) {
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
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Dashboard...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
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
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog();

        if (shouldExit) {
          await SystemNavigator.pop();
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
                color: const Color.fromARGB(255, 81, 131, 246),
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: profileController.profilePic ?? '',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 30,
                          ),
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 30,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/default_profile.png'),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome, ${profileController.firstName}!',
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
                        Navigator.pop(
                            context); // Just close drawer if already on dashboard
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
                    if (custtype == 'Premium' ||
                        custtype == 'Premium Select Lite' ||
                        custtype == 'Neo Select' ||
                        custtype == 'Premium Select')
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Referral Customers'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewCustomersPage()),
                          );
                        },
                      ),
                    if (custtype == 'Premium' ||
                        custtype == 'Premium Select Lite' ||
                        custtype == 'Neo Select' ||
                        custtype == 'Premium Select')
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('My Wallet'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WalletDetailsPage()),
                          );
                        },
                      ),
                    if (custtype == 'Premium' ||
                        custtype == 'Premium Select Lite' ||
                        custtype == 'Neo Select' ||
                        custtype == 'Premium Select')
                      ExpansionTile(
                        title: const Text('Payouts'),
                        leading: const Icon(Icons.payment),
                        children: [
                          _drawerItem(
                              context,
                              Icons.inventory_2,
                              'Product Payout',
                              CustProductPayoutsPage(
                                userName:
                                    '${profileController.firstName} ${profileController.lastName}',
                              ),
                              padding: true),
                          _drawerItem(
                              context,
                              Icons.people_alt,
                              'Referral Payout',
                              CustomerReferralPayouts(
                                  username:
                                      '${profileController.firstName} ${profileController.lastName}'),
                              padding: true),
                        ],
                      ),

                    //commented order history since in v1 we wont be including it.

                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Order History'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderHistory()),
                        );
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: ListTile(
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
                    ),
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
        body: _isInitializing
            ? _buildLoadingState()
            : Consumer<CustomerController>(
                builder: (context, controller, child) {
                  return Stack(
                    children: [
                      // Main content
                      RefreshIndicator(
                        onRefresh: _onRefreshDashboard,
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16.0),
                            child: bodywidget(custtype)),
                      ),

                      // Confetti overlay (on top of everything)
                      if (custtype == 'Premium')
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConfettiWidget(
                                confettiController: _confettiController,
                                blastDirectionality:
                                    BlastDirectionality.explosive,
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
        const SizedBox(height: 4),
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/default_profile.png',
          fit: BoxFit.cover,
        ),
      );
    }

    final String imageUrl;
    if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
      imageUrl = profilePicture;
    } else {
      final newpath = extractPathSegment(profilePicture, 'profile_pic/');
      imageUrl = 'https://testca.uniqbizz.com/uploading/$newpath';
    }

    Logger.success('Final image URL: $imageUrl');

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: const BoxDecoration(
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
          'assets/default_profile.png',
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
