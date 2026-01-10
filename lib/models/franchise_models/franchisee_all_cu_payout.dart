class FranchiseeAllCuPayouts {
  final String id;
  final String date;
  final String payoutDetails;
  final double amount;
  final double tds;
  final double totalPayable;
  final String status;

  FranchiseeAllCuPayouts({
    required this.id,
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory FranchiseeAllCuPayouts.fromJson(Map<String, dynamic> json) {
    return FranchiseeAllCuPayouts(
      id: json['id']?.toString() ?? '',
      date: json['date'] ?? '',
      payoutDetails: json['payout_details'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      tds: (json['tds'] ?? 0).toDouble(),
      totalPayable: (json['total_payable'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}
