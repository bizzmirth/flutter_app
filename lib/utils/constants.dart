// Widget for Contact Info
import 'dart:async';
import 'dart:convert';

import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/book_now_page/book_now_page.dart';
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final IsarService _isarService = IsarService();
//contact info
Widget contactInfo(IconData icon, String text) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
    ),
  );
}

// Divider for spacing
Widget divider() {
  // ignore: deprecated_member_use
  return Divider(color: Colors.white.withOpacity(0.5));
}

// Custom Input Field
Widget customInputField(IconData icon, String label, {int maxLines = 1}) {
  return TextField(
    maxLines: maxLines,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      // ignore: deprecated_member_use
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      // ignore: deprecated_member_use
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

String normalizeGender(String gender) {
  switch (gender.toLowerCase().trim()) {
    case 'male':
      return 'Male';
    case 'female':
      return 'Female';
    case 'other':
      return 'Other';
    default:
      return "---- Select Gender ----";
  }
}

// Helper function for tab buttons
Widget buildTabButton(String label) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(label),
    ),
  );
}

// Helper function for tiles

Widget buildTile(String title, List<String> subTitles, List<String> values) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **Title**
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8), // Space between title & content

        // **Subtitles & Values**
        if (subTitles.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: subTitles.map((subTitle) {
              return Expanded(
                child: Text(
                  subTitle,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),

        if (values.isNotEmpty)
          SizedBox(height: 4), // Space between subtitles & numbers

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: values.map((value) {
            return Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

//custom animated cards (3x1)
class CustomAnimatedSummaryCards extends StatefulWidget {
  final List<SummaryCardData> cardData;

  const CustomAnimatedSummaryCards({super.key, required this.cardData});

  @override
  _AnimatedSummaryCardsState createState() => _AnimatedSummaryCardsState();
}

class _AnimatedSummaryCardsState extends State<CustomAnimatedSummaryCards> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.cardData.map((data) => _buildCard(data)).toList(),
    );
  }

  Widget _buildCard(SummaryCardData data) {
    bool isWalletCard = data.title.contains('WALLET');

    return Flexible(
      child: GestureDetector(
        onTap: isWalletCard
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletDetailsPage(),
                  ),
                );
              }
            : null,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          height: 120,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                colors[_currentColorIndex].withOpacity(0.8),
                colors[(_currentColorIndex + 1) % colors.length]
                    .withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // Add subtle shadow for clickable effect
            boxShadow: isWalletCard
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(data.icon, size: 35, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Add tap indicator for wallet card
                    if (isWalletCard)
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                  ],
                ),
                Spacer(),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// linechart
class ImprovedLineChart extends StatefulWidget {
  const ImprovedLineChart({super.key});

  @override
  _ImprovedLineChartState createState() => _ImprovedLineChartState();
}

class _ImprovedLineChartState extends State<ImprovedLineChart> {
  String? selectedYear;
  List<String> availableYears = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableYears();
  }

  Future<void> _loadAvailableYears() async {
    try {
      String? regDate = await SharedPrefHelper().getCurrentUserRegDate();

      List<String> dateParts = regDate!.split('-');
      int registrationYear = int.parse(dateParts[2]);
      int currentYear = DateTime.now().year;

      List<String> years = [];
      for (int year = registrationYear; year <= currentYear; year++) {
        years.add(year.toString());
      }

      setState(() {
        availableYears = years;
        selectedYear = currentYear.toString();
        isLoading = false;
      });

      if (mounted) {
        final customerController =
            Provider.of<CustomerController>(context, listen: false);
        await customerController.apiGetChartData(selectedYear!);
      }
    } catch (e) {
      Logger.error('Error loading registration date: $e');
      setState(() {
        availableYears = [DateTime.now().year.toString()];
        selectedYear = DateTime.now().year.toString();
        isLoading = false;
      });
    }
  }

  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // Helper method to get maximum month to display
  int getMaxMonth() {
    if (selectedYear == null) return 12;

    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int selectedYearInt = int.parse(selectedYear!);

    // If selected year is current year, show only up to current month
    if (selectedYearInt == currentYear) {
      return currentMonth;
    }

    // If selected year is past year, show all 12 months
    return 12;
  }

  @override
  Widget build(BuildContext context) {
    final customerController = Provider.of<CustomerController>(context);
    final chartData = customerController.getChartSpots();
    final maxMonth = getMaxMonth();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: customerController.isLoading
            ? SizedBox(
                width: double.infinity,
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blueAccent,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Performance Overview",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedYear,
                                  hint: Text("Select Year"),
                                  items: availableYears.map((String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      selectedYear = newValue;
                                      isLoading = true;
                                    });

                                    await customerController
                                        .apiGetChartData(selectedYear!);

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.grey),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: LineChart(
                      LineChartData(
                        minX: 1,
                        maxX: maxMonth.toDouble(),
                        minY: 0,
                        maxY: chartData.isNotEmpty
                            ? chartData
                                    .map((e) => e.y)
                                    .reduce((a, b) => a > b ? a : b) +
                                2
                            : 10,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          verticalInterval: 1,
                          horizontalInterval: 2,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 2,
                              getTitlesWidget: (value, _) => Padding(
                                padding: EdgeInsets.only(right: 18.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                // Only show month labels up to maxMonth
                                if (value.toInt() <= maxMonth) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      getMonthName(value.toInt()),
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: false,
                            color: Colors.blueAccent,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: const Color.fromARGB(255, 29, 153, 255),
                                strokeColor: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

//progress tracker card
class ProgressTrackerCard extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final String message;
  final Color progressColor;

  const ProgressTrackerCard({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.message,
    this.progressColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressTracker(
              totalSteps: totalSteps,
              currentStep: currentStep,
              progressColor: progressColor,
            ),
            SizedBox(height: 10), // Spacing

            // Custom Message Below Progress Bar
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//progress tracker
class ProgressTracker extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  final Color progressColor;

  const ProgressTracker({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.progressColor = Colors.blueAccent, // Default color
  });

  @override
  _ProgressTrackerState createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  int animatedStep = 0;

  @override
  void initState() {
    super.initState();
    _startStepAnimation();
  }

  @override
  void didUpdateWidget(covariant ProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _startStepAnimation();
    }
  }

  void _startStepAnimation() async {
    for (int i = 0; i <= widget.currentStep; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        animatedStep = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double segmentWidth = MediaQuery.of(context).size.width / widget.totalSteps;

    return Row(
      children: List.generate(widget.totalSteps, (index) {
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Grey background line
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        // Animated Filling Line
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: index < animatedStep ? segmentWidth : 0,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.progressColor,
                                widget.progressColor.withOpacity(0.7)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animated Check Icon
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: index < animatedStep ? 1.0 : 0.3,
                    child: Icon(
                      Icons.check_circle,
                      color: index < animatedStep
                          ? widget.progressColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              Text((index + 1).toString()),
            ],
          ),
        );
      }),
    );
  }
}

// bookings popup
void showBookingPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              'Need More Info or Ready to Book?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Would you like to enquire more about this package or proceed to booking?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 65),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                ),
              ),
              SizedBox(width: 65),
              TextButton(
                onPressed: () async {
                  await _handleUserAction(context, 'enquire');
                },
                child: Text(
                  'Submit Your Query',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange),
                ),
              ),
              SizedBox(width: 65),
              ElevatedButton(
                onPressed: () async {
                  await _handleUserAction(context, 'book');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Book Now',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> _handleUserAction(BuildContext context, String action) async {
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final mediaQuery = MediaQuery.of(context);

  navigator.pop();

  final userType = await SharedPrefHelper().getUserType();

  if (userType == null || userType.isEmpty) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'You need to log in to continue',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
                navigator.push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: mediaQuery.size.width * 0.3,
        ),
        duration: Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  } else {
    if (action == 'enquire') {
      navigator.push(MaterialPageRoute(builder: (context) => EnquireNowPage()));
    } else if (action == 'book') {
      navigator.push(MaterialPageRoute(builder: (context) => BookNowPage()));
    }
  }
}

void showBookingPopupAlternative(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              'Need More Info or Ready to Book?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Would you like to enquire more about this package or proceed to booking?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 65),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                ),
              ),
              SizedBox(width: 65),
              TextButton(
                onPressed: () async {
                  await _handleUserActionWithBanner(context, 'enquire');
                },
                child: Text(
                  'Submit Your Query',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange),
                ),
              ),
              SizedBox(width: 65),
              ElevatedButton(
                onPressed: () async {
                  await _handleUserActionWithBanner(context, 'book');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Book Now',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> _handleUserActionWithBanner(
    BuildContext context, String action) async {
  final userType = await SharedPrefHelper().getUserType();

  if (!context.mounted) return;

  if (userType == null || userType.isEmpty) {
    await Future.delayed(Duration(milliseconds: 100));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          'You need to log in to continue with your ${action == 'enquire' ? 'enquiry' : 'booking'}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        leading: Icon(Icons.lock_outline, color: Colors.orange),
        backgroundColor: Colors.orange.shade50,
        actions: [
          TextButton(
            onPressed: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              }
            },
            child: Text(
              'Dismiss',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Login Now',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      if (context.mounted) {
        try {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        } catch (e) {}
      }
    });
  } else {
    Navigator.of(context).pop();

    if (!context.mounted) return;

    if (action == 'enquire') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EnquireNowPage()),
      );
    } else if (action == 'book') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookNowPage()),
      );
    }
  }
}

