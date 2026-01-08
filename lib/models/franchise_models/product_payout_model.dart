import 'package:bizzmirth_app/models/franchise_models/product_payout_transaction.dart';

class ProductPayoutModel {
  final String period;
  final double totalAmount;
  final double totalTds;
  final double totalPayable;
  final List<ProductPayoutTransaction> transactions;

  ProductPayoutModel({
    required this.period,
    required this.totalAmount,
    required this.totalTds,
    required this.totalPayable,
    required this.transactions,
  });

  factory ProductPayoutModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProductPayoutModel(
      period: json['period'] ?? '',
      totalAmount: parseDouble(json['totalAmount']),
      totalTds: parseDouble(json['totalTDS']),
      totalPayable: parseDouble(json['totalPayable']),
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => ProductPayoutTransaction.fromJson(e))
          .toList(),
    );
  }
}
