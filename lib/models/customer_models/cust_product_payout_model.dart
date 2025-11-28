class CustProductPayoutModel {
  final String date;
  final String payoutDetails;
  final String message;
  final String amount;
  final String tds;
  final String totalPayable;
  final String status;

  CustProductPayoutModel({
    required this.date,
    required this.payoutDetails,
    required this.message,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory CustProductPayoutModel.fromJson(Map<String, dynamic> json) {
    return CustProductPayoutModel(
      date: json['date']?.toString() ?? '',
      payoutDetails: json['payout_details']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      tds: json['tds']?.toString() ?? '',
      totalPayable:
          (json['total_payable'] ?? json['totalPayable'])?.toString() ?? '',
      status: json['status']?.toString() ?? '',
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
    };
  }
}