String extractUserId(String fullUserId) {
  if (fullUserId.contains(" - ")) {
    return fullUserId.split(" - ")[0].trim();
  }
  return fullUserId;
}

String calculateAge(String dobString) {
  try {
    final parts = dobString.split('-');
    if (parts.length != 3) return 'Invalid date';

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final dob = DateTime(year, month, day);
    final today = DateTime.now();

    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age.toString();
  } catch (e) {
    return 'Invalid date';
  }
}

String extractPathSegment(String fullPath, String folderPrefix) {
  int index = fullPath.lastIndexOf(folderPrefix);
  if (index != -1) {
    return fullPath.substring(index);
  }
  return fullPath;
}

int? parseIntSafely(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    try {
      return int.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String capitalize(String input) {
  if (input.isEmpty) return '';
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

Future<String?> getDepartmentNameById(String departmentId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final departmentDataString = prefs.getString('departmentData');

    if (departmentDataString != null) {
      final List<dynamic> departmentData = json.decode(departmentDataString);
      final departmentInfo = departmentData.firstWhere(
        (dept) => dept['id'].toString() == departmentId,
        orElse: () => {'id': departmentId, 'dept_name': null},
      );

      return departmentInfo['dept_name']?.toString();
    }
  } catch (e) {
    Logger.error('Error looking up department name: $e');
  }
  return null;
}

Future<String?> getDesignationById(String designationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final designationDataString = prefs.getString('designationData');

    if (designationDataString != null) {
      final List<dynamic> designationData = json.decode(designationDataString);
      final designationInfo = designationData.firstWhere(
        (desg) => desg['id'].toString() == designationId,
        orElse: () => {'id': designationId, 'desg_name': null},
      );
      return designationInfo['designation_name']?.toString();
    }
  } catch (e) {
    Logger.error("Error looking up designation name: $e");
  }
  return null;
}

Future<String?> getReportingManagerNameById(String reportingManagerId) async {
  try {
    final reportingManagerDataList =
        await _isarService.getAll<RegisteredEmployeeModel>();

    // Find the employee with the matching regId
    for (var employee in reportingManagerDataList) {
      if (employee.regId == reportingManagerId) {
        return employee.name;
      }
    }

    // If no match is found, return a default value
    return "N/A";
  } catch (e) {
    Logger.error("Error fetching reporting manager data: $e");
    return null;
  }
}

Future<String?> getNameByReferenceNo(String referenceNo) async {
  try {
    final userList = await _isarService.getAll<RegisteredEmployeeModel>();

    // Find the user with the matching referenceNo
    for (var user in userList) {
      if (user.regId == referenceNo) {
        Logger.success("Fetched Name is : ${user.name}");
        return user.name;
      }
    }

    // If no match is found, return a default value
    return "N/A";
  } catch (e) {
    Logger.error("Error fetching user data: $e");
    return null;
  }
}

Future<String?> getZoneById(String zoneId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final zoneDataString = prefs.getString('zones');

    if (zoneDataString != null) {
      final List<dynamic> zoneData = json.decode(zoneDataString);
      final zoneInfo = zoneData.firstWhere(
        (zone) => zone['id'].toString() == zoneId,
        orElse: () => {'id': zoneId, 'zone_name': null},
      );
      return zoneInfo['zone_name']?.toString();
    }
  } catch (e) {
    Logger.error("Error looking up zone name : $e");
  }
  return null;
}

