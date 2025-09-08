import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImprovedLineChart extends StatefulWidget {
  final String? initialYear;
  const ImprovedLineChart({super.key, this.initialYear});

  @override
  _ImprovedLineChartState createState() => _ImprovedLineChartState();
}

class _ImprovedLineChartState extends State<ImprovedLineChart> {
  String? selectedYear;
  List<String> availableYears = [];
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAvailableYears();
  }

  Future<void> _loadAvailableYears() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = null;
      });
      final customerController =
          Provider.of<CustomerController>(context, listen: false);
      if (customerController.isLoading) {
        await Future.delayed(Duration(milliseconds: 500));
      }

      String? regDate = await SharedPrefHelper().getCurrentUserRegDate();

      Logger.warning(
          "Registration date from SharedPref: $regDate. Registration date from Parent ${customerController.userRegDate}");
      if (regDate == null || regDate.isEmpty) {
        Logger.info(
            'Registration date not available yet, using current year as fallback');
        int currentYear = DateTime.now().year;
        setState(() {
          availableYears = [currentYear.toString()];
          selectedYear = currentYear.toString();
          isLoading = false;
        });
        if (mounted) {
          await customerController.apiGetChartData(selectedYear!);
        }
        return;
      }
      List<String> dateParts = regDate.split('-');
      if (dateParts.length != 3) {
        throw Exception(
            'Invalid date format: $regDate. Expected format: DD-MM-YYYY or YYYY-MM-DD');
      }

      int registrationYear;
      if (dateParts[0].length == 4) {
        registrationYear = int.parse(dateParts[0]);
      } else {
        registrationYear = int.parse(dateParts[2]);
      }

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

      await customerController.apiGetChartData(selectedYear!);
    } catch (e) {
      Logger.error('Error loading registration date: $e');

      setState(() {
        hasError = true;
        errorMessage = 'Failed to load chart data: ${e.toString()}';
        // Fallback to current year
        availableYears = [DateTime.now().year.toString()];
        selectedYear = DateTime.now().year.toString();
        isLoading = false;
      });

      // Still try to load chart data with fallback year
      if (mounted) {
        try {
          final customerController =
              Provider.of<CustomerController>(context, listen: false);
          await customerController.apiGetChartData(selectedYear!);
        } catch (chartError) {
          Logger.error(
              'Error loading chart data with fallback year: $chartError');
        }
      }
    }
  }

  // Method to retry loading when user data becomes available
  Future<void> _retryLoadAvailableYears() async {
    await _loadAvailableYears();
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
    return Consumer<CustomerController>(
      builder: (context, customerController, child) {
        final chartData = customerController.getChartSpots();
        final maxMonth = getMaxMonth();

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Performance Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    if (hasError)
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.orange),
                        onPressed: _retryLoadAvailableYears,
                        tooltip: 'Retry loading data',
                      ),
                    if (isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (availableYears.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                              });

                              if (selectedYear != null) {
                                await customerController
                                    .apiGetChartData(selectedYear!);
                              }
                            },
                            icon:
                                Icon(Icons.arrow_drop_down, color: Colors.grey),
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),

                // Show error message if there's an error
                if (hasError && errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Using fallback data. ${errorMessage!}',
                            style: TextStyle(
                                color: Colors.orange.shade800, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Chart area
                if (customerController.isLoading)
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
                else
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
      },
    );
  }
}
