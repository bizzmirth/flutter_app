import 'package:flutter/material.dart';

class EmptyDataSource extends DataTableSource {
  final String message;
  final IconData icon;
  final int columnCount;
  final Color? messageColor;
  final double? fontSize;

  EmptyDataSource({
    this.message = 'No data available',
    this.icon = Icons.inbox_outlined,
    required this.columnCount,
    this.messageColor,
    this.fontSize = 16.0,
  });

  @override
  DataRow? getRow(int index) {
    if (index == 0) {
      // Create a list of empty DataCell widgets for all columns except the middle one
      final List<DataCell> cells = [];

      final int middleIndex = (columnCount / 2).floor();

      for (int i = 0; i < columnCount; i++) {
        if (i == middleIndex) {
          // Middle column shows the message with icon
          cells.add(
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: messageColor ?? Colors.grey.shade600,
                    size: fontSize! + 4,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: TextStyle(
                      color: messageColor ?? Colors.grey.shade600,
                      fontSize: fontSize,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Other columns are empty
          cells.add(const DataCell(SizedBox.shrink()));
        }
      }

      return DataRow(cells: cells);
    }
    return null;
  }

  @override
  int get rowCount => 1; // Only one row to show the message

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
