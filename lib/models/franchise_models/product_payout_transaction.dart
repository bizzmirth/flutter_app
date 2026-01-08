class ProductPayoutTransaction {
  final String date;
  final String packageName;
  final String customerName;
  final String noOfAdults;
  final String noOfChildren;
  final String message;
  final double amount;
  final double tds;
  final double totalPayable;
  final String status;

  ProductPayoutTransaction({
    required this.date,
    required this.packageName,
    required this.customerName,
    required this.noOfAdults,
    required this.noOfChildren,
    required this.message,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory ProductPayoutTransaction.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProductPayoutTransaction(
      date: json['date'] ?? '',
      packageName: json['packageName'] ?? '',
      customerName: json['customerName'] ?? '',
      noOfAdults: json['noOfAdults']?.toString() ?? '0',
      noOfChildren: json['noOfChildren']?.toString() ?? '0',
      message: json['message'] ?? '',
      amount: parseDouble(json['amount']),
      tds: parseDouble(json['tds']),
      totalPayable: parseDouble(json['totalPayable']),
      status: json['status'] ?? '',
    );
  }
}