void scrollToFirstFormErrors({
  required BuildContext context,
  required List<_ValidationTarget> targets,
}) {
  for (final target in targets) {
    if (target.hasError()) {
      final context = target.key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      return;
    }
  }
}

class _ValidationTarget {
  final GlobalKey key;
  final bool Function() hasError;

  _ValidationTarget({
    required this.key,
    required this.hasError,
  });
}

// filter bar
class FilterBar1 extends StatefulWidget {
  const FilterBar1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterBar1State createState() => _FilterBar1State();
}

class _FilterBar1State extends State<FilterBar1> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  int countUsers = 100; // Example count
  double amount = 5000.00; // Example amount

  String? fromDateError;
  String? toDateError;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    DateTime lastDate = isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            fromDateError = "From Date can't be after To Date";
          } else {
            fromDate = pickedDate;
            fromDateError = null;
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        padding:
            EdgeInsets.symmetric(horizontal: 6, vertical: 6), // Light padding

        child: Row(
          children: [
            SizedBox(width: 15),
            // Search Bar
            Expanded(
              flex: 2,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide.none, // No border line
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),

            SizedBox(width: 10),

            // From Date Picker
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _selectDate(context, true),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    fromDate == null
                        ? "From Date"
                        : DateFormat.yMMMd().format(fromDate!),
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            Text("  --  "),

            // To Date Picker
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _selectDate(context, false),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    toDate == null
                        ? "To Date"
                        : DateFormat.yMMMd().format(toDate!),
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            SizedBox(width: 10),

            // Count Users
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Users: $countUsers"),
              ),
            ),

            SizedBox(width: 10),

            // Amount
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Amount: ₹${amount.toStringAsFixed(2)}"),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

// filter bar
class FilterBar2 extends StatefulWidget {
  const FilterBar2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterBar2State createState() => _FilterBar2State();
}

class _FilterBar2State extends State<FilterBar2> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  int countUsers = 100; // Example count
  double amount = 5000.00; // Example amount

  String? fromDateError;
  String? toDateError;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    DateTime lastDate = isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            fromDateError = "From Date can't be after To Date";
          } else {
            fromDate = pickedDate;
            fromDateError = null;
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
          }
        }
      });
    }
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            DropdownMenuItem(
              value: "-- Select --",
              child: Text("-- Select --", style: TextStyle(color: Colors.grey)),
            ),
            ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
          ],
          onChanged: (value) {
            // Handle selection
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, bool isFromDate) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => _selectDate(context, isFromDate),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            isFromDate
                ? (fromDate == null
                    ? label
                    : DateFormat.yMMMd().format(fromDate!))
                : (toDate == null ? label : DateFormat.yMMMd().format(toDate!)),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _buildDropdown('Designation', ['Option 1', 'Option 2', 'Option 3']),
            _buildDropdown('User', ['Active', 'Inactive', 'Pending']),
            _buildDateSelector("From Date", true),
            const SizedBox(width: 3),
            const Text("--",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 3),
            _buildDateSelector("To Date", false),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(String? date) {
  if (date == null || date.isEmpty) return "N/A";
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  } catch (e) {
    return "Invalid Date";
  }
}
