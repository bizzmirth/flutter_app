import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_commision_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_completed_tour_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_registered_customer_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_upcoming_tour_model.dart';

class DashboardData {
  RegisteredCustomers? registeredCustomers;
  CompletedTours? completedTours;
  UpcomingTours? upcomingTours;
  Commission? commission;

  DashboardData({
    this.registeredCustomers,
    this.completedTours,
    this.upcomingTours,
    this.commission,
  });

  DashboardData.fromJson(Map<String, dynamic> json) {
    registeredCustomers = json['registered_customers'] != null
        ? RegisteredCustomers.fromJson(json['registered_customers'])
        : null;
    completedTours = json['completed_tours'] != null
        ? CompletedTours.fromJson(json['completed_tours'])
        : null;
    upcomingTours = json['upcoming_tours'] != null
        ? UpcomingTours.fromJson(json['upcoming_tours'])
        : null;
    commission = json['commission'] != null
        ? Commission.fromJson(json['commission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (registeredCustomers != null) {
      data['registered_customers'] = registeredCustomers!.toJson();
    }
    if (completedTours != null) {
      data['completed_tours'] = completedTours!.toJson();
    }
    if (upcomingTours != null) {
      data['upcoming_tours'] = upcomingTours!.toJson();
    }
    if (commission != null) {
      data['commission'] = commission!.toJson();
    }
    return data;
  }
}
