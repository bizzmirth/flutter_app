import 'dart:convert';

import 'package:bizzmirth_app/models/cust_referral_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustReferralPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? _prevMonth;
  String? _nextMonth;
  String? _year;
  String? _totalPayout;
  String? _previousMonthPayout;
  String? _nextMonthPayout;

  String? get prevMonth => _prevMonth;
  String? get nextMonth => _nextMonth;
  String? get year => _year;
  String? get previousMonthPayout => _previousMonthPayout;
  String? get nextMonthPayout => _nextMonthPayout;
  String? get totalPayout => _totalPayout;

  final List<CustReferralPayoutModel> _allPayouts = [];
  List<CustReferralPayoutModel> get allPayouts => _allPayouts;

  final List<CustReferralPayoutModel> __previousMonthAllPayouts = [];
  List<CustReferralPayoutModel> get previousMonthAllPayouts =>
      __previousMonthAllPayouts;

  final List<CustReferralPayoutModel> _nextMonthAllPayouts = [];
  List<CustReferralPayoutModel> get nextMonthAllPayouts => _nextMonthAllPayouts;

  final List<CustReferralPayoutModel> _totalAllPayouts = [];
  List<CustReferralPayoutModel> get totalAllPayouts => _totalAllPayouts;

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
              final payout = CustReferralPayoutModel.fromJson(payoutJson);
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

  void apiGetPreviousMonthPayouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/reference_payouts/customer_prev_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final now = DateTime.now();
      final prevMonth =
          (now.month == 1 ? 12 : now.month - 1).toString().padLeft(2, '0');
      final currentYear = now.year.toString();
      final Map<String, dynamic> body = {
        "userId": userId,
        "month": prevMonth,
        "year": currentYear
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Fetching previous month payouts for userId: $encodeBody");
      final response = await http.post(Uri.parse(fullUrl),
          headers: {"Content-Type": "application/json"}, body: encodeBody);
      Logger.success("Response from previous month payouts: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['summary'];
        final payoutsData = data['data'] as List<dynamic>?;
        _prevMonth = prevMonth;
        _year = currentYear;
        _previousMonthPayout = summary['total_payout']?.toString();

        __previousMonthAllPayouts.clear();

        if (payoutsData != null && payoutsData.isNotEmpty) {
          for (var payoutJson in payoutsData) {
            try {
              final payoutModel = CustReferralPayoutModel.fromJson(payoutJson);
              __previousMonthAllPayouts.add(payoutModel);
            } catch (e) {
              Logger.error("Error parsing payout model: $e");
            }
          }
          Logger.success(
              "Successfully populated previous all payouts ${__previousMonthAllPayouts.length} payout records");
        } else {
          Logger.warning("No payout data found in response");
        }
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching previous payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch previous payouts. Error: $e, Stacktree: $s.";
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
          "https://testca.uniqbizz.com/api/payouts/reference_payouts/customer_next_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final now = DateTime.now();
      final nextMonth = (now.month % 12 + 1).toString().padLeft(2, '0');
      final currentYear = now.year.toString();
      final Map<String, dynamic> body = {
        "userId": userId,
        "month": nextMonth,
        "year": currentYear
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Fetching next month payouts for userId: $encodeBody");
      final response = await http.post(Uri.parse(fullUrl),
          headers: {"Content-Type": "application/json"}, body: encodeBody);
      Logger.success("Response from next month payouts: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final payoutData = data['data'];
        _nextMonth = nextMonth;
        _year = currentYear;
        _nextMonthPayout = payoutData['total_payout']?.toString();
        final payoutRecords = payoutData['records'] as List<dynamic>?;
        _nextMonthAllPayouts.clear();

        if (payoutRecords != null && payoutRecords.isNotEmpty) {
          for (var payoutJson in payoutRecords) {
            try {
              final payoutModel = CustReferralPayoutModel.fromJson(payoutJson);
              _nextMonthAllPayouts.add(payoutModel);
            } catch (e) {
              Logger.error("Error parsing next month payout model: $e");
            }
          }
          Logger.success(
              "Successfully populated next moth payouts ${_nextMonthAllPayouts.length} next month payout records");
        } else {
          Logger.info("No next month payout records found in response");
        }
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching next month payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch next month payouts. Error: $e, Stacktree: $s.";
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
          "https://testca.uniqbizz.com/api/payouts/reference_payouts/customer_total_payouts.php";
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "userId": userId,
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Fetching total payouts for userId: $encodeBody");
      final response = await http.post(Uri.parse(fullUrl),
          headers: {"Content-Type": "application/json"}, body: encodeBody);
      Logger.success("Response from total payouts: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final payoutRecords = data['records'] as List<dynamic>?;

        _totalPayout = data['total_payout']?.toString();

        _totalAllPayouts.clear();
        if (payoutRecords != null) {
          for (var payoutJson in payoutRecords) {
            try {
              final payoutModel = CustReferralPayoutModel.fromJson(payoutJson);
              _totalAllPayouts.add(payoutModel);
            } catch (e) {
              Logger.error("Error parsing total payout model: $e");
            }
          }
        }
        Logger.success(
            "Successfully populated total payout ${_totalAllPayouts.length} total payout records");
      } else {
        Logger.error("Failed to fetch total payouts: ${response.statusCode}");
        _error = "Failed to fetch total payouts. Please try again later.";
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
