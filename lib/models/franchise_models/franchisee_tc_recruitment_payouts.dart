class CuPayoutItem {
  final String date;
  final String payoutDetails;
  final String amount;
  final String tds;
  final String totalPayable;
  final String status;
  final String id;

  CuPayoutItem({
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
    required this.id,
  });

  factory CuPayoutItem.fromJson(Map<String, dynamic> json) {
    return CuPayoutItem(
      date: _toString(json['date']),
      payoutDetails: _toString(json['payout_details']),
      amount: _toString(json['amount']),
      tds: _toString(json['tds']),
      totalPayable: _toString(json['total_payable']),
      status: _toString(json['status']),
      id: _toString(json['id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'payout_details': payoutDetails,
      'amount': amount,
      'tds': tds,
      'total_payable': totalPayable,
      'status': status,
      'id': id,
    };
  }

  /// Converts int / double / String / null → String
  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
