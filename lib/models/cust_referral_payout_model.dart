class CustReferralPayoutModel {
  final String date;
  final String payoutDetails;
  final String amount;
  final String tds;
  final String totalPayable;
  final String status;

  CustReferralPayoutModel({
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory CustReferralPayoutModel.fromJson(Map<String, dynamic> json) {
    return CustReferralPayoutModel(
      date: json['date']?.toString() ?? '',
      payoutDetails: json['message']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      tds: json['tds']?.toString() ?? '',
      totalPayable: json['total_payable']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'message': payoutDetails,
      'amount': amount,
      'tds': tds,
      'total_payable': totalPayable,
      'status': status,
    };
  }
}
