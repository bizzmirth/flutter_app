import 'package:bizzmirth_app/controllers/tc_controller/tc_order_history_controller.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String selectedView = 'Month';
  DateTime currentDate = DateTime.now();
  int selectedDay = 28;
  final Map<DateTime, List<Map<String, Object>>> _tasks = {};

  String selectedFilter = 'All';
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  DateTime? fromDate;
  DateTime? toDate;

  final List<String> filterOptions = AppData.orderHistoryFilterOptions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Consumer<TcOrderHistoryController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.hourglass_empty,
                            value: '0',
                            label: 'Pending Booking',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF6B46C1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.flight_takeoff,
                            value: '0',
                            label: 'In Transit Booking',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.check_circle,
                            value: '0',
                            // "₹${double.tryParse(controller.pendingPaymentAmt ?? "0")?.toStringAsFixed(2)}",
                            label: 'Completed Booking',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF6B46C1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.cancel,
                            value: '0',
                            // "₹${double.tryParse(controller.cancelledBookingCount ?? '0')?.toStringAsFixed(2)}",
                            label: 'Canceled Booking',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.hourglass_bottom,
                            value: '0',
                            // "₹${double.tryParse(controller.pendingPaymentAmt ?? "0")?.toStringAsFixed(2)}",
                            label: 'Pending Payment',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF6B46C1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildStatCard(
                            icon: Icons.check_circle,
                            value: '0',
                            // "₹${double.tryParse(controller.completedPaymentAmt ?? '0')?.toStringAsFixed(2)}",
                            label: 'Completed Payment',
                            backgroundColor: const Color(0xFFE8E5FF),
                            iconColor: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Colors.black26),

                  // ======= 2. Calendar =======
                  //  CalendarWidget(
                  //       initialDate: DateTime.now(),
                  //       onDateSelected: (selectedDate) {
                  //         final formatted =
                  //             DateFormat('yyyy-MM-dd').format(selectedDate);
                  //         controller.apiGetRecentBookings(selectedDate: formatted);
                  //       },
                  //       onTodayPressed: () {
                  //         final formatted =
                  //             DateFormat('yyyy-MM-dd').format(DateTime.now());
                  //         controller.apiGetRecentBookings(selectedDate: formatted);
                  //       },
                  //       onClearPressed: () {
                  //         controller.apiGetRecentBookings(); // without filter
                  //       },
                  //       eventLoader: (day) {
                  //         return _tasks[DateTime(day.year, day.month, day.day)] ??
                  //             [];
                  //       },
                  //     ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Colors.black26),

                  // ======= 3. Recent Bookings =======
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recent Bookings',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1),
                        SizedBox(
                          height: 350, // Adjust as needed
                          child: _buildRecentBookings(controller),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bookings Table Section
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBookings(TcOrderHistoryController controller) {
    final bookings = controller.tcOrderHistoryRecentBookings;

    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          'No recent bookings available.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Column(
          children: [
            _buildBookingCard(
              destination: booking.packageName ?? 'Unknown Package',
              date: booking.start ?? '',
              imageUrl: booking.packageImage?.isNotEmpty == true
                  ? 'https://testca.uniqbizz.com/bizzmirth_apis/uploading/${booking.packageImage}'
                  : 'https://via.placeholder.com/150',
              status: booking.status == '0'
                  ? 'Pending'
                  : booking.status == '1'
                      ? 'Completed'
                      : 'Cancelled',
              bookingId: booking.orderId ?? '',
              customerName: booking.customerName ?? 'Customer',
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildBookingCard({
    required String destination,
    required String date,
    required String imageUrl,
    required String status,
    required String bookingId,
    required String customerName,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                destination,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 30,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.image,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 10),
                        children: [
                          TextSpan(
                            text: customerName,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' has ',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          TextSpan(
                            text: status,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' the package for ',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          TextSpan(
                            text: destination,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' with ',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          TextSpan(
                            text: 'Booking ID: $bookingId',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// TODO: complete the ui of the tc order history
