import 'package:bizzmirth_app/services/widgets_support.dart';
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
              // ======= 1. Top 4 Cards =======
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.hourglass_empty,
                        value: "0",
                        label: "Pending Booking",
                        backgroundColor: const Color(0xFFE8E5FF),
                        iconColor: const Color(0xFF6B46C1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        value: "2",
                        label: "Completed Booking",
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
                      child: _buildStatCard(
                        icon: Icons.hourglass_empty,
                        value: "₹9953.54",
                        label: "Pending Payment",
                        backgroundColor: const Color(0xFFE8E5FF),
                        iconColor: const Color(0xFF6B46C1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        value: "₹9780.3",
                        label: "Completed Payment",
                        backgroundColor: const Color(0xFFE8E5FF),
                        iconColor: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.black26),

              // ======= 2. Calendar =======
              SizedBox(
                height: 420,
                child: Stack(
                  children: [
                    Container(
                      height: 420,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
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
                          calendarFormat: CalendarFormat.month,
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
                              if (event is Map<String, Object>) {
                                return {
                                  "name": event["name"]?.toString() ??
                                      "Unnamed Event",
                                  "type": event["type"]?.toString() ?? "other",
                                };
                              }
                              return {"name": "Invalid Event", "type": "other"};
                            }).toList();
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: event is Map<String, Object>
                                            ? _getEventColor(
                                                event["type"]?.toString() ??
                                                    "other")
                                            : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return SizedBox.shrink();
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Today",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    // Add event button
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          _showManualAddEventDialog();
                        },
                        backgroundColor: Colors.blue,
                        mini: true,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.black26),

              // ======= 3. Recent Bookings =======
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recent Bookings",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Divider(thickness: 1),
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
                    // Filter Tabs
                    Wrap(
                      spacing: 16,
                      children: [
                        _buildFilterTab("All", true),
                        _buildFilterTab("Pending", false),
                        _buildFilterTab("Booked", false),
                        _buildFilterTab("Canceled", false),
                        _buildFilterTab("Refund", false),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date Range Picker
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            "July 2, 2025 - July 31, 2025",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Show entries and Search
                    Row(
                      children: [
                        const Text("Show 10 entries",
                            style: TextStyle(fontSize: 14)),
                        const Spacer(),
                        SizedBox(
                          width: 150,
                          height: 32,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Data Table
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Sr. No.')),
                          DataColumn(label: Text('Booking ID')),
                          DataColumn(label: Text('Tour Date')),
                          DataColumn(label: Text('Package Name')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Travel Consultant')),
                          DataColumn(label: Text('Payment Status')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text('1')),
                            const DataCell(Text('2025600023')),
                            const DataCell(Text('2025-06-14')),
                            const DataCell(Text('Shimla Manali')),
                            const DataCell(Text('Harbhajan Naik')),
                            const DataCell(Text('Travel Agent 1')),
                            DataCell(
                                _buildStatusChip('Completed', Colors.green)),
                            DataCell(
                                _buildStatusChip('Completed', Colors.green)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.visibility, size: 16),
                                    onPressed: () {},
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 16),
                                    onPressed: () {},
                                    color: Colors.green,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 16),
                                    onPressed: () {},
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('2')),
                            const DataCell(Text('2025400003')),
                            const DataCell(Text('2025-04-22')),
                            const DataCell(Text('Goa 4N5D')),
                            const DataCell(Text('Harbhajan Naik')),
                            const DataCell(Text('Travel Agent 2')),
                            DataCell(
                                _buildStatusChip('Completed', Colors.green)),
                            DataCell(
                                _buildStatusChip('Completed', Colors.green)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.visibility, size: 16),
                                    onPressed: () {},
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 16),
                                    onPressed: () {},
                                    color: Colors.green,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 16),
                                    onPressed: () {},
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pagination
                    Row(
                      children: [
                        const Text("Showing 1 to 2 of 2 entries",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        const Spacer(),
                        Row(
                          children: [
                            _buildPaginationButton("Previous", false),
                            const SizedBox(width: 4),
                            _buildPaginationButton("1", true),
                            const SizedBox(width: 4),
                            _buildPaginationButton("Next", false),
                          ],
                        ),
                      ],
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

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color == Colors.green
            ? Colors.green.shade100
            : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color == Colors.green
              ? Colors.green.shade700
              : Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String srNo,
    String bookingId,
    String tourDate,
    String packageName,
    String customer,
    String travelConsultant,
    String paymentStatus,
    String status, {
    required bool isEven,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isEven ? Colors.grey.shade50 : Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(srNo, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(bookingId, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(tourDate, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(packageName, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(customer, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(travelConsultant, style: TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: paymentStatus == "Completed"
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                paymentStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: paymentStatus == "Completed"
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == "Completed"
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: status == "Completed"
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Icon(Icons.edit, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Icon(Icons.delete, size: 16, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Icon(Icons.unfold_more, size: 16, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildPaginationButton(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF6366F1) : Colors.transparent,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Color(0xFF6366F1) : Colors.grey.shade600,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    return ListView(
      children: [
        _buildBookingCard(
          destination: "Shimla Manali",
          date: "2025-06-14",
          imageUrl:
              "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&h=100&fit=crop",
          status: "Completed",
          bookingId: "2025600023",
          customerName: "Harbhajan Naik",
        ),
        SizedBox(height: 8),
        _buildBookingCard(
          destination: "Goa 4N5D",
          date: "2025-04-22",
          imageUrl:
              "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=150&h=100&fit=crop",
          status: "Completed",
          bookingId: "2025400003",
          customerName: "Harbhajan Naik",
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
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFE8F5E8),
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
              Spacer(),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
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
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 10),
                        children: [
                          TextSpan(
                            text: customerName,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: " has ",
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
                            text: " the package for ",
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
                            text: " with ",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          TextSpan(
                            text: "Booking ID: $bookingId",
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

  Widget _buildUpcomingTasks() {
    return ListView(
      children: [
        Text("Nothing to display", style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
