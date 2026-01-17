import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_dashboard_stat_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_top_bookings_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_dashboard/tc_top_customer_referral_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  DashboardStatsModel? _dashboardStats;
  List<double> _chartData = [];
  String? _selectedYear;
  List<TcTopCustomerReferralModel> _tcTopCustomerReferrals = [];
  List<TcTopBookingsModel> _tcTopBookings = [];

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
  List<double> get chartData => _chartData;
  String? get selectedYear => _selectedYear;
  List<TcTopCustomerReferralModel> get tcTopCustomerReferrals =>
      _tcTopCustomerReferrals;
  List<TcTopBookingsModel> get tcTopBookings => _tcTopBookings;

  TcController() {
    intialiseTCDasboard();
  }

  Future<void> intialiseTCDasboard() async {
    await getDashboardDataCounts();
    await apiGetTcTopCustomerReferral();
    await apiGetTcTopBookings();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> getDashboardDataCounts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String url = AppUrls.getTravelConsultantDashboardCounts;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final Map<String, dynamic> body = {
        'userId': userId,
      };

      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('Fetching dashboard counts from $url with body: $body');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
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

  Future<void> apiGetChartData(String selectedYear) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final String url = AppUrls.getTravelConsultantLineChartData;
      final Map<String, dynamic> body = {
        'year': selectedYear,
        'current_year': 2025,
        'userId': userId,
        'user_type': AppData.tcUserType,
      };
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('Fetching line chart data from $url with body: $body');
      Logger.info('Raw response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        Logger.info('Line chart data response: $jsonData');
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is List) {
          // response looks like [[0,0,0,0,0,0,0,0,0,0,0,0]]
          final List<dynamic> dataArray = jsonData[0];
          _chartData =
              dataArray.map((item) => (item as num).toDouble()).toList();
          Logger.success('Line chart data fetched successfully: $_chartData');
          _selectedYear = selectedYear;
          Logger.info('Chart data: $_chartData');
        } else {
          _error = 'Chart Data is empty.';
          _chartData = List.filled(12, 0.0);
          Logger.error('Unexpected data format for line chart data: $jsonData');
        }
      }
    } catch (e, s) {
      Logger.error('Error fetching line chart data: Error $e, StackTrace: $s');
      _error = 'An error occurred while fetching line chart data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FlSpot> getChartSpots() {
    final int currentYear = DateTime.now().year;
    final int currentMonth = DateTime.now().month;
    final int limit = selectedYear == currentYear.toString()
        ? currentMonth
        : _chartData.length;

    final List<FlSpot> spots = [];

    for (int i = 0; i < limit && i < _chartData.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), _chartData[i]));
    }

    return spots;
  }

  Future<void> apiGetTcTopCustomerReferral() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final String url = AppUrls.getTravelConsultantTopReferralCustomers;
      final Map<String, dynamic> body = {
        'userId': userId,
      };
      final encodeBody = jsonEncode(body);

      Logger.info('Fetching top customer referrals from $url with body: $body');

      final response = await http.post(Uri.parse(url), body: encodeBody);

      Logger.info('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          _tcTopCustomerReferrals = [];

          if (jsonResponse['top_customers'] != null) {
            final List<dynamic> customersList = jsonResponse['top_customers'];

            for (var customerJson in customersList) {
              _tcTopCustomerReferrals
                  .add(TcTopCustomerReferralModel.fromJson(customerJson));
            }

            Logger.info(
                'Top customer referrals fetched successfully. Count: ${_tcTopCustomerReferrals.length}');
          } else {
            Logger.warning('No top customers found in response');
          }
        } else {
          // _error = 'Failed to fetch top customer referrals';
          // Logger.error('Top customer referrals status not success');
          _tcTopCustomerReferrals = [];
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error('Server error: ${response.statusCode}');
      }
    } catch (e, s) {
      Logger.error(
          'Error fetching top customer referrals: Error $e, StackTrace: $s');
      _error =
          'An error occurred while fetching top customer referrals. Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTcTopBookings() async {
    try {
      final url = AppUrls.getTravelConsultantCurrentBookings;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final Map<String, dynamic> body = {
        'userId': userId,
      };
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('Fetching top bookings from $url with body: $body');
      Logger.info('Raw response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          _tcTopBookings.clear();
          final List<dynamic> bookingsList = jsonResponse['data'];
          _tcTopBookings = bookingsList
              .map((bookingJson) => TcTopBookingsModel.fromJson(bookingJson))
              .toList();
          Logger.info(
              'Top bookings fetched successfully. Count: ${_tcTopBookings.length}');
        } else {
          // _error = 'Failed to fetch top bookings';
          _tcTopBookings = [];
          Logger.error('Top bookings status not success or data is null');
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error('Server error: ${response.statusCode}');
      }
    } catch (e, s) {
      Logger.error('Error fetching top bookings: Error $e, StackTrace: $s');
      _error = 'An error occurred while fetching top bookings. Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
