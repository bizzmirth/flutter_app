import 'package:isar_community/isar.dart';

@collection
class TopCustomerRefereralModel {
  String? caCustomerId;
  String? name;
  String? registeredDate;
  String? profilePic;
  String? status;
  int? totalReferals;
  int? activeReferrals;
  int? inActiveReferrals;

  TopCustomerRefereralModel();

  factory TopCustomerRefereralModel.fromJson(Map<String, dynamic> json) {
    return TopCustomerRefereralModel()
      ..caCustomerId = json['ca_customer_id']
      ..name = json['name']
      ..registeredDate = json['register_date']
      ..profilePic = json['profile_pic']
      ..status = json['status']
      ..totalReferals = json['total_referrals']
      ..activeReferrals = json['active_referrals']
      ..inActiveReferrals = json['inactive profile'];
  }
}
