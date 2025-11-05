import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_all_product_payout_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_product_payout_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcProductPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TcAllProductPayoutModel> _allProductPayouts = [];
  double _totalPreviousAmount = 0.0;
  double _totalPreviousTDS = 0.0;
  double _totalPreviousPayable = 0.0;
  double _totalNextAmount = 0.0;
  double _totalNextTDS = 0.0;
  double _totalNextPayable = 0.0;
  double _totalPayoutAmount = 0.0;
  double _totalPayoutTDS = 0.0;
  double _totalPayoutPayable = 0.0;
  List<TcProductPayoutModel> _previousProductPayouts = [];
  List<TcProductPayoutModel> _nextProductPayouts = [];
  List<TcProductPayoutModel> _totalProductPayouts = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TcAllProductPayoutModel> get allProductPayouts => _allProductPayouts;
  List<TcProductPayoutModel> get previousProductPayouts =>
      _previousProductPayouts;
  List<TcProductPayoutModel> get nextProductPayouts => _nextProductPayouts;
  List<TcProductPayoutModel> get totalProductPayouts => _totalProductPayouts;
  double get totalPreviousAmount => _totalPreviousAmount;
  double get totalPreviousTDS => _totalPreviousTDS;
  double get totalPreviousPayable => _totalPreviousPayable;
  double get totalNextAmount => _totalNextAmount;
  double get totalNextTDS => _totalNextTDS;
  double get totalNextPayable => _totalNextPayable;
  double get totalPayoutAmount => _totalPayoutAmount;
  double get totalPayoutTDS => _totalPayoutTDS;
  double get totalPayoutPayable => _totalPayoutPayable;

  // ===== Commonly Used Date Info =====
  late final String prevDateMonth;
  late final String prevDateYear;
  late final String nextDateMonth;
  late final String nextDateYear;

  TcProductPayoutController() {
    initialize();
    _initializeDateInfo();
  }

  Future<void> initialize() async {
    await apiGetTcAllProductPayouts();
    await apiGetPreviousProductPayouts();
    await apiGetNextProductPayouts();
    await apiGetTotalProductPayouts(null, null);
  }

  void _initializeDateInfo() {
    final now = DateTime.now();

    // --- Previous month logic ---
    int prevMonth = now.month - 1;
    int prevYear = now.year;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear = now.year - 1;
    }

    // --- Next month logic ---
    int nextMonth = now.month + 1;
    int nextYear = now.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear = now.year + 1;
    }

    prevDateMonth = prevMonth.toString().padLeft(2, '0');
    prevDateYear = prevYear.toString();
    nextDateMonth = nextMonth.toString().padLeft(2, '0');
    nextDateYear = nextYear.toString();

    Logger.success(
        'Initialized payout date info → prev: $prevDateMonth/$prevDateYear | next: $nextDateMonth/$nextDateYear');
  }

  Future<void> apiGetPreviousProductPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcProductPayouts;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final userType = AppData.tcUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'month': prevDateMonth,
        'year': prevDateYear,
        'action': 'previous',
      };

      Logger.info(
          'Fetching TC previous product payouts with body: $body from the URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.info(
          'Received response with status code: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          // Populate totals
          _totalPreviousAmount = (data['totalAmount'] ?? 0).toDouble();
          _totalPreviousTDS = (data['totalTDS'] ?? 0).toDouble();
          _totalPreviousPayable = (data['totalPayable'] ?? 0).toDouble();

          // Populate transactions
          if (data['transactions'] != null) {
            final List<dynamic> transactions = data['transactions'];

            _previousProductPayouts = transactions
                .map((t) => TcProductPayoutModel.fromJson(t))
                .toList();
          } else {
            _previousProductPayouts = [];
          }

          Logger.success(
              'Fetched ${_previousProductPayouts.length} previous payouts successfully.');
        } else {
          _error =
              jsonResponse['message'] ?? 'Failed to fetch previous payouts.';
          Logger.warning('API returned error: $_error');
        }
      } else {
        _error = 'Server returned status code ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      Logger.error('Error fetching previous product payouts. Error: $e\n$s');
      _error = 'Error fetching previous product payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetNextProductPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcProductPayouts;
      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final userType = AppData.tcUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'month': nextDateMonth,
        'year': nextDateYear,
        'action': 'next',
      };

      Logger.info(
          'Fetching TC next product payouts with body: $body from the URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.info(
          'Received response with status code: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          // Log totals before parsing to inspect what comes from backend
          Logger.info(
              'NEXT API totals raw → Amount: ${data['totalAmount']} | TDS: ${data['totalTDS']} | Payable: ${data['totalPayable']}');

          // ===== Safely parse totals (handles string/int/double/null) =====
          _totalNextAmount =
              double.tryParse(data['totalAmount']?.toString() ?? '') ?? 0.0;
          _totalNextTDS =
              double.tryParse(data['totalTDS']?.toString() ?? '') ?? 0.0;
          _totalNextPayable =
              double.tryParse(data['totalPayable']?.toString() ?? '') ?? 0.0;

          // ===== Parse transactions =====
          if (data['transactions'] != null && data['transactions'] is List) {
            final List<dynamic> transactions = data['transactions'];
            _nextProductPayouts = transactions
                .map((item) => TcProductPayoutModel.fromJson(item))
                .toList();
          } else {
            _nextProductPayouts = [];
          }

          Logger.success(
              'Fetched ${_nextProductPayouts.length} next payouts successfully. Totals → Amount: $_totalNextAmount | TDS: $_totalNextTDS | Payable: $_totalNextPayable');
        } else {
          _error = jsonResponse['message'] ?? 'Failed to fetch next payouts.';
          Logger.warning('API returned error: $_error');
        }
      } else {
        _error = 'Server returned status code ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      Logger.error('Error fetching next product payouts. Error: $e\n$s');
      _error = 'Error fetching next product payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTotalProductPayouts(
      String? selectedMonth, String? selectedYeara) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcTotalProductPayouts;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final userType = AppData.tcUserType;

      final now = DateTime.now();
      final month = selectedMonth ?? now.month.toString().padLeft(2, '0');
      final year = selectedYeara ?? now.year.toString();

      // ✅ Prepare body
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'month': month,
        'year': year,
      };

      final encodeBody = jsonEncode(body);
      Logger.success('Request body for TC total payouts: $encodeBody');
      Logger.info('requesttttt: $url, body: $encodeBody');
      // ✅ Send request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: encodeBody,
      );
      Logger.success(
          'Response status for tc total payouts: ${response.statusCode}');
      Logger.success('Response body for tc total payouts: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          // Populate totals
          _totalPayoutAmount = (data['totalAmount'] ?? 0).toDouble();
          _totalPayoutTDS = (data['totalTDS'] ?? 0).toDouble();
          _totalPayoutPayable = (data['totalPayable'] ?? 0).toDouble();

          // populate transactions
          if (data['transactions'] != null) {
            final List<dynamic> transactions = data['transactions'];
            _totalProductPayouts = transactions
                .map((t) => TcProductPayoutModel.fromJson(t))
                .toList();
          } else {
            _totalProductPayouts = [];
          }
          Logger.success(
              'Fetched ${_totalProductPayouts.length} total payouts successfully.');
        } else {
          _error = jsonResponse['message'] ?? 'Failed to fetch total payouts.';
          Logger.warning('API returned error: $_error');
        }
      } else {
        _error = 'Server returned status code ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      Logger.error('Error fetching TC total payouts: Error $e, Stacktrace: $s');
      _error = 'Error fetching total payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTcAllProductPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcProductAllPayouts;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType
      };
      Logger.info(
          'Fetching TC all product payouts with body: $body from the URL: $url');
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      Logger.info(
          'Received response with status code: ${response.statusCode} and body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['payouts'] != null) {
          final List payouts = jsonResponse['payouts'];
          _allProductPayouts = payouts
              .map((payoutJson) => TcAllProductPayoutModel.fromJson(payoutJson))
              .toList();
          Logger.info(
              'Fetched ${_allProductPayouts.length} product payouts successfully.');
        }
      }
    } catch (e, s) {
      _error = 'Error fetching tc all product payouts: $e';
      Logger.error('Error fetching tc all payouts. Error: $e, Stacktrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
