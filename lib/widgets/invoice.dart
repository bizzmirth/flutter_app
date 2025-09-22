import 'package:flutter/material.dart';

class InvoiceWidget extends StatelessWidget {
  final String invoiceNumber;
  final String bookingNumber;
  final String paymentStatus;
  final String transactionId;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String package;
  final String departureDate;
  final String memberCount;
  final List<Map<String, String>> tourMembers;
  final double price;
  final String currencySymbol;

  const InvoiceWidget({
    super.key,
    required this.invoiceNumber,
    required this.bookingNumber,
    required this.paymentStatus,
    required this.transactionId,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.package,
    required this.departureDate,
    required this.memberCount,
    required this.tourMembers,
    required this.price,
    this.currencySymbol = '¥',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _buildHeaderSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Customer details section
          _buildCustomerDetailsSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Tour members section
          _buildTourMembersSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Amount section
          _buildAmountSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Footer section
          _buildFooterSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UNIQBIZZ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'INVOICE NO. $invoiceNumber',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Booking No. $bookingNumber',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Payment: $paymentStatus',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: paymentStatus.toLowerCase() == 'successful'
                ? Colors.green
                : Colors.red,
          ),
        ),
        Text(
          'Transaction ID: $transactionId',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('Destination', ''),
            _buildTableRow('Order ID', bookingNumber),
            _buildTableRow('Customer ID', customerId),
            _buildTableRow('Name', customerName),
            _buildTableRow('Email', customerEmail),
            _buildTableRow('Phone No', customerPhone),
            _buildTableRow('Package', package),
            _buildTableRow('Departure Date', departureDate),
            _buildTableRow('Member Count', memberCount),
          ],
        ),
      ],
    );
  }

  Widget _buildTourMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tour Members',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(0.5),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(0.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade200),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sr.No',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Gender',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Age',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...tourMembers.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${index + 1}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(member['name'] ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(member['gender'] ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(member['age'] ?? ''),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
      },
      children: [
        _buildTableRow('Price:', '$currencySymbol$price'),
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$currencySymbol$price',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return const Column(
      children: [
        Text(
          '364 – 356, Europe\'s Towers, Paris Plaza Purifim - Gos - 453501',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          'www.unicedar.com',
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
        SizedBox(height: 4),
        Text(
          'kappapt@unicedar.com',
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
        SizedBox(height: 4),
        Text(
          '8883755714 / 010562255',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
