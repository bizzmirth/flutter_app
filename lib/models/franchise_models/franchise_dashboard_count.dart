import 'package:bizzmirth_app/models/franchise_models/data.dart';

class FranchiseDashboardCount {
  bool? status;
  Data? data;

  FranchiseDashboardCount({this.status, this.data});

  FranchiseDashboardCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}
