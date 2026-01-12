import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/tc_cu_total_payout_model.dart';

class TcCuTotalPayoutResponse {
  bool? status;
  String? message;
  String? totalPayout;
  List<TcCuTotalPayoutModel>? payouts;

  TcCuTotalPayoutResponse({
    this.status,
    this.message,
    this.totalPayout,
    this.payouts,
  });

  TcCuTotalPayoutResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      totalPayout = json['data']['total_payout']?.toString();
      if (json['data']['payouts'] != null) {
        payouts = <TcCuTotalPayoutModel>[];
        json['data']['payouts'].forEach((v) {
          payouts!.add(TcCuTotalPayoutModel.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['total_payout'] = totalPayout;
    if (payouts != null) {
      dataMap['payouts'] = payouts!.map((v) => v.toJson()).toList();
    }
    data['data'] = dataMap;
    return data;
  }
}
