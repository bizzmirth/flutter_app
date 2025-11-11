import 'dart:convert';

import 'package:bizzmirth_app/models/customer_models/cust_order_history_recent_booking.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustOrderHistoryController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _pendingBookingCount;
  String? _completedBookingCount;
  String? _pendingPaymentAmt;
  String? _completedPaymentAmt;
  List<CustOrderHistoryRecentBooking> _custOrderHistoryRecentBooking = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get pendingBookingCount => _pendingBookingCount;
  String? get completedBookingCount => _completedBookingCount;
  String? get pendingPaymentAmt => _pendingPaymentAmt;
  String? get completedPaymentAmt => _completedPaymentAmt;
  List<CustOrderHistoryRecentBooking> get custOrderHistoryRecentBooking =>
      _custOrderHistoryRecentBooking;

  CustOrderHistoryController() {
    initalizeData();
  }

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> initalizeData() async {
    await apiGetStatCount();
    await apiGetRecentBookings();
  }

  Future<void> apiGetStatCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getOrderHistoryStatCounts;
      final userId = await _getUserId();
      final Map<String, dynamic> body = {'userId': userId, 'userType': '10'};
      final encodeBody = jsonEncode(body);
      // Logger.info('api called made for $fullUrl and body: $encodeBody');
      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/json'}, body: encodeBody);
      if (response.statusCode == 200) {
        Logger.success('Response from order get count api: ${response.body}');
        final Map<String, dynamic> data = jsonDecode(response.body);
        _pendingBookingCount = data['pending_booking_count']?.toString();
        _completedBookingCount = data['completed_booking_count']?.toString();
        _pendingPaymentAmt = data['pending_payment_amt']?.toString();
        _completedPaymentAmt = data['completed_payment_amt']?.toString();
      } else {
        Logger.error('Failed with status code: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching order stat counts: $e';
      Logger.error('Error fetching order stat counts: Error:$e, Stacktree: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetRecentBookings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getRecentBookings;

      final userId = await _getUserId();
      final userTypeId = AppData.customerUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userTypeId
      };
      final encodeBody = jsonEncode(body);
      Logger.info('api call made for $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('response from the recent booking api ${response.body}');
      if (response.statusCode == 200) {
        _custOrderHistoryRecentBooking.clear();
        final jsonData = jsonDecode(response.body);
        if (jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _custOrderHistoryRecentBooking = bookings
              .map((item) => CustOrderHistoryRecentBooking.fromJson(item))
              .toList();
          Logger.info(
              'successfully fetched ${_custOrderHistoryRecentBooking.length}');
        } else {
          _custOrderHistoryRecentBooking = [];
          Logger.info(
              'recent booking customer returned empty. ${response.body}');
        }
      } else {
        _error = 'Error in the HTTP method. ${response.statusCode}';
        Logger.error(
            'Error in the api call. ${response.statusCode} and ${response.body}');
      }
    } catch (e, s) {
      _error = 'Error fetching recent bookings: Error:$e';
      Logger.error('Error fetching recent bookings: Error: $e, Stacktrace:$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
