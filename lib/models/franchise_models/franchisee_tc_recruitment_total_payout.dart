import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payouts.dart';

class TcRecruitmentTotalResponse {
  final bool success;
  final String message;
  final String amount;
  final List<CuPayoutItem> payoutRecords;

  TcRecruitmentTotalResponse({
    required this.success,
    required this.message,
    required this.amount,
    required this.payoutRecords,
  });

  factory TcRecruitmentTotalResponse.fromJson(Map<String, dynamic> json) {
    return TcRecruitmentTotalResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      payoutRecords: (json['payoutRecords'] as List? ?? [])
          .map((e) => CuPayoutItem.fromJson(e))
          .toList(),
    );
  }
}
