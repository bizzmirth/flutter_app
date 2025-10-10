import 'dart:async';

import 'package:bizzmirth_app/controllers/customer_controller/cust_wallet_controller.dart';
import 'package:bizzmirth_app/data_source/customer_data_sources/cust_booking_points_data_source.dart';
import 'package:bizzmirth_app/data_source/customer_data_sources/cust_redeemable_table_data_source.dart';
import 'package:bizzmirth_app/models/customer_models/cust_booking_wallet_history_model.dart';
import 'package:bizzmirth_app/models/customer_models/cust_redeemable_wallet_history_model.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletDetailsPage extends StatefulWidget {
  const WalletDetailsPage({super.key});

  @override
  State<WalletDetailsPage> createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends State<WalletDetailsPage> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  int _currentColorIndex = 0;
  Timer? _timer;
  int _rowsPerPage = 5;

  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? toDateError;

  List<CustRedeemableWalletHistory> filteredRedeemableHistory = [];
  List<CustBookingWalletHistory> filteredBookingHistory = [];

  String? _customerType;

  @override
  void initState() {
    super.initState();
    getCustomerWalletDetails();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  void _initializeFilterRedeemableHistory() {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);
    setState(() {
      filteredRedeemableHistory =
          List.from(controller.custRedeemableWalletHistory);
    });
  }

  void _initializeFilterBookingHistory() {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);
    setState(() {
      filteredBookingHistory = List.from(controller.custBookingWalletHistory);
    });
  }

  Future<void> _onRefresh() async {
    await getCustomerWalletDetails();
    _initializeFilterRedeemableHistory();
    _initializeFilterBookingHistory();
  }

  Future<void> getCustomerWalletDetails() async {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);
    _customerType = await SharedPrefHelper().getCurrentUserCustId();
    await controller.apiGetWalletDetails().then((_) {
      _initializeFilterRedeemableHistory();
      _initializeFilterBookingHistory();
    });
  }

  void _onRedeemableSearchChanged(String searchTerm) {
    setState(() {
      searchController.text = searchTerm;
    });
    _applyRedeemableFilters(searchTerm: searchTerm);
  }

  void _onBookingSearchChanged(String searchTerm) {
    setState(() {
      searchController.text = searchTerm;
    });
    _applyBookingFilters(searchTerm: searchTerm);
  }

  void _onRedeemableDateRangeChanged(DateTime? from, DateTime? to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
    _applyRedeemableFilters(fromDate: from, toDate: to);
  }

  void _onBookingDateRangeChanged(DateTime? from, DateTime? to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
    _applyBookingFilters(fromDate: from, toDate: to);
  }

  void _onRedeemableClearFilters() {
    setState(() {
      searchController.clear();
      fromDate = null;
      toDate = null;
    });
    _initializeFilterRedeemableHistory();
  }

  void _onBookingClearFilters() {
    setState(() {
      searchController.clear();
      fromDate = null;
      toDate = null;
    });
    _initializeFilterBookingHistory();
  }

  void _applyRedeemableFilters(
      {String? searchTerm, DateTime? fromDate, DateTime? toDate}) {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);

    if (controller.custRedeemableWalletHistory.isEmpty) {
      return;
    }

    setState(() {
      filteredRedeemableHistory =
          controller.custRedeemableWalletHistory.where((walletHistory) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter - check multiple fields
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final String searchTermLower = searchTerm.toLowerCase();
          matchesSearch = (walletHistory.message
                      ?.toLowerCase()
                      .contains(searchTermLower) ??
                  false) ||
              (walletHistory.amount?.toString().contains(searchTermLower) ??
                  false) ||
              (walletHistory.status?.toLowerCase().contains(searchTermLower) ??
                  false);
        }

        // Date range filter - assuming earnedOn is the date field
        if (fromDate != null || toDate != null) {
          if (walletHistory.date != null && walletHistory.date!.isNotEmpty) {
            try {
              // Adjust the date format according to your data format
              // Common formats: "dd-MM-yyyy", "yyyy-MM-dd", "MM/dd/yyyy"
              final DateFormat inputFormat =
                  DateFormat('dd-MM-yyyy'); // Adjust this format as needed
              final DateTime walletDate =
                  inputFormat.parse(walletHistory.date!);

              if (fromDate != null && walletDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  walletDate.isAfter(toDate.add(const Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              // If date parsing fails, exclude from results when date filter is applied
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            // If no date and date filter is applied, exclude from results
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  void _applyBookingFilters({
    String? searchTerm,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final controller =
        Provider.of<CustWalletController>(context, listen: false);

    if (controller.custBookingWalletHistory.isEmpty) {
      return;
    }

    setState(() {
      filteredBookingHistory =
          controller.custBookingWalletHistory.where((walletHistory) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // 🔎 Search filter - check multiple fields
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final String searchTermLower = searchTerm.toLowerCase();
          matchesSearch = (walletHistory.message
                      ?.toLowerCase()
                      .contains(searchTermLower) ??
                  false) ||
              (walletHistory.amount?.toString().contains(searchTermLower) ??
                  false) ||
              (walletHistory.status?.toLowerCase().contains(searchTermLower) ??
                  false);
        }

        // 📅 Date range filter
        if (fromDate != null || toDate != null) {
          if (walletHistory.date != null && walletHistory.date!.isNotEmpty) {
            try {
              // Adjust the date format according to your API
              final DateFormat inputFormat = DateFormat('dd-MM-yyyy');
              final DateTime walletDate =
                  inputFormat.parse(walletHistory.date!);

              if (fromDate != null && walletDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  walletDate.isAfter(toDate.add(const Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              // Exclude if parsing fails when date filter applied
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            // No date → exclude if filter applied
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Widget _walletHistoryListView(CustWalletController controller) {
    final walletHistory = filteredRedeemableHistory.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? controller.custRedeemableWalletHistory
        : filteredRedeemableHistory;
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
        case 'success':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'failed':
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    if (walletHistory.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No redeemable wallet history found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: walletHistory.length,
      itemBuilder: (context, index) {
        final payout = walletHistory[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: index.isEven ? Colors.grey[50] : Colors.white,
              child: InkWell(
                onTap: () {
                  // Add tap functionality if needed
                },
                splashColor: Colors.blue.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with SR No. and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "SR No. #${(index + 1).toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '     Date \n${payout.date!}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Payout Message
                      Text(
                        'Points Message',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payout.message!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Payout Amount and Status in a row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Points Value',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                payout.amount!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Status      ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(payout.status!),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  payout.status!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bookingWalletHistoryListView(CustWalletController controller) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
        case 'success':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'failed':
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    if (controller.custBookingWalletHistory.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No booking points wallet history found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.custBookingWalletHistory.length,
      itemBuilder: (context, index) {
        final payout = controller.custBookingWalletHistory[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: index.isEven ? Colors.grey[50] : Colors.white,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.blue.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "SR No. #${(index + 1).toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '     Date \n${payout.date!}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Payout Message
                      Text(
                        'Points Message',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payout.message!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Payout Amount and Status in a row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Points Value',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                payout.amount!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Status      ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(payout.status!),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  payout.status!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600; // breakpoint
    return Consumer<CustWalletController>(
        builder: (context, controller, child) {
      final String userCount = filteredRedeemableHistory.isEmpty &&
              (searchController.text.isEmpty &&
                  fromDate == null &&
                  toDate == null)
          ? controller.custRedeemableWalletHistory.length.toString()
          : filteredRedeemableHistory.length.toString();
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'My Wallet',
            style: Appwidget.poppinsAppBarTitle(),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: 1, color: Colors.black26),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Wallet Options',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.black26),

                        const SizedBox(height: 16),

                        // Wallet Options
                        Row(
                          children: [
                            if (_customerType == 'Prime' &&
                                _customerType == 'Premium')
                              Expanded(
                                child: _buildWalletOptionCard(
                                  title: 'Redeemable Count',
                                  amount: controller.referenceCountTotal ?? '',
                                  thisMonthAmount:
                                      controller.referenceCountThisMonth ?? '',
                                  icon: Icons.person_outline,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopUpWalletPage(
                                                title: 'Top Up Wallet',
                                              )),
                                    );
                                  },
                                  isClickable: false,
                                ),
                              )
                            else ...[
                              Expanded(
                                child: _buildWalletOptionCard(
                                  title: 'Redeemable Count',
                                  amount: controller.referenceCountTotal ?? '',
                                  thisMonthAmount:
                                      controller.referenceCountThisMonth ?? '',
                                  icon: Icons.person_outline,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopUpWalletPage(
                                                title: 'Top Up Wallet',
                                              )),
                                    );
                                  },
                                  isClickable: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildWalletOptionCard(
                                  title: 'Bookings Wallet',
                                  amount:
                                      controller.bookingPointsCountTotal ?? '',
                                  icon: Icons.people_outline,
                                  thisMonthAmount:
                                      controller.bookingPointsCountThisMonth ??
                                          '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopUpWalletPage(
                                                title: 'Referral Wallet',
                                              )),
                                    );
                                  },
                                  isClickable: false,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 20),
                        if (_customerType == 'Prime' &&
                            _customerType == 'Premium')
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Redeemable Wallet History',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                FilterBar(
                                  userCount: userCount,
                                  onSearchChanged: _onRedeemableSearchChanged,
                                  onDateRangeChanged:
                                      _onRedeemableDateRangeChanged,
                                  onClearFilters: _onRedeemableClearFilters,
                                ),
                                isTablet
                                    ? Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height:
                                              (_rowsPerPage * dataRowHeight) +
                                                  headerHeight +
                                                  paginationHeight,
                                          child: PaginatedDataTable(
                                            columns: const [
                                              DataColumn(label: Text('SR No.')),
                                              DataColumn(
                                                  label:
                                                      Text('Payout Message')),
                                              DataColumn(
                                                  label: Text('Payout Amount')),
                                              DataColumn(
                                                  label: Text('Earned ON')),
                                              DataColumn(label: Text('Status')),
                                            ],
                                            source: CustRedeemableTableDataSource(
                                                filteredRedeemableHistory
                                                            .isEmpty &&
                                                        (searchController
                                                                .text.isEmpty &&
                                                            fromDate == null &&
                                                            toDate == null)
                                                    ? controller
                                                        .custRedeemableWalletHistory
                                                    : filteredRedeemableHistory),
                                            rowsPerPage: _rowsPerPage,
                                            availableRowsPerPage: const [
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
                                    : _walletHistoryListView(controller),
                              ],
                            ),
                          )
                        else ...[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Redeemable Wallet History',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                FilterBar(
                                  userCount: userCount,
                                  onSearchChanged: _onRedeemableSearchChanged,
                                  onDateRangeChanged:
                                      _onRedeemableDateRangeChanged,
                                  onClearFilters: _onRedeemableClearFilters,
                                ),
                                isTablet
                                    ? Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height:
                                              (_rowsPerPage * dataRowHeight) +
                                                  headerHeight +
                                                  paginationHeight,
                                          child: PaginatedDataTable(
                                            columns: const [
                                              DataColumn(label: Text('SR No.')),
                                              DataColumn(
                                                  label:
                                                      Text('Payout Message')),
                                              DataColumn(
                                                  label: Text('Payout Amount')),
                                              DataColumn(
                                                  label: Text('Earned ON')),
                                              DataColumn(label: Text('Status')),
                                            ],
                                            source: CustRedeemableTableDataSource(
                                                filteredRedeemableHistory
                                                            .isEmpty &&
                                                        (searchController
                                                                .text.isEmpty &&
                                                            fromDate == null &&
                                                            toDate == null)
                                                    ? controller
                                                        .custRedeemableWalletHistory
                                                    : filteredRedeemableHistory),
                                            rowsPerPage: _rowsPerPage,
                                            availableRowsPerPage: const [
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
                                    : _walletHistoryListView(controller),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Booking Points Wallet History',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Divider(
                                    thickness: 1, color: Colors.black26),
                                FilterBar(
                                  userCount: controller
                                      .custBookingWalletHistory.length
                                      .toString(),
                                  onSearchChanged: _onBookingSearchChanged,
                                  onDateRangeChanged:
                                      _onBookingDateRangeChanged,
                                  onClearFilters: _onBookingClearFilters,
                                ),
                                isTablet
                                    ? Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height:
                                              (_rowsPerPage * dataRowHeight) +
                                                  headerHeight +
                                                  paginationHeight,
                                          child: PaginatedDataTable(
                                            columns: const [
                                              DataColumn(label: Text('SR No.')),
                                              DataColumn(
                                                  label:
                                                      Text('Points Message')),
                                              DataColumn(
                                                  label: Text('Points Value')),
                                              DataColumn(
                                                  label: Text('Added On')),
                                              DataColumn(label: Text('Status')),
                                            ],
                                            source: CustBookingPointsDataSource(
                                                controller
                                                    .custBookingWalletHistory),
                                            rowsPerPage: _rowsPerPage,
                                            availableRowsPerPage: const [
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
                                    : _bookingWalletHistoryListView(controller),
                              ],
                            ),
                          ),
                        ]

                        // Quick Actions
                        // Container(
                        //   width: double.infinity,
                        //   padding: EdgeInsets.all(20),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(12),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.05),
                        //         blurRadius: 8,
                        //         offset: Offset(0, 2),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         'Quick Actions',
                        //         style: TextStyle(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.grey[800],
                        //         ),
                        //       ),
                        //       SizedBox(height: 16),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //         children: [
                        //           _buildQuickActionButton(
                        //             icon: Icons.add,
                        //             label: 'Add Money',
                        //             onTap: () {},
                        //           ),
                        //           _buildQuickActionButton(
                        //             icon: Icons.send,
                        //             label: 'Transfer',
                        //             onTap: () {},
                        //           ),
                        //           _buildQuickActionButton(
                        //             icon: Icons.history,
                        //             label: 'History',
                        //             onTap: () {},
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Widget _buildWalletOptionCard({
    required String title,
    required String amount,
    required IconData icon,
    required VoidCallback onTap,
    required String thisMonthAmount,
    bool isClickable = true,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colors[_currentColorIndex].withValues(alpha: 0.8),
              colors[(_currentColorIndex + 1) % colors.length]
                  .withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row - Title and clickable arrow
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  if (isClickable)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Second row - Icon and main amount
              Row(
                children: [
                  Icon(icon, size: 28, color: Colors.white),
                  const Spacer(),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Third row - "This Month" text and amount
              Row(
                children: [
                  Text(
                    'This Month',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    thisMonthAmount,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
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

  // Widget _buildQuickActionButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: colors[_currentColorIndex].withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(
  //             icon,
  //             size: 24,
  //             color: colors[_currentColorIndex],
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
