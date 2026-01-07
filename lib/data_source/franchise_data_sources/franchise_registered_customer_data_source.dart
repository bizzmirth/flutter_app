import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_customer.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/status_badge.dart';
import 'package:flutter/material.dart';

class FranchiseRegisteredCustomerDataSource extends DataTableSource {
  final List<FranchiseeRegisteredCustomer> data;
  FranchiseRegisteredCustomerDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text('${order.caCustomerId} - ${order.firstname} ${order.lastname}')),
        DataCell(Text('${order.taReferenceNo} - ${order.taReferenceName}')),
        DataCell(Text('${order.customerType}/${isComplimentary(order.compChek)}')),
        DataCell(Text(order.contactNo ?? 'N/A')),
        DataCell(Text(formatDate(order.registerDate))),
        DataCell(
          StatusBadge(status: order.status!)
        ),
      ],
    );
  }

  

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
