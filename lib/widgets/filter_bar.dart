import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBar extends StatefulWidget {
  final String? userCount;
  const FilterBar({super.key, this.userCount});

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  int countUsers = 100; // Example count

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
    String totalUsers = widget.userCount ?? "100";
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
                child: Text("Users: $totalUsers"),
              ),
            ),

            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
