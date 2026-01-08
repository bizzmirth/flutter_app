class ProductAllPayoutModel {
  final String date;
  final String message;
  final String? markup;
  final double amount;
  final double tds;
  final double totalPayable;
  final String status;

  ProductAllPayoutModel({
    required this.date,
    required this.message,
    required this.markup,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory ProductAllPayoutModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProductAllPayoutModel(
      date: json['date'] ?? '',
      message: json['message'] ?? '',
      markup: json['markup']?.toString(),
      amount: parseDouble(json['amount']),
      tds: parseDouble(json['tds']),
      totalPayable: parseDouble(json['total_payable']),
      status: json['status'] ?? '',
    );
  }
}
