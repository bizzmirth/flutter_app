class PayoutData {
  final String id;
  final String date;
  final String payoutDetails;
  final String amount;
  final String tds;
  final String totalPayable;
  final String remark;

  PayoutData({
    required this.id,
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.remark,
  });

  factory PayoutData.fromJson(Map<String, dynamic> json) {
    return PayoutData(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      payoutDetails: json['payout_details'] ?? '',
      amount: json['amount'] ?? '0.00',
      tds: json['tds'] ?? '0.00',
      totalPayable: json['total_payable'] ?? '0.00',
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'payout_details': payoutDetails,
      'amount': amount,
      'tds': tds,
      'total_payable': totalPayable,
      'remark': remark,
    };
  }
}
