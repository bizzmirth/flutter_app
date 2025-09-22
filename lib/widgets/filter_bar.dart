import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBar extends StatefulWidget {
  final List? userList;
  final String? userCount;
  final Function(String)? onSearchChanged;
  final Function(DateTime?, DateTime?)? onDateRangeChanged;
  final Function()? onClearFilters;

  const FilterBar({
    super.key,
    this.userCount,
    this.userList,
    this.onSearchChanged,
    this.onDateRangeChanged,
    this.onClearFilters,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? fromDateError;
  String? toDateError;

  @override
  void initState() {
    super.initState();
    // Listen to search changes and call the callback
    searchController.addListener(() {
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(searchController.text);
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    final DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    final DateTime lastDate =
        isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
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
            // Call the callback with updated date range
            if (widget.onDateRangeChanged != null) {
              widget.onDateRangeChanged!(fromDate, toDate);
            }
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
            // Call the callback with updated date range
            if (widget.onDateRangeChanged != null) {
              widget.onDateRangeChanged!(fromDate, toDate);
            }
          }
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      searchController.clear();
      fromDate = null;
      toDate = null;
      fromDateError = null;
      toDateError = null;
    });

    // Call the clear callback
    if (widget.onClearFilters != null) {
      widget.onClearFilters!();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String totalUsers = widget.userCount ?? '0';
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            padding:
                EdgeInsets.symmetric(horizontal: isTablet ? 6 : 7, vertical: 8),
            child: isTablet
                ? _buildTabletLayout(totalUsers)
                : _buildPhoneLayout(totalUsers),
          ),
        ),

        // Error Messages
        if (fromDateError != null || toDateError != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                if (fromDateError != null)
                  Expanded(
                    child: Text(
                      fromDateError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                if (fromDateError != null && toDateError != null)
                  const Text(' | ', style: TextStyle(color: Colors.red)),
                if (toDateError != null)
                  Expanded(
                    child: Text(
                      toDateError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTabletLayout(String totalUsers) {
    return Row(
      children: [
        const SizedBox(width: 15),
        // Search Bar
        Expanded(
          flex: 2,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // From Date Picker
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, true),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: fromDateError != null
                    ? Border.all(color: Colors.red)
                    : null,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                fromDate == null
                    ? 'From Date'
                    : DateFormat.yMMMd().format(fromDate!),
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),

        const Text('  --  '),

        // To Date Picker
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, false),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border:
                    toDateError != null ? Border.all(color: Colors.red) : null,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                toDate == null ? 'To Date' : DateFormat.yMMMd().format(toDate!),
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Count Users
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('Count: $totalUsers'),
          ),
        ),

        const SizedBox(width: 10),

        // Clear Filters Button
        IconButton(
          onPressed: _clearFilters,
          icon: const Icon(Icons.clear, color: Colors.red),
          tooltip: 'Clear Filters',
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPhoneLayout(String totalUsers) {
    return Column(
      children: [
        // First row: Search and Clear button
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear, color: Colors.red),
              tooltip: 'Clear Filters',
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Second row: Date pickers and count
        Row(
          children: [
            // From Date Picker
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, true),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: fromDateError != null
                        ? Border.all(color: Colors.red)
                        : null,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    fromDate == null
                        ? 'From Date'
                        : DateFormat.yMMMd().format(fromDate!),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            const Text('--', style: TextStyle(fontSize: 12)),

            const SizedBox(width: 4),

            // To Date Picker
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, false),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: toDateError != null
                        ? Border.all(color: Colors.red)
                        : null,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    toDate == null
                        ? 'To Date'
                        : DateFormat.yMMMd().format(toDate!),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Count Users
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text('Count: $totalUsers',
                  style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }
}
