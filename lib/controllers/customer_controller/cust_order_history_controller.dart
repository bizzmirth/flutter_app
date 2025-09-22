import 'dart:convert';

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

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get pendingBookingCount => _pendingBookingCount;
  String? get completedBookingCount => _completedBookingCount;
  String? get pendingPaymentAmt => _pendingPaymentAmt;
  String? get completedPaymentAmt => _completedPaymentAmt;

  Future<void> apiGetStatCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getOrderHistoryStatCounts;

      final String? userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {'userId': userId, 'userType': '10'};
      final encodeBody = jsonEncode(body);
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
}
