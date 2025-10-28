import 'package:bizzmirth_app/controllers/tc_controller/tc_cu_payout_controller.dart';
import 'package:bizzmirth_app/data_source/tc_data_sources/tc_cu_payouts_data_source/tc_cu_membership_all_data_source.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TcCuMembershipPayouts extends StatefulWidget {
  const TcCuMembershipPayouts({super.key});

  @override
  State<TcCuMembershipPayouts> createState() => _TcCuMembershipPayoutsState();
}

class _TcCuMembershipPayoutsState extends State<TcCuMembershipPayouts> {
  String selectedDate = 'Select month, year';
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('MMMM, yyyy').format(picked);
      });
    }
  }

  // void showPayoutDialog(
  //     BuildContext context,
  //     String payoutType,
  //     String date,
  //     String amount,
  //     String userId,
  //     String userName,
  //     CustReferralPayoutController controller) {
  //   List<CustReferralPayoutModel> getPayoutList() {
  //     switch (payoutType.toLowerCase()) {
  //       case 'previous payouts':
  //       case 'previous payout':
  //         return controller.previousMonthAllPayouts;
  //       case 'next payout':
  //       case 'next payouts':
  //       case 'next month payout':
  //       case 'next month payouts':
  //         return controller.nextMonthAllPayouts;
  //       case 'total payout':
  //       case 'total payouts':
  //       case 'all payouts':
  //         return controller.totalAllPayouts;
  //       default:
  //         return controller.totalAllPayouts;
  //     }
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final payoutList = getPayoutList();
  //       final isMobile = MediaQuery.of(context).size.width < 600;

  //       return Dialog(
  //         insetPadding: EdgeInsets.symmetric(
  //           horizontal: isMobile ? 10.0 : 40.0,
  //           vertical: 24.0,
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: SingleChildScrollView(
  //           child: Container(
  //             width: isMobile
  //                 ? MediaQuery.of(context).size.width * 0.95
  //                 : MediaQuery.of(context).size.width * 0.9,
  //             height:
  //                 isMobile ? null : MediaQuery.of(context).size.height * 0.8,
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Header with close button
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         payoutType,
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                     IconButton(
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       icon: const Icon(Icons.close),
  //                       padding: EdgeInsets.zero,
  //                       constraints: const BoxConstraints(),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Payout summary cards
  //                 if (isMobile)
  //                   Column(
  //                     children: [
  //                       _buildPayoutCard(payoutType, amount, date),
  //                       const SizedBox(height: 12),
  //                       _buildUserCard(userId, userName, amount),
  //                     ],
  //                   )
  //                 else
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                           child: _buildPayoutCard(payoutType, amount, date)),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: Container(
  //                           padding: const EdgeInsets.all(16),
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: Colors.grey),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: Column(
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Container(
  //                                       padding: const EdgeInsets.all(8),
  //                                       decoration: BoxDecoration(
  //                                         border: Border.all(),
  //                                         borderRadius:
  //                                             BorderRadius.circular(4),
  //                                       ),
  //                                       child: Text(
  //                                         'ID: $userId',
  //                                         style: const TextStyle(fontSize: 12),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 8),
  //                                 ],
  //                               ),
  //                               const SizedBox(height: 8),
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Container(
  //                                       padding: const EdgeInsets.all(8),
  //                                       decoration: BoxDecoration(
  //                                         border: Border.all(),
  //                                         borderRadius:
  //                                             BorderRadius.circular(4),
  //                                       ),
  //                                       child: Text(
  //                                         'Name: $userName',
  //                                         style: const TextStyle(fontSize: 12),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               const SizedBox(height: 12),
  //                               Container(
  //                                 width: double.infinity,
  //                                 padding: const EdgeInsets.all(12),
  //                                 decoration: BoxDecoration(
  //                                     border: Border.all(),
  //                                     borderRadius: BorderRadius.circular(4)),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       'Name: $userName',
  //                                       style: const TextStyle(fontSize: 14),
  //                                     ),
  //                                     const SizedBox(height: 8),
  //                                     Row(
  //                                       children: [
  //                                         Text(
  //                                           'Rs.',
  //                                           style: TextStyle(
  //                                               fontSize: 14,
  //                                               color: Colors.grey.shade600),
  //                                         ),
  //                                         const SizedBox(width: 5),
  //                                         Text(
  //                                           amount.replaceAll('Rs', ''),
  //                                           style: const TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold),
  //                                         )
  //                                       ],
  //                                     )
  //                                   ],
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),

  //                 const SizedBox(height: 16),

  //                 const Divider(thickness: 1, color: Colors.black26),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 8),
  //                   child: Center(
  //                     child: Text(
  //                       '$payoutType Details',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const Divider(thickness: 1, color: Colors.black26),
  //                 const FilterBar(),
  //                 const SizedBox(height: 8),

  //                 // Payout list
  //                 if (payoutList.isEmpty) ...[
  //                   const Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 20),
  //                     child: Center(
  //                       child: Text(
  //                         'No payout data available',
  //                         style: TextStyle(fontSize: 16, color: Colors.grey),
  //                       ),
  //                     ),
  //                   ),
  //                 ] else if (isMobile) ...[
  //                   Column(
  //                     children: [
  //                       for (int i = 0; i < payoutList.length; i++)
  //                         _buildPayoutItem(
  //                             payoutList[i], i == payoutList.length - 1),
  //                     ],
  //                   ),
  //                 ] else ...[
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Divider(thickness: 1, color: Colors.black26),
  //                         Card(
  //                           elevation: 5,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: SizedBox(
  //                             height: (_rowsPerPage * dataRowHeight) +
  //                                 headerHeight +
  //                                 paginationHeight,
  //                             child: payoutList.isEmpty
  //                                 ? Center(
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(20.0),
  //                                       child: Text(
  //                                         'No payout data available',
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           color: Colors.grey[600],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : PaginatedDataTable(
  //                                     columnSpacing: 50,
  //                                     dataRowMinHeight: 40,
  //                                     columns: const [
  //                                       DataColumn(label: Text('Date')),
  //                                       DataColumn(
  //                                           label: Text('Payout Details')),
  //                                       DataColumn(label: Text('Amount')),
  //                                       DataColumn(label: Text('TDS')),
  //                                       DataColumn(
  //                                           label: Text('Total Payable')),
  //                                       DataColumn(label: Text('Remarks')),
  //                                     ],
  //                                     source: CustReferenceAllPayoutDataSource(
  //                                         payoutList),
  //                                     rowsPerPage: _rowsPerPage,
  //                                     availableRowsPerPage: const [
  //                                       5,
  //                                       10,
  //                                       15,
  //                                       20,
  //                                       25
  //                                     ],
  //                                     onRowsPerPageChanged: (value) {
  //                                       if (value != null) {
  //                                         setState(() {
  //                                           _rowsPerPage = value;
  //                                         });
  //                                       }
  //                                     },
  //                                     arrowHeadColor: Colors.blue,
  //                                   ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],

  //                 // Close button
  //                 const SizedBox(height: 16),
  //                 Align(
  //                   alignment: Alignment.centerRight,
  //                   child: ElevatedButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.blue,
  //                       foregroundColor: Colors.white,
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 24,
  //                         vertical: 10,
  //                       ),
  //                     ),
  //                     child: const Text('Close'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CU Membership Payouts',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<TcCuPayoutController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                        'CU Membership Payouts:',
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
                              'Rs. ${controller.previousPayout!.totalPreviousPayout}/-',
                              'Paid',
                              Colors.green.shade100)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: payoutCard(
                              'Next Payout',
                              '${getMonthName(controller.nextDateMonth)}, ${controller.nextDateYear}',
                              'Rs. 0/-',
                              'Pending',
                              Colors.orange.shade100)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  totalPayoutCard(),
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
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('TDS')),
                          DataColumn(label: Text('Total Payable')),
                          DataColumn(label: Text('Remarks')),
                        ],
                        source: TcCuMembershipAllDataSource(
                            controller.tcCuAllPayment),
                        rowsPerPage: _rowsPerPage,
                        availableRowsPerPage: const [5, 10, 15, 20, 25],
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
      Color statusColor) {
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
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View Payout Clicked!')),
                ),
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

  Widget totalPayoutCard() {
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
              const Text('Rs. 0/-',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('View Payout Clicked!')),
                    ),
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
