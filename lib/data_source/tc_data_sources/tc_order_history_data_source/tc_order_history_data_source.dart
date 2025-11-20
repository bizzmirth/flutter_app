import 'package:bizzmirth_app/models/order_history/order_history_model.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/order_history/order_details_screen.dart';
import 'package:flutter/material.dart';

class TcOrderHistoryDataSource extends DataTableSource {
  final List<OrderHistoryModel> data;
  TcOrderHistoryDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())), // Sr. No.
        DataCell(Text(order.orderId ?? 'N/A')),
        DataCell(Text(order.date ?? 'N/A')),
        DataCell(Text(order.packageName ?? 'N/A')),
        DataCell(Text(order.customer?.name ?? 'N/A')),
        DataCell(Text(order.travelAgency?.firstname ?? 'N/A')),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Stack(
                children: [
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 14,
                    width: (order.payment?.percentFill ?? 0) > 100
                        ? 100
                        : (order.payment?.percentFill ?? 0).toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '${order.payment?.percentFill ?? 0}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Payment Text
              Text(
                "Paid Rs.${(double.tryParse(order.payment?.paidAmount ?? '0')?.toInt() ?? 0)} "
                "of Rs.${(double.tryParse(order.payment?.fullAmount ?? '0')?.toInt() ?? 0)}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.status ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'travelling':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // handle actions
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: const Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: const Text('View'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderDetailsScreen()));
            },
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color(0xFF0069BE)),
            title: Text('Download Itineraries'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
