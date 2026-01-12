import 'package:bizzmirth_app/controllers/tc_controller/tc_product_payout_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_product_payouts_data_source/tc_payout_commmon_data_source.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_product_payouts_data_source/tc_product_all_payout_data_source.dart';
import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_product_payout_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class TCProductPayoutsPage extends StatefulWidget {
  const TCProductPayoutsPage({super.key});

  @override
  State<TCProductPayoutsPage> createState() => _TCProductPayoutsPageState();
}

class _TCProductPayoutsPageState extends State<TCProductPayoutsPage> {
  String selectedDate = 'Select month, year';
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  String? username;
  String? userId;
  DateTime? _selectedDateTime;

  Future<void> _selectDate(BuildContext context) async {
    final controller =
        Provider.of<TcProductPayoutController>(context, listen: false);
    final DateTime now = DateTime.now();
    final DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDate: _selectedDateTime ?? now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = picked;
        selectedDate = DateFormat('MMMM, yyyy').format(picked);
      });
      await controller.apiGetTotalProductPayouts(
          picked.month.toString(), picked.year.toString());

      Logger.success('Selected month-year: $selectedDate');
    }
  }

  Future<void> getData() async {
    // userId = await SharedPrefHelper().getCurrentUserCustId();
    final userDetails = await SharedPrefHelper().getLoginResponse();
    userId = userDetails?.userId;
    username =
        "${userDetails?.userFname ?? ''} ${userDetails?.userLname ?? ''}";
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('MMMM, yyyy').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getData();
      },
    );
  }

  void showPayoutDialog(
    BuildContext context,
    String payoutType,
    String date,
    String amount,
    String userId,
    String userName,
    TcProductPayoutController controller,
  ) {
    List<TcProductPayoutModel> getPayoutList() {
      switch (payoutType.toLowerCase()) {
        case 'previous payouts':
        case 'previous payout':
          return controller.previousProductPayouts;

        case 'next payout':
        case 'next payouts':
        case 'next month payout':
        case 'next month payouts':
          return controller.nextProductPayouts;

        case 'total payout':
        case 'total payouts':
        case 'all payouts':
          return controller.totalProductPayouts;

        default:
          return controller.totalProductPayouts;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        final payoutList = getPayoutList();
        final isMobile = MediaQuery.of(context).size.width < 600;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10.0 : 40.0,
            vertical: 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: isMobile
                  ? MediaQuery.of(context).size.width * 0.95
                  : MediaQuery.of(context).size.width * 0.9,
              height:
                  isMobile ? null : MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          payoutType,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payout summary cards
                  if (isMobile)
                    Column(
                      children: [
                        _buildPayoutCard(payoutType, amount, date),
                        const SizedBox(height: 12),
                        _buildUserCard(userId, userName, amount),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _buildPayoutCard(payoutType, amount, date)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'ID: $userId',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Name: $userName',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: $userName',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            'Rs.',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            amount.replaceAll('Rs', ''),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                  const SizedBox(height: 16),

                  const Divider(thickness: 1, color: Colors.black26),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        '$payoutType Details',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  const FilterBar(),
                  const SizedBox(height: 8),

                  // Payout list
                  if (payoutList.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No payout data available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ] else if (isMobile) ...[
                    Column(
                      children: [
                        for (int i = 0; i < payoutList.length; i++)
                          _buildPayoutItem(
                              payoutList[i], i == payoutList.length - 1),
                      ],
                    ),
                  ] else ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              child: payoutList.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'No payout data available',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    )
                                  : PaginatedDataTable(
                                      columnSpacing: 50,
                                      dataRowMinHeight: 40,
                                      columns: const [
                                        DataColumn(label: Text('Date')),
                                        DataColumn(
                                            label: Text('Payout Details')),
                                        DataColumn(label: Text('Markup')),
                                        DataColumn(label: Text('Amount')),
                                        DataColumn(label: Text('TDS')),
                                        DataColumn(
                                            label: Text('Total Payable')),
                                        DataColumn(label: Text('Remarks')),
                                      ],
                                      source: TcPayoutCommmonDataSource(
                                          payoutList: payoutList),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Close button
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayoutItem(TcProductPayoutModel payout, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${payout.date}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Payout Details: ${payout.message}'),
          const SizedBox(height: 4),
          Text('Amount: Rs. ${payout.amount}'),
          const SizedBox(height: 4),
          Text('TDS: Rs. ${payout.tds}'),
          const SizedBox(height: 4),
          Text('Total Payable: Rs. ${payout.totalPayable}'),
          const SizedBox(height: 4),
          Text('Remarks: ${payout.status}'),
        ],
      ),
    );
  }

  Widget _buildPayoutCard(String payoutType, String amount, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payoutType,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String userId, String userName, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ID: $userId',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Name: $userName',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $userName',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Rs.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        amount.replaceAll('Rs. ', ''),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Payouts',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<TcProductPayoutController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastHelper.showErrorToast(title: controller.error!);
            });
          }
          return SingleChildScrollView(
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
                        'Payouts:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: payoutCard(
                          'Previous Payout',
                          '${getMonthName(controller.prevDateMonth)}, ${controller.prevDateYear}',
                          'Rs. ${controller.totalPreviousAmount}/-',
                          'Paid',
                          Colors.green.shade100,
                          controller,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: payoutCard(
                          'Next Payout',
                          '${getMonthName(controller.nextDateMonth)}, ${controller.nextDateYear}',
                          'Rs. ${controller.totalNextAmount}/-',
                          'Pending',
                          Colors.orange.shade100,
                          controller,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  totalPayoutCard(
                      controller.totalPayoutAmount.toString(), controller),
                  const SizedBox(height: 50),
                  const Divider(thickness: 1, color: Colors.black26),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'All Payouts:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black26),
                  const FilterBar2(),
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
                        columnSpacing: 50,
                        dataRowMinHeight: 40,
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Payout Details')),
                          DataColumn(label: Text('Markup')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('TDS')),
                          DataColumn(label: Text('Total Payable')),
                          DataColumn(label: Text('Remark')),
                        ],
                        source: TcProductAllPayoutDataSource(
                          controller.allProductPayouts,
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
        },
      ),
    );
  }

  Widget payoutCard(String title, String date, String amount, String status,
      Color statusColor, TcProductPayoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: statusColor, borderRadius: BorderRadius.circular(4)),
                child: Text(status,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showPayoutDialog(context, title, date, amount,
                    userId!, username!, controller),
                child: const Text(
                  'View Payout',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading Payout...')),
                ),
                child: const Icon(Icons.download, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalPayoutCard(
      String? totalPayout, TcProductPayoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Payout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('Rs. $totalPayout/-',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => showPayoutDialog(
                        context,
                        'Total Payout',
                        selectedDate,
                        'Rs. $totalPayout/-',
                        userId!,
                        username ?? '',
                        controller),
                    child: const Text(
                      'View Payout',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading Payout...')),
                    ),
                    child: const Icon(Icons.download, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDate,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
