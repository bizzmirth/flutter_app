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

  // -----------------------------
  // Month labels
  // -----------------------------
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

  // -----------------------------
  // Detect all-zero data
  // -----------------------------
  bool get isAllZeroData {
    if (chartData.isEmpty) return true;
    return chartData.every((spot) => spot.y == 0);
  }

  // -----------------------------
  // Normalize data to ALWAYS 12 months
  // -----------------------------
  List<FlSpot> get normalizedChartData {
    final Map<int, double> dataMap = {
      for (final spot in chartData) spot.x.toInt(): spot.y,
    };

    return List.generate(
      12,
      (index) {
        final month = index + 1;
        return FlSpot(
          month.toDouble(),
          dataMap[month] ?? 0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============================
            // HEADER
            // =============================
            Row(
              children: [
                const Text(
                  'Performance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
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
                      items: availableYears.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: onYearChanged,
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // =============================
            // ERROR MESSAGE
            // =============================
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

            // =============================
            // LOADER / CHART
            // =============================
            if (isLoading)
              const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              AspectRatio(
                aspectRatio: 1.8,
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxX: 12, // 🔥 ALWAYS SHOW JAN–DEC
                    minY: 0,
                    maxY: isAllZeroData
                        ? 8
                        : normalizedChartData
                                .map((e) => e.y)
                                .reduce((a, b) => a > b ? a : b) +
                            2,

                    // -----------------------------
                    // GRID
                    // -----------------------------
                    gridData: const FlGridData(
                      verticalInterval: 1,
                      horizontalInterval: 2,
                    ),

                    // -----------------------------
                    // AXES
                    // -----------------------------
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 2,
                          getTitlesWidget: (value, _) {
                            if (isAllZeroData &&
                                !(value == 2 ||
                                    value == 4 ||
                                    value == 6 ||
                                    value == 8)) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            if (value >= 1 && value <= 12) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  getMonthName(value.toInt()),
                                  style: const TextStyle(fontSize: 12),
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

                    // -----------------------------
                    // BORDER
                    // -----------------------------
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),

                    // -----------------------------
                    // LINE
                    // -----------------------------
                    lineBarsData: [
                      LineChartBarData(
                        spots: normalizedChartData, // 🔥 IMPORTANT
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

            // =============================
            // EMPTY DATA TEXT
            // =============================
            // if (!isLoading && isAllZeroData)
            //   const Padding(
            //     padding: EdgeInsets.only(top: 8),
            //     child: Text(
            //       'No data available for this year',
            //       style: TextStyle(fontSize: 12, color: Colors.grey),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
