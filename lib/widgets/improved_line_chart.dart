import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ImprovedLineChart extends StatelessWidget {
  final List<FlSpot> chartData;
  final List<String> availableYears;
  final String selectedYear;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final ValueChanged<String?>? onYearChanged;

  const ImprovedLineChart({
    super.key,
    required this.chartData,
    required this.availableYears,
    required this.selectedYear,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onYearChanged,
  });

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

  int getMaxMonth() {
    final int currentYear = DateTime.now().year;
    final int currentMonth = DateTime.now().month;
    final int selectedYearInt = int.parse(selectedYear);
    return selectedYearInt == currentYear ? currentMonth : 12;
  }

  @override
  Widget build(BuildContext context) {
    final maxMonth = getMaxMonth();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                const Text(
                  'Performance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // if (isLoading)
                //   const SizedBox(
                //     width: 20,
                //     height: 20,
                //     child: CircularProgressIndicator(strokeWidth: 2),
                //   )
                // else if (availableYears.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedYear,
                      hint: const Text('Select Year'),
                      items: availableYears.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: onYearChanged,
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Error Message
            if (hasError && errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Using fallback data. $errorMessage',
                        style: TextStyle(
                            color: Colors.orange.shade800, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            // Chart
            if (isLoading)
              const SizedBox(
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
                    gridData: const FlGridData(
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
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            if (value.toInt() <= maxMonth) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  getMonthName(value.toInt()),
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        color: Colors.blueAccent,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: FlDotData(
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
