import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_top_customer_referral_model.dart';
import 'package:flutter/material.dart';

class TcTopCustomersDataSource extends DataTableSource {
  final List<TcTopCustomerReferralModel> data;
  TcTopCustomersDataSource({required this.data});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customers = data[index];
    return DataRow(cells: [
      DataCell(Text(customers.id ?? 'N/A')),
      DataCell(Text(customers.name ?? 'N/A')),
      DataCell(Text(customers.registerDate ?? 'N/A')),
      DataCell(Text(customers.totalReferrals ?? 'N/A')),
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
                      text: '${customers.activeCount}',
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
                      text: '${customers.inactiveCount ?? 0}',
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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
