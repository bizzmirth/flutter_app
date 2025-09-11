import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';

class DateFilterWidget extends StatefulWidget {
  const DateFilterWidget({super.key});

  @override
  State<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  String selectedDateFilter = "This Month";
  String displayDateRange = "August 1, 2025 - August 31, 2025";
  bool isDropdownOpen = false;

  final List<String> dateFilterOptions = [
    "Today",
    "Yesterday",
    "Last 7 Days",
    "Last 30 Days",
    "This Month",
    "Last Month",
    "Custom Range"
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  displayDateRange,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(
                  isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Menu
        if (isDropdownOpen)
          Container(
            width: 180,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: dateFilterOptions
                  .map((option) => _buildDropdownItem(option))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownItem(String option) {
    bool isSelected = selectedDateFilter == option;

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          if (option != "Custom Range") {
            setState(() {
              selectedDateFilter = option;
              displayDateRange = _getDateRangeForOption(option);
              isDropdownOpen = false;
            });
          } else {
            setState(() {
              isDropdownOpen = false;
            });
            Logger.info("Custom Range selected - implement date picker");
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: option == dateFilterOptions.first
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                : option == dateFilterOptions.last
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )
                    : BorderRadius.zero,
          ),
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _getDateRangeForOption(String option) {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (option) {
      case "Today":
        startDate = now;
        endDate = now;
        break;
      case "Yesterday":
        startDate = now.subtract(const Duration(days: 1));
        endDate = now.subtract(const Duration(days: 1));
        break;
      case "Last 7 Days":
        startDate = now.subtract(const Duration(days: 6));
        endDate = now;
        break;
      case "Last 30 Days":
        startDate = now.subtract(const Duration(days: 29));
        endDate = now;
        break;
      case "This Month":
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case "Last Month":
        DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(lastMonth.year, lastMonth.month + 1, 0);
        break;
      default:
        return displayDateRange;
    }

    return _formatDateRange(startDate, endDate);
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    List<String> months = [
      "",
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

    String startFormatted =
        "${months[startDate.month]} ${startDate.day}, ${startDate.year}";

    if (startDate.day == endDate.day &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return startFormatted;
    }

    String endFormatted =
        "${months[endDate.month]} ${endDate.day}, ${endDate.year}";
    return "$startFormatted - $endFormatted";
  }
}
