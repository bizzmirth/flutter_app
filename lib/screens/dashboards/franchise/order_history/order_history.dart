import 'package:bizzmirth_app/data_source/franchise_data_sources/franchise_top_tc_data_source.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String selectedView = 'Month';
  DateTime currentDate = DateTime.now();
  int selectedDay = 28;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<Map<String, Object>>> _tasks = {};

  String selectedFilter = 'All';
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  final List<String> filterOptions = [
    'All',
    'Pending',
    'Booked',
    'Canceled',
    'Refund'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderHistoryData();
    });
  }

  Future<void> getOrderHistoryData() async {}

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                        value: '₹0',
                        label: 'Pending Booking',
                        backgroundColor: const Color(0xFFE8E5FF),
                        iconColor: const Color(0xFF6B46C1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildStatCard(
                        icon: Icons.check_circle,
                        value: '₹0',
                        label: 'Completed Booking',
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
                        icon: Icons.hourglass_empty,
                        value: '₹0',
                        label: 'Pending Payment',
                        backgroundColor: const Color(0xFFE8E5FF),
                        iconColor: const Color(0xFF6B46C1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildStatCard(
                        icon: Icons.check_circle,
                        value: '₹0',
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
              SizedBox(
                height: 420,
                child: Stack(
                  children: [
                    Container(
                      height: 420,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: GestureDetector(
                        onLongPressStart: (details) {
                          _showRemoveEventDialog(_selectedDate);
                        },
                        child: TableCalendar(
                          focusedDay: _selectedDate,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month',
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDate = selectedDay;
                            });
                            _showAddTaskDialog(selectedDate: selectedDay);
                          },
                          selectedDayPredicate: (day) =>
                              isSameDay(day, _selectedDate),
                          eventLoader: (day) {
                            return (_tasks[DateTime(
                                        day.year, day.month, day.day)] ??
                                    [])
                                .map((event) {
                              return {
                                'name': event['name']?.toString() ??
                                    'Unnamed Event',
                                'type': event['type']?.toString() ?? 'other',
                              };
                            }).toList();
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: .5),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            markersMaxCount: 3,
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: events.map((event) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: event is Map<String, Object>
                                            ? _getEventColor(
                                                event['type']?.toString() ??
                                                    'other')
                                            : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ),

                    // Today button
                    Positioned(
                      top: 20,
                      right: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime.now();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 1),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Today',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    // Add event button
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: _showManualAddEventDialog,
                        backgroundColor: Colors.blue,
                        mini: true,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
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
                      child: _buildRecentBookings(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bookings Table Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: filterOptions
                          .map((filter) =>
                              _buildFilterTab(filter, selectedFilter == filter))
                          .toList(),
                    ),

                    // DateFilterWidget(),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1, color: Colors.black26),
                    const FilterBar(),
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
                          columnSpacing: 35,
                          dataRowMinHeight: 40,
                          columns: const [
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Ref. ID')),
                            DataColumn(label: Text('Ref. Name')),
                          ],
                          source: FranchiseTopTcDataSource(data: ordersBM),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
        // Add your filter logic here
        // _handleFilterChange(text);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    return ListView(
      children: [
        _buildBookingCard(
          destination: 'Shimla Manali',
          date: '2025-06-14',
          imageUrl:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&h=100&fit=crop',
          status: 'Completed',
          bookingId: '2025600023',
          customerName: 'Harbhajan Naik',
        ),
        const SizedBox(height: 8),
        _buildBookingCard(
          destination: 'Goa 4N5D',
          date: '2025-04-22',
          imageUrl:
              'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=150&h=100&fit=crop',
          status: 'Completed',
          bookingId: '2025400003',
          customerName: 'Harbhajan Naik',
        ),
      ],
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

  // Helper methods for calendar functionality
  void _showRemoveEventDialog(DateTime date) {
    // Implementation for removing events
  }

  void _showAddTaskDialog({required DateTime selectedDate}) {
    // Implementation for adding tasks
  }

  void _showManualAddEventDialog() {
    // Implementation for manually adding events
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'important':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
