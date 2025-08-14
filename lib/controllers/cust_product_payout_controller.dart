import 'dart:convert';

import 'package:bizzmirth_app/models/cust_product_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustProductPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  String? _prevMonth;
  final List<CustProductPayoutModel> _allPayouts = [];
  String? _nextMonth;
  String? _year;
  String? _totalPayout;
  String? _previousMonthPayout;
  String? _nextMonthPayout;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get prevMonth => _prevMonth;
  String? get nextMonth => _nextMonth;
  String? get year => _year;
  String? get previousMonthPayout => _previousMonthPayout;
  String? get nextMonthPayout => _nextMonthPayout;
  String? get totalPayout => _totalPayout;

  List<CustProductPayoutModel> get allPayouts => _allPayouts;

  void getAllPayouts(userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/reference_payouts/customer_all_payouts.php";

      final Map<String, dynamic> body = {
        "userId": userId,
      };
      Logger.warning("Fetching all payouts for userId: $userId");
      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      Logger.success("Response from all payout: ${response.body}");

      if (response.statusCode == 200) {
        _allPayouts.clear();
        final data = jsonDecode(response.body);
        Logger.success("Data fetched successfully: $data");

        if (data['status'] == true && data['data'] is List) {
          final List<dynamic> payoutList = data['data'];

          for (var payoutJson in payoutList) {
            try {
              final payout = CustProductPayoutModel.fromJson(payoutJson);
              _allPayouts.add(payout);
            } catch (e) {
              Logger.error("Error parsing payout item: $e");
            }
          }

          Logger.success("Successfully loaded ${_allPayouts.length} payouts");
        } else {
          Logger.error(
              "Invalid response structure: ${data['message'] ?? 'Unknown error'}");
          _error = data['message'] ?? "Invalid response format";
        }
      } else {
        Logger.error("Failed to fetch payouts: ${response.statusCode}");
        _error = "Failed to fetch payouts. Please try again later.";
      }
    } catch (e, s) {
      Logger.error("Error fetching payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch payouts. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void apiGetPreviousPayouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/product_payouts/customer_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final now = DateTime.now();
      final currentMonth = now.month.toString().padLeft(2, '0'); // "08"
      final currentYear = now.year.toString();
      final Map<String, dynamic> body = {
        "action": "previous",
        "userId": userId,
        "userType": "10"
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Previous Payout Request Body: $encodeBody");

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: encodeBody);

      Logger.success("Response from previous payouts: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          Logger.success("Data fetched successfully: $data");
          _prevMonth = currentMonth;
          _year = currentYear;
          _previousMonthPayout = data['totalPayable']?.toString();
        } else {
          Logger.error("API returned unsuccessful status or no data");
          _error = "No payout data available for the previous month.";
        }
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching previous payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch previous payouts. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void apiGetNextMonthPayouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/product_payouts/customer_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final now = DateTime.now();
      final nextMonth = (now.month).toString().padLeft(2, '0');
      final nextYear = (now.year + (now.month == 12 ? 1 : 0)).toString();
      final Map<String, dynamic> body = {
        "action": "next",
        "userId": userId,
        "userType": "10",
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Next Month Payout Request Body: $encodeBody");

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: encodeBody);

      Logger.success("Response from next month payouts: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          Logger.success("Data fetched successfully: $data");
          _nextMonth = nextMonth;
          _year = nextYear;
          _nextMonthPayout = data['totalPayable']?.toString();
        } else {
          Logger.error("API returned unsuccessful status or no data");
          _error = "No payout data available for next month.";
        }
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching next month payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch next month payouts. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void apiGetTotalPayouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/product_payouts/customer_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "action": "total",
        "userId": userId,
        "userType": "10"
      };
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("Response from total payouts: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Logger.success(
            "Data fetched successfully for all payouts: $responseData");

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          _totalPayout = data['totalAmount']?.toString() ?? '0';
        } else {
          Logger.error("API returned unsuccessful status or no data");
          _error = "No total payout data available.";
        }
      }
    } catch (e, s) {
      Logger.error("Error fetching total payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch total payouts. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
