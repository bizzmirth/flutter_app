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

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
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
      id: _parseString(json['id']),
      date: _parseString(json['date']),
      payoutDetails: _parseString(
        json['payout_details'] ?? json['payoutDetails'],
      ),
      amount: _parseDouble(json['amount']),
      tds: _parseDouble(json['tds']),
      totalPayable: _parseDouble(
        json['total_payable'] ?? json['totalPayable'],
      ),
      status: _parseString(json['status']),
    );
  }
}
