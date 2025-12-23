import 'package:bizzmirth_app/models/franchise_models/franchisee_top_tc.dart';
import 'package:flutter/material.dart';

class FranchiseTopTcDataSource extends DataTableSource {
  final List<FranchiseeTopTc> data;
  FranchiseTopTcDataSource({required this.data});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customer = data[index];
    return DataRow(cells: [
      DataCell(Text(customer.id ?? 'N/A')),
      DataCell(Text(customer.name ?? 'N/A')),
      DataCell(Text(customer.registerDate ?? 'N/A')),
      DataCell(Text(customer.totalReferrals?.toString() ?? 'N/A')),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${customer.activeCount ?? 0}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(
                      text: ' / ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '${customer.inactiveCount ?? 0}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
