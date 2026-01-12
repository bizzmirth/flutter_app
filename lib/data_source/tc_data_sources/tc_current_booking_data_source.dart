import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_top_bookings_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TcCurrentBookingDataSource extends DataTableSource {
  final List<TcTopBookingsModel> data;
  TcCurrentBookingDataSource({required this.data});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final currentBooking = data[index];
    return DataRow(cells: [
      DataCell(Text(currentBooking.orderId ?? 'N/A')),
      DataCell(Text(currentBooking.name ?? 'N/A')),
      DataCell(Text(currentBooking.packageName ?? 'N/A')),
      DataCell(Text(currentBooking.amount ?? 'N/A')),
      DataCell(Text(formatDate(currentBooking.bookingDate))),
      DataCell(Text(formatDate(currentBooking.travelDate))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
