import 'package:flutter/material.dart';

class CurrentBookingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  CurrentBookingDataSource(this.data);
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final entries = data[index];

    return DataRow(cells: [
      DataCell(Text(entries["bookingId"])),
      DataCell(Text(entries["customerName"])),
      DataCell(Text(entries["packageName"])),
      DataCell(Text(entries["amount"].toString())),
      DataCell(Text(entries["bookingDate"])),
      DataCell(Text(entries["travelDate"])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
