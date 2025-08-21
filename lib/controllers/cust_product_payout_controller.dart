import 'dart:convert';

import 'package:bizzmirth_app/models/cust_product_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustProductPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  String? _prevMonth;
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

  final List<CustProductPayoutModel> _allPayouts = [];
  List<CustProductPayoutModel> get allPayouts => _allPayouts;

  final List<CustProductPayoutModel> _previousMonthAllPayouts = [];
  List<CustProductPayoutModel> get previousMonthAllPayouts =>
      _previousMonthAllPayouts;

  final List<CustProductPayoutModel> _nextMonthAllPayouts = [];
  List<CustProductPayoutModel> get nextMonthAllPayouts => _nextMonthAllPayouts;

  final List<CustProductPayoutModel> _totalAllPayouts = [];
  List<CustProductPayoutModel> get totalAllPayouts => _totalAllPayouts;

  void getAllPayouts(userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl = AppUrls.getAllPayoutsProduct;

      final Map body = {"userId": userId, "userType": "10"};
      Logger.warning("Fetching all payouts for userId: $userId");

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success("Response from all payout: ${response.body}");

      if (response.statusCode == 200) {
        _allPayouts.clear();
        final data = jsonDecode(response.body);
        Logger.success("Data fetched successfully: $data");

        // Updated status check
        if (data['status']?.toString().toLowerCase() == 'success' &&
            data['payouts'] is List) {
          final List payoutList = data['payouts'];

          for (var payoutJson in payoutList) {
            try {
              final payout = CustProductPayoutModel.fromJson(payoutJson);
              _allPayouts.add(payout);
            } catch (e) {
              Logger.error("Error parsing payout item: $e");
            }
          }
          Logger.success("Get all payouts product URL: $fullUrl");
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
      final fullUrl = AppUrls.getPayoutsProduct;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "action": "previous",
        "userId": userId,
        "userType": "10"
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Previous Payout Request Body: $encodeBody");

      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/json'}, body: encodeBody);

      Logger.success("Response from previous payouts: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          Logger.success("Data fetched successfully: $data");
          Logger.success("Get previous payouts product URL: $fullUrl");

          // Clear and populate basic data
          _previousMonthAllPayouts.clear();
          _prevMonth = data['period'];
          _previousMonthPayout = data['totalPayable']?.toString();

          // Handle transactions
          if (data['transactions'] is List) {
            final transactions = data['transactions'] as List;

            if (transactions.isEmpty) {
              Logger.warning("No transactions found for previous month");
            } else {
              Logger.info("Processing ${transactions.length} transactions");

              for (var transaction in transactions) {
                try {
                  final payout = CustProductPayoutModel.fromJson(transaction);
                  _previousMonthAllPayouts.add(payout);
                } catch (e, s) {
                  Logger.error("Error parsing payout transaction: $e");
                  Logger.error("Transaction data: $transaction");
                  Logger.error("StackTrace: $s");
                }
              }
            }

            // Log final count after processing all transactions
            Logger.success(
                "Successfully processed ${_previousMonthAllPayouts.length} payout transactions");
          } else {
            Logger.warning("Transactions field is not a list or is missing");
          }
        } else {
          Logger.error("API returned unsuccessful status or no data");
          Logger.error("Response status: ${responseData['status']}");
          _error = "No payout data available for the previous month.";
        }
      } else {
        Logger.error("HTTP Error: ${response.statusCode}");
        _error = "Server error. Please try again later.";
      }
    } catch (e, s) {
      Logger.error("Error fetching previous payouts: $e");
      Logger.error("StackTrace: $s");
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
      final fullUrl = AppUrls.getPayoutsProduct;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "action": "next",
        "userId": userId,
        "userType": "10",
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Next Month Payout Request Body: $encodeBody");

      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/json'}, body: encodeBody);

      Logger.success("Response from next month payouts: ${response.body}");
      Logger.success("Get next payouts product URL: $fullUrl");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          Logger.success("Data fetched successfully: $data");

          // Clear and populate basic data
          _nextMonthAllPayouts.clear();
          _nextMonth = data['period'];
          _nextMonthPayout = data['totalPayable']?.toString();

          // Handle transactions
          if (data['transactions'] is List) {
            final transactions = data['transactions'] as List;

            if (transactions.isEmpty) {
              Logger.warning("No transactions found for next month");
            } else {
              Logger.info(
                  "Processing ${transactions.length} transactions for next month");

              for (var transaction in transactions) {
                try {
                  final payout = CustProductPayoutModel.fromJson(transaction);
                  _nextMonthAllPayouts.add(payout);
                } catch (e, s) {
                  Logger.error(
                      "Error parsing next month payout transaction: $e");
                  Logger.error("Transaction data: $transaction");
                  Logger.error("StackTrace: $s");
                  // Continue processing other transactions even if one fails
                }
              }
            }

            // Log final count after processing all transactions
            Logger.success(
                "Successfully processed ${_nextMonthAllPayouts.length} next month payout transactions");
          } else {
            Logger.warning(
                "Transactions field is not a list or is missing for next month");
          }
        } else {
          Logger.error(
              "API returned unsuccessful status or no data for next month");
          Logger.error("Response status: ${responseData['status']}");
          _error = "No payout data available for next month.";
        }
      } else {
        Logger.error(
            "HTTP Error for next month payouts: ${response.statusCode}");
        _error = "Server error. Please try again later.";
      }
    } catch (e, s) {
      Logger.error("Error fetching next month payouts: $e");
      Logger.error("StackTrace: $s");
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
      final fullUrl = AppUrls.getPayoutsProduct;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "action": "total",
        "userId": userId,
        "userType": "10"
      };
      final encodeBody = jsonEncode(body);
      Logger.warning("Total Payouts Request Body: $encodeBody");

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json'
          }, // Added missing headers
          body: encodeBody);

      Logger.success("Response from total payouts: ${response.body}");
      Logger.success("Get total payouts product URL: $fullUrl");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          Logger.success("Data fetched successfully for all payouts: $data");

          _totalAllPayouts.clear();
          _totalPayout = data['totalAmount']?.toString() ?? '0';

          if (data['transactions'] is List) {
            final transactions = data['transactions'] as List;

            if (transactions.isEmpty) {
              Logger.warning("No transactions found for total payouts");
            } else {
              Logger.info(
                  "Processing ${transactions.length} total payout transactions");

              for (var transaction in transactions) {
                try {
                  final payout = CustProductPayoutModel.fromJson(transaction);
                  _totalAllPayouts.add(
                      payout); // Changed from _allPayouts to _totalAllPayouts
                } catch (e, s) {
                  Logger.error("Error parsing total payout transaction: $e");
                  Logger.error("Transaction data: $transaction");
                  Logger.error("StackTrace: $s");
                  // Continue processing other transactions even if one fails
                }
              }
            }

            Logger.success(
                "Successfully processed ${_totalAllPayouts.length} total payout transactions");
          } else {
            Logger.warning(
                "Transactions field is not a list or is missing for total payouts");
          }
        } else {
          Logger.error(
              "API returned unsuccessful status or no data for total payouts");
          Logger.error("Response status: ${responseData['status']}");
          _error = "No total payout data available.";
        }
      } else {
        Logger.error("HTTP Error for total payouts: ${response.statusCode}");
        _error = "Server error. Please try again later.";
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
