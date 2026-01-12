import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payout.dart';

class TcRecruitmentResponse {
  final String status;
  final TcRecruitmentData? data;

  TcRecruitmentResponse({
    required this.status,
    this.data,
  });

  factory TcRecruitmentResponse.fromJson(Map<String, dynamic> json) {
    return TcRecruitmentResponse(
      status: json['status']?.toString() ?? '',
      data:
          json['data'] != null ? TcRecruitmentData.fromJson(json['data']) : null,
    );
  }
}
