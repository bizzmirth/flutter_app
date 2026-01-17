import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payouts.dart';

class TcRecruitmentData {
  final TcRecruitmentSummary summary;
  final List<CuPayoutItem> payouts;
  final String count;

  TcRecruitmentData({
    required this.summary,
    required this.payouts,
    required this.count,
  });

  factory TcRecruitmentData.fromJson(Map<String, dynamic> json) {
    return TcRecruitmentData(
      summary: TcRecruitmentSummary.fromJson(json['summary'] ?? {}),
      payouts: (json['payouts'] as List? ?? [])
          .map((e) => CuPayoutItem.fromJson(e))
          .toList(),
      count: json['count']?.toString() ?? '0',
    );
  }
}

class TcRecruitmentSummary {
  final String totalPayout;
  final String tdsAmount;
  final String totalPayable;
  final String tdsPercentage;
  final String year;
  final String month;

  TcRecruitmentSummary({
    required this.totalPayout,
    required this.tdsAmount,
    required this.totalPayable,
    required this.tdsPercentage,
    required this.year,
    required this.month,
  });

  factory TcRecruitmentSummary.fromJson(Map<String, dynamic> json) {
    return TcRecruitmentSummary(
      totalPayout: _toString(json['total_payout']),
      tdsAmount: _toString(json['tds_amount']),
      totalPayable: _toString(json['total_payable']),
      tdsPercentage: _toString(json['tds_percentage']),
      year: _toString(json['year']),
      month: _toString(json['month']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_payout': totalPayout,
      'tds_amount': tdsAmount,
      'total_payable': totalPayable,
      'tds_percentage': tdsPercentage,
      'year': year,
      'month': month,
    };
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}

