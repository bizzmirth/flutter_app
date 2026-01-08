import 'package:bizzmirth_app/models/franchise_models/product_payout_transaction.dart';


class ProductTotalPayoutModel {
  final String userId;
  final String userType;
  final double totalAmount;
  final double totalTds;
  final double totalPayable;
  final List<ProductPayoutTransaction> transactions;

  ProductTotalPayoutModel({
    required this.userId,
    required this.userType,
    required this.totalAmount,
    required this.totalTds,
    required this.totalPayable,
    required this.transactions,
  });

  factory ProductTotalPayoutModel.fromJson(Map<String, dynamic> json) {
    return ProductTotalPayoutModel(
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalTds: (json['totalTDS'] ?? 0).toDouble(),
      totalPayable: (json['totalPayable'] ?? 0).toDouble(),
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => ProductPayoutTransaction.fromJson(e))
          .toList(),
    );
  }
}
