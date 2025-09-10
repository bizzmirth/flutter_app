import 'package:flutter/material.dart';

class TcCurrentBookingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TcCurrentBookingDataSource({required this.data});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final currentBooking = data[index];
    return DataRow(cells: [
      DataCell(Text(currentBooking['bookingId'])),
      DataCell(Text(currentBooking['customerName'])),
      DataCell(Text(currentBooking['packageName'])),
      DataCell(Text(currentBooking['amount']?.toString() ?? 'N/A')),
      DataCell(Text(currentBooking['bookingDate'])),
      DataCell(Text(currentBooking['travelDate'])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
