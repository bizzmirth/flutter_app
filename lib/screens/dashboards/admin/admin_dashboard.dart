import 'package:bizzmirth_app/models/transactions.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/business_mentor/business_mentor.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/commission_incentives/production/production_incentives_page.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/commission_incentives/recruitment/recruitment_incentives_page.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/all_employees/all_employees_page.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/employees/designations_departments/designations_departments.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/more_transactions.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/amenities/amenities.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/category/category.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/order_history/order_history.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_markup/package_markup.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/packages.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/quotations/quotations.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/techno_enterprise/techno_enterprise.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/travel_consultant/travel_consultant.dart';
import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track dropdown expansion states
  bool employeesExpanded = false;
  bool commissionExpanded = false;

  int _currentPage =
      0; // Define this at the top inside your StatefulWidget class
  final int _tasksPerPage = 5; // Define tasks per page globally

  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<Map<String, String>>> _tasks = {};
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  Map<String, String> selectedDates = {};

  final List<MapEntry<DateTime, Map<String, String>>> _upcomingTasks = [];

  final Map<String, Color> eventTypeColors = {
    "Birthday": Colors.purple,
    "Meeting": Colors.blue,
    "Holiday": Colors.green,
    "Reminder": Colors.orange,
    "Other": Colors.grey, // Default color
  };

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case "birthday":
        return Colors.purple;
      case "meeting":
        return Colors.blue;
      case "holiday":
        return Colors.green;
      case "reminder":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<Transaction> transactions = [];

  void _showMonthYearPicker(String department) async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showMonthPicker(
      context: context,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
      initialDate: now, // Start with current month-year
    );

    if (pickedDate != null) {
      setState(() {
        selectedDates[department] =
            "${_getMonthName(pickedDate.month)} - ${pickedDate.year}";
      });
    }
  }

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

  String _getMonthName(int month) {
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }

  @override
  void initState() {
    super.initState();
    _updateUpcomingTasks(); // ✅ Load tasks at startup

    DateTime now = DateTime.now();
    String currentMonthYear = "${_getMonthName(now.month)} - ${now.year}";

    selectedDates = {
      "BCH": currentMonthYear,
      "BDM": currentMonthYear,
      "BM": currentMonthYear,
      "TE": currentMonthYear,
      "TC/TA": currentMonthYear,
      "Customer": currentMonthYear,
    };

    // Initialize the transactions list inside initState
    transactions = [
      Transaction(
          title: "recruitment of CA,",
          whom: "BHL",
          via: "Cheque",
          date: "2025-02-14",
          amount: 500000.00),
      Transaction(
          title: "package booked,",
          whom: "Nishant(TC) for Customer Mr. Savio Vaz",
          via: "Cheque",
          date: "2025-03-21",
          amount: 50000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
      Transaction(
          title: "Topup balance,",
          whom: "BHL by Nishant(TC)",
          via: "Cash",
          date: "2025-03-25",
          amount: 10000.00),
    ];
  }

  Widget buildResponsiveGrid(BuildContext context) {
    // Check if it's mobile (small screen)
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 10,
      childAspectRatio:
          isMobile ? 1.5 : 3.5, // Only change aspect ratio for mobile
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        buildTile("Total Recruits", ["Total Count", "Amount Earned"],
            ["26", "₹ 25,000/-"]),
        buildTile("Total Production", ["Packages Sold", "Amount Earned"],
            ["91", "₹ 91,596/-"]),
        buildTile("Total Travel Consultants", [], ["61"]),
        buildTile("Total Customers", [], ["126"]),
        buildTile("Total Business Mentors", [], ["32"]),
        buildTile("Total Employees", [], ["441"]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
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
                      "Welcome, Admin!",
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

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                      context, Icons.dashboard, "Dashboard", AdminDashboard()),
                  _drawerItem(context, Icons.home, "HomePage", HomePage()),
                  ExpansionTile(
                    title: const Text("Employees"),
                    leading: const Icon(Icons.business_center),
                    children: [
                      _drawerItem(context, Icons.groups, "All Employees",
                          AllEmployeesPage(),
                          padding: true),
                      _drawerItem(context, Icons.groups,
                          "Departments/Designation", DesignationsPage(),
                          padding: true),
                    ],
                  ),
                  _drawerItem(context, Icons.person, "Business Mentor",
                      BusinessMentorPage()),
                  _drawerItem(context, Icons.business, "Techno Enterprise",
                      TechnoEnterprisePage()),
                  _drawerItem(context, Icons.travel_explore,
                      "Travel Consultant", TCPage()),
                  _drawerItem(
                      context, Icons.support_agent, "Customer", CustPage()),
                  const Divider(),
                  ExpansionTile(
                    title: const Text("Packages"),
                    leading: const Icon(Icons.card_giftcard),
                    children: [
                      _drawerItem(context, Icons.card_giftcard, "Packages",
                          PackagePage(),
                          padding: true),
                      _drawerItem(context, Icons.card_giftcard, "Order History",
                          OrderHistPage(),
                          padding: true),
                      _drawerItem(context, Icons.card_giftcard,
                          "Package Markup (TC)", PackageMarkupPage(),
                          padding: true),
                      _drawerItem(context, Icons.card_giftcard, "Amenities",
                          AmenitiesPage(),
                          padding: true),
                      _drawerItem(context, Icons.card_giftcard, "Category",
                          CategoryPage(),
                          padding: true),
                      _drawerItem(context, Icons.card_giftcard, "Quotations",
                          QuotationsPage(),
                          padding: true),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text("Commission/Incentives"),
                    leading: const Icon(Icons.monetization_on),
                    children: [
                      _drawerItem(context, Icons.monetization_on, "Recruitment",
                          RecruitmentIncentivesPage(),
                          padding: true),
                      _drawerItem(context, Icons.monetization_on, "Production",
                          ProductionIncentivesPage(),
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
                      onTap: () {
                        SharedPrefHelper().removeDetails();
                        Navigator.pushAndRemoveUntil(
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
            // Logo at the Bottom (ALWAYS sticks there)
            Container(
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/bizz_logo.png",
                height: 80,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Overview",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    buildTabButton("Daily"),
                    buildTabButton("Weekly"),
                    buildTabButton("Monthly"),
                    buildTabButton("Yearly"),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Admin Overview Section
              Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Admin Overview",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Tiles Grid Layout (Fixed)
              buildResponsiveGrid(context),

              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.black26),

              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Upcoming Events:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              // Calendar and Upcoming Tasks Section
              SizedBox(
                height: 420, // Adjusted for better layout
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    Expanded(
                      flex: 2,
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
                                    // ignore: unnecessary_type_check
                                    if (event is Map<String, Object>) {
                                      return {
                                        "name": event["name"]?.toString() ??
                                            "Unnamed Event",
                                        "type": event["type"]?.toString() ??
                                            "other",
                                      };
                                    }
                                    return {
                                      "name": "Invalid Event",
                                      "type": "other"
                                    };
                                  }).toList();
                                },
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blueAccent
                                        .withValues(alpha: 0.5),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: events.map((event) {
                                          return Container(
                                            width: 8,
                                            height: 8,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 1),
                                            decoration: BoxDecoration(
                                              color: event
                                                      is Map<String, Object>
                                                  ? _getEventColor(event["type"]
                                                          ?.toString() ??
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

                          // "Today" button positioned beside the right arrow
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 1),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text("Today",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),

                          // Positioned Add Event Button
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

                    SizedBox(width: 10),

                    // Upcoming Tasks Section
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Upcoming Tasks This Week",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Divider(thickness: 1),
                            Expanded(
                              child: _buildUpcomingTasks(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.black26),

              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Top Performers This Month:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              _buildTopPerformersSection(),

              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.black26),

              // Upcoming Events Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Recent Transactions:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 1, color: Colors.black26),

              _buildLatestTransactionsSection(),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Moretransactions(transactions)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // White text
                    backgroundColor: Color.fromARGB(
                        255, 81, 131, 246), // Same blue as header
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5, // Slight shadow for better UI feel
                  ),
                  child: Text('View More'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestTransactionsSection() {
    int maxTransactionsToShow = 5;
    bool hasMoreTransactions = transactions.length > maxTransactionsToShow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              hasMoreTransactions ? maxTransactionsToShow : transactions.length,
          itemBuilder: (context, index) {
            var transaction = transactions[index];
            return ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Payment made towards the "),
                    TextSpan(
                      text: transaction.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " paid amount "),
                    TextSpan(
                      text: "₹${transaction.amount}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " towards "),
                    TextSpan(
                      text: transaction.whom,
                    ),
                    TextSpan(text: " via "),
                    TextSpan(
                      text: transaction.via,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " on "),
                    TextSpan(
                      text: transaction.date,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopPerformersSection() {
    List<Map<String, dynamic>> departments = [
      {"name": "BCH", "performers": _getDummyPerformers1()},
      {"name": "BDM", "performers": _getDummyPerformers2()},
      {"name": "BM", "performers": _getDummyPerformers3()},
      {"name": "TE", "performers": _getDummyPerformers4()},
      {"name": "TC/TA", "performers": _getDummyPerformers5()},
      {"name": "Customer", "performers": _getDummyPerformers6()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 13,
            childAspectRatio: 1.72,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            var dept = departments[index];
            return _buildDepartmentCard(dept["name"], dept["performers"]);
          },
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(
      String department, List<Map<String, String>> performers) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Top Performer's in $department's",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Text(
                  "${selectedDates[department]} ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showMonthYearPicker(department),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Select Month"),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  " Ranks",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 45,
                ),
                Text(
                  " Profile Picture",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 115,
                ),
                Text(
                  "Full Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 105,
                ),
                Text(
                  "References",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Count",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: performers.length,
                itemBuilder: (context, rank) {
                  return Row(
                    children: [
                      Image.asset(
                        "assets/${rank + 1}.jpg", // Rank Image
                        width: 53,
                        height: 53,
                      ),
                      SizedBox(width: 70),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(performers[rank]["image"]!),
                      ),
                      SizedBox(width: 145),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(performers[rank]["name"]!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("id3445345",
                              style: TextStyle(color: Color(0xFF495057)))
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(performers[rank]["name"]!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("id3445345",
                              style: TextStyle(color: Color(0xFF495057)))
                        ],
                      ),
                      SizedBox(width: 40),
                      Spacer(),
                      Center(
                        child: Text(performers[rank]["count"]!,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getDummyPerformers1() {
    return [
      {
        "name": "John Doe",
        "image": "https://randomuser.me/api/portraits/men/1.jpg",
        "count": "30"
      },
      {
        "name": "Jane Smith",
        "image": "https://randomuser.me/api/portraits/women/1.jpg",
        "count": "30"
      },
      {
        "name": "Alice Brown",
        "image": "https://randomuser.me/api/portraits/women/2.jpg",
        "count": "30"
      },
      {
        "name": "Bob White",
        "image": "https://randomuser.me/api/portraits/men/2.jpg",
        "count": "30"
      },
      {
        "name": "Charlie Black",
        "image": "https://randomuser.me/api/portraits/men/3.jpg",
        "count": "30"
      },
    ];
  }

  List<Map<String, String>> _getDummyPerformers2() {
    return [
      {
        "name": "Liam Anderson",
        "image": "https://randomuser.me/api/portraits/men/4.jpg",
        "count": "30"
      },
      {
        "name": "Sophia Martinez",
        "image": "https://randomuser.me/api/portraits/women/3.jpg",
        "count": "30"
      },
      {
        "name": "Noah Thompson",
        "image": "https://randomuser.me/api/portraits/men/5.jpg",
        "count": "30"
      },
      {
        "name": "Isabella Taylor",
        "image": "https://randomuser.me/api/portraits/women/4.jpg",
        "count": "30"
      },
      {
        "name": "Mason Walker",
        "image": "https://randomuser.me/api/portraits/men/6.jpg",
        "count": "30"
      },
    ];
  }

  List<Map<String, String>> _getDummyPerformers3() {
    return [
      {
        "name": "Ethan Hall",
        "image": "https://randomuser.me/api/portraits/men/7.jpg",
        "count": "30"
      },
      {
        "name": "Ava Lewis",
        "image": "https://randomuser.me/api/portraits/women/5.jpg",
        "count": "30"
      },
      {
        "name": "Logan Allen",
        "image": "https://randomuser.me/api/portraits/men/8.jpg",
        "count": "30"
      },
      {
        "name": "Mia Scott",
        "image": "https://randomuser.me/api/portraits/women/6.jpg",
        "count": "30"
      },
      {
        "name": "Lucas Adams",
        "image": "https://randomuser.me/api/portraits/men/9.jpg",
        "count": "30"
      },
    ];
  }

  List<Map<String, String>> _getDummyPerformers4() {
    return [
      {
        "name": "Zylo Vex",
        "image": "https://randomuser.me/api/portraits/men/10.jpg",
        "count": "30"
      },
      {
        "name": "Nova Quark",
        "image": "https://randomuser.me/api/portraits/men/11.jpg",
        "count": "30"
      },
      {
        "name": "Orion Kade",
        "image": "https://randomuser.me/api/portraits/men/12.jpg",
        "count": "30"
      },
      {
        "name": "Luna Xel",
        "image": "https://randomuser.me/api/portraits/women/7.jpg",
        "count": "30"
      },
      {
        "name": "Atlas Rayne",
        "image": "https://randomuser.me/api/portraits/men/13.jpg",
        "count": "30"
      },
    ];
  }

  List<Map<String, String>> _getDummyPerformers5() {
    return [
      {
        "name": "Eldrin Storm",
        "image": "https://randomuser.me/api/portraits/men/14.jpg",
        "count": "30"
      },
      {
        "name": "Seraphina Vale",
        "image": "https://randomuser.me/api/portraits/women/8.jpg",
        "count": "30"
      },
      {
        "name": "Thalric Draven",
        "image": "https://randomuser.me/api/portraits/men/15.jpg",
        "count": "30"
      },
      {
        "name": "Lyra Moonshadow",
        "image": "https://randomuser.me/api/portraits/women/9.jpg",
        "count": "30"
      },
      {
        "name": "Garrick Thorn",
        "image": "https://randomuser.me/api/portraits/men/16.jpg",
        "count": "30"
      },
    ];
  }

  List<Map<String, String>> _getDummyPerformers6() {
    return [
      {
        "name": "Ares Titan",
        "image": "https://randomuser.me/api/portraits/men/17.jpg",
        "count": "30"
      },
      {
        "name": "Freya Valkyrie",
        "image": "https://randomuser.me/api/portraits/women/10.jpg",
        "count": "30"
      },
      {
        "name": "Zephyr Nyx",
        "image": "https://randomuser.me/api/portraits/men/18.jpg",
        "count": "30"
      },
      {
        "name": "Hades Orion",
        "image": "https://randomuser.me/api/portraits/men/19.jpg",
        "count": "30"
      },
      {
        "name": "Athena Solis",
        "image": "https://randomuser.me/api/portraits/women/11.jpg",
        "count": "30"
      },
    ];
  }

  void _showManualAddEventDialog() {
    TextEditingController eventController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    String selectedEventType = "Meeting"; // Default event type
    List<String> eventTypes = ["Meeting", "Birthday", "Holiday", "Reminder"];

    DateTime tempSelectedDate = DateTime.now(); // 🔥 Always defaults to today
    dateController.text = "${tempSelectedDate.toLocal()}"
        .split(' ')[0]; // 🔥 Set initial date in TextBox

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add Event"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: eventController,
                    decoration: InputDecoration(labelText: "Event Name"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Select Date",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: tempSelectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setDialogState(() {
                          tempSelectedDate = pickedDate;
                          dateController.text = "${tempSelectedDate.toLocal()}"
                              .split(' ')[0]; // 🔥 Updates TextBox
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedEventType,
                    isExpanded: true,
                    items: eventTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedEventType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (eventController.text.isNotEmpty) {
                      setState(() {
                        if (!_tasks.containsKey(tempSelectedDate)) {
                          _tasks[tempSelectedDate] = [];
                        }
                        _tasks[tempSelectedDate]!.add({
                          "name": eventController.text,
                          "type": selectedEventType,
                        });

                        _updateUpcomingTasks(); // 🔥 Updates upcoming tasks
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  Widget _buildUpcomingTasks() {
    List<MapEntry<DateTime, Map<String, String>>> sortedTasks = _upcomingTasks;
    int totalPages = (sortedTasks.length / _tasksPerPage).ceil();

    if (sortedTasks.isEmpty) return Center(child: Text("No tasks available"));

    _currentPage = _currentPage.clamp(0, totalPages - 1);
    int startIndex = _currentPage * _tasksPerPage;
    int endIndex = (startIndex + _tasksPerPage).clamp(0, sortedTasks.length);

    List<MapEntry<DateTime, Map<String, String>>> paginatedTasks =
        sortedTasks.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: paginatedTasks.length,
            itemBuilder: (context, index) {
              final entry = paginatedTasks[index];
              String eventName = entry.value["name"] ?? "Unnamed Event";
              String eventType = entry.value["type"] ?? "Other";

              // Get event-specific color (default to grey if type not found)
              Color iconColor = eventTypeColors[eventType] ?? Colors.grey;

              return ListTile(
                leading: Icon(Icons.calendar_month_outlined, color: iconColor),
                title: Text(eventName),
                subtitle: Text(
                  "${_formatDate(entry.key)} - $eventType",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        ),
        if (totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _currentPage > 0
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              Text("Page ${_currentPage + 1} of $totalPages"),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _currentPage < totalPages - 1
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
      ],
    );
  }

// Define the list at the top

  void _showAddTaskDialog({required DateTime selectedDate}) {
    TextEditingController taskController = TextEditingController();
    String selectedEventType = "Meeting"; // Default type
    List<String> eventTypes = ["Meeting", "Birthday", "Holiday", "Reminder"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // 🔥 Allows dropdown updates inside dialog
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(hintText: "Enter task name"),
                  ),
                  DropdownButton<String>(
                    value: selectedEventType,
                    isExpanded: true, // 🔥 Makes sure dropdown takes full width
                    items: eventTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          // 🔥 Updates only the dropdown
                          selectedEventType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      setState(() {
                        DateTime taskDate = DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day);

                        if (!_tasks.containsKey(taskDate)) {
                          _tasks[taskDate] = [];
                        }
                        _tasks[taskDate]!.add({
                          "name": taskController.text,
                          "type": selectedEventType
                        });

                        _updateUpcomingTasks(); // 🔥 Ensures upcoming tasks update
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateUpcomingTasks() {
    _upcomingTasks.clear();

    _tasks.forEach((date, events) {
      for (var event in events) {
        _upcomingTasks.add(MapEntry(date, event));
      }
    });

    // Sort by date
    _upcomingTasks.sort((a, b) => a.key.compareTo(b.key));

    setState(() {});
  }

  void _showRemoveEventDialog(DateTime selectedDay) {
    if (_tasks[selectedDay] == null || _tasks[selectedDay]!.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove Events"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _tasks[selectedDay]!.asMap().entries.map((entry) {
              int index = entry.key;
              String event = entry.value as String;
              return ListTile(
                title: Text(event),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _tasks[selectedDay]!.removeAt(index);
                      if (_tasks[selectedDay]!.isEmpty) {
                        _tasks.remove(selectedDay);
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
