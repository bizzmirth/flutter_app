class CuMembershipPayoutResponse {
  final String status;
  final CuMembershipPayoutData data;

  CuMembershipPayoutResponse({
    required this.status,
    required this.data,
  });

  factory CuMembershipPayoutResponse.fromJson(Map<String, dynamic> json) {
    return CuMembershipPayoutResponse(
      status: json['status'] ?? '',
      data: CuMembershipPayoutData.fromJson(json['data'] ?? {}),
    );
  }
}

class CuMembershipPayoutData {
  final PayoutSummary summary;
  final List<PayoutItem> payouts;
  final int count;

  CuMembershipPayoutData({
    required this.summary,
    required this.payouts,
    required this.count,
  });

  factory CuMembershipPayoutData.fromJson(Map<String, dynamic> json) {
    return CuMembershipPayoutData(
      summary: PayoutSummary.fromJson(json['summary'] ?? {}),
      payouts: (json['payouts'] as List? ?? [])
          .map((e) => PayoutItem.fromJson(e))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

class PayoutSummary {
  final double totalPayout;
  final double tdsAmount;
  final double totalPayable;
  final double tdsPercentage;
  final String year;
  final String month;

  PayoutSummary({
    required this.totalPayout,
    required this.tdsAmount,
    required this.totalPayable,
    required this.tdsPercentage,
    required this.year,
    required this.month,
  });

  factory PayoutSummary.fromJson(Map<String, dynamic> json) {
    return PayoutSummary(
      totalPayout: (json['total_payout'] ?? 0).toDouble(),
      tdsAmount: (json['tds_amount'] ?? 0).toDouble(),
      totalPayable: (json['total_payable'] ?? 0).toDouble(),
      tdsPercentage: (json['tds_percentage'] ?? 0).toDouble(),
      year: json['year'] ?? '',
      month: json['month'] ?? '',
    );
  }
}

class PayoutItem {
  final String id;
  final String date;
  final String payoutDetails;
  final double amount;
  final double tds;
  final double totalPayable;
  final String status;

  PayoutItem({
    required this.id,
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.status,
  });

  factory PayoutItem.fromJson(Map<String, dynamic> json) {
    return PayoutItem(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      payoutDetails: json['payout_details'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      tds: (json['tds'] ?? 0).toDouble(),
      totalPayable: (json['total_payable'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}
