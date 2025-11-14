import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime initialDate;

  // Callback when a day is selected
  final ValueChanged<DateTime>? onDateSelected;

  // Callback when clear is pressed
  final VoidCallback? onClearPressed;

  // Callback when today is pressed
  final VoidCallback? onTodayPressed;

  // Event loader for showing markers
  final List Function(DateTime)? eventLoader;

  const CalendarWidget({
    super.key,
    required this.initialDate,
    this.onDateSelected,
    this.onClearPressed,
    this.onTodayPressed,
    this.eventLoader,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          // Calendar container
          Container(
            height: 420,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030, 12, 31),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              eventLoader: widget.eventLoader ?? (_) => [],
              onDaySelected: (day, focusedDay) {
                setState(() => _selectedDate = day);

                if (widget.onDateSelected != null) {
                  widget.onDateSelected!(day);
                }
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
              ),
            ),
          ),

          // TODAY button
          Positioned(
            top: 20,
            right: 90,
            child: ElevatedButton(
              onPressed: () {
                final today = DateTime.now();
                setState(() => _selectedDate = today);

                widget.onTodayPressed?.call();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Today',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // CLEAR button
          Positioned(
            top: 20,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                final today = DateTime.now();
                setState(() => _selectedDate = today);

                widget.onClearPressed?.call();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                backgroundColor: Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
