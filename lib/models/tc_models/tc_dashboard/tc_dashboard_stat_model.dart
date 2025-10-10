import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_dashboard_data_model.dart';

class DashboardStatsModel {
  String? status;
  DashboardData? data;

  DashboardStatsModel({this.status, this.data});

  DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
