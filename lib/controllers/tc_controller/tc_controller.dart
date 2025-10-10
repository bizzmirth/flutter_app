import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_dashboard_stat_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  DashboardStatsModel? _dashboardStats;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DashboardStatsModel? get dashboardStats => _dashboardStats;
  String? get totalRegisteredCustomers =>
      _dashboardStats?.data?.registeredCustomers?.total;
  String? get monthlyRegisteredCustomers =>
      _dashboardStats?.data?.registeredCustomers?.thisMonth;

  String? get totalCompletedTours =>
      _dashboardStats?.data?.completedTours?.total;
  String? get monthlyCompletedTours =>
      _dashboardStats?.data?.completedTours?.thisMonth;

  String? get totalUpcomingTours => _dashboardStats?.data?.upcomingTours?.total;
  String? get monthlyUpcomingTours =>
      _dashboardStats?.data?.upcomingTours?.thisMonth;

  String? get confirmedCommission =>
      _dashboardStats?.data?.commission?.confirmed;
  String? get pendingCommission => _dashboardStats?.data?.commission?.pending;

  TcController() {
    getDashboardDataCounts();
  }

  Future<void> getDashboardDataCounts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String url = AppUrls.getTechnoEnterpriseDashboardCounts;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        'userId': userId,
      };

      final encodeBody = json.encode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('Fetching dashboard counts from $url with body: $body');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Logger.info('Dashboard counts response: $jsonResponse');

        _dashboardStats = DashboardStatsModel.fromJson(jsonResponse);

        if (_dashboardStats?.status == 'success') {
          Logger.info('Dashboard stats fetched successfully');
        } else {
          _error = 'Failed to fetch dashboard stats';
          Logger.error('Dashboard stats status not success');
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error('Server error: ${response.statusCode}');
      }
    } catch (e, s) {
      Logger.error('Error fetching dashboard counts: Error $e, StackTrace: $s');
      _error = 'An error occurred while fetching dashboard counts.';
      _dashboardStats = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
