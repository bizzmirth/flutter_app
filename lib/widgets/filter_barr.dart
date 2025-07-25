import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBar<T> extends StatefulWidget {
  final List<T> originalList;
  final Function(List<T>) onFilterChanged;
  final String Function(T) getNameFromItem;
  final DateTime? Function(T) getDateFromItem;
  final String userCount;
  final String? searchHint;

  const FilterBar({
    super.key,
    required this.originalList,
    required this.onFilterChanged,
    required this.getNameFromItem,
    required this.getDateFromItem,
    required this.userCount,
    this.searchHint = "Search by name...",
  });

  @override
  State<FilterBar<T>> createState() => _FilterBarState<T>();
}

class _FilterBarState<T> extends State<FilterBar<T>> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  List<T> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = widget.originalList;
  }

  @override
  void didUpdateWidget(FilterBar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.originalList != widget.originalList) {
      _applyFilters();
    }
  }

  void _applyFilters() {
    List<T> filtered = widget.originalList.where((item) {
      // Name filter
      final name = widget.getNameFromItem(item).toLowerCase();
      final searchTerm = _searchController.text.toLowerCase();
      final nameMatches = searchTerm.isEmpty || name.contains(searchTerm);

      // Date filter
      final itemDate = widget.getDateFromItem(item);
      bool dateMatches = true;

      if (itemDate != null) {
        if (_fromDate != null) {
          dateMatches = dateMatches &&
              itemDate.isAfter(_fromDate!.subtract(Duration(days: 1)));
        }
        if (_toDate != null) {
          dateMatches =
              dateMatches && itemDate.isBefore(_toDate!.add(Duration(days: 1)));
        }
      } else if (_fromDate != null || _toDate != null) {
        // If item has no date but date filter is applied, exclude it
        dateMatches = false;
      }

      return nameMatches && dateMatches;
    }).toList();

    setState(() {
      _filteredList = filtered;
    });

    widget.onFilterChanged(_filteredList);
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      _applyFilters();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _fromDate = null;
      _toDate = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search and Clear Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) => _applyFilters(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _clearFilters,
                  icon: Icon(Icons.clear, size: 18),
                  label: Text("Clear"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Date Filter Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.blueAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            _fromDate != null
                                ? "From: ${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}"
                                : "From Date",
                            style: TextStyle(
                              color: _fromDate != null
                                  ? Colors.black
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.blueAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            _toDate != null
                                ? "To: ${_toDate!.day}/${_toDate!.month}/${_toDate!.year}"
                                : "To Date",
                            style: TextStyle(
                              color: _toDate != null
                                  ? Colors.black
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Results Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Records: ${widget.originalList.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  "Filtered: ${_filteredList.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
