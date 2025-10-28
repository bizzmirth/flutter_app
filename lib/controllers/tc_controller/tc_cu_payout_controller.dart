import 'dart:convert';
import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/tc_cu_all_payout_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/tc_cu_next_payout_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/tc_cu_previous_payout_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcCuPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  TcCuPreviousPayoutModel? _previousPayout;
  TcCuNextPayoutModel? _nextPayout;
  List<TcCuAllPayoutModel> _tcCuAllPayout = [];

  // ===== Commonly Used Date Info =====
  late final String prevDateMonth;
  late final String prevDateYear;
  late final String nextDateMonth;
  late final String nextDateYear;

  bool get isLoading => _isLoading;
  String? get error => _error;
  TcCuPreviousPayoutModel? get previousPayout => _previousPayout;
  TcCuNextPayoutModel? get nextPayout => _nextPayout;
  List<TcCuAllPayoutModel> get tcCuAllPayment => _tcCuAllPayout;

  TcCuPayoutController() {
    _initializeDateInfo();
    initializeTcCuPayoutData();
  }

  // --- Calculate prev/next month and year once ---
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

  Future<void> initializeTcCuPayoutData() async {
    await apiGetTcCuPreviousPayouts();
    await apiGetTcCuNextPayouts();
    await apiGetAllTcCuAllPayouts();
  }

  // ================= Previous Payout API =================
  Future<void> apiGetTcCuPreviousPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcCuPreviousPayouts;
      Logger.info('Fetching TC CU Previous Payouts from $url');
      final userId = await SharedPrefHelper().getCurrentUserCustId();

      final Map<String, dynamic> body = {
        'userId': userId,
        'prevDateMonth': '06',
        'prevDateYear': prevDateYear,
      };

      Logger.success('Request body for TC CU previous payouts: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.info('Response status: ${response.statusCode}');
      Logger.success('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        _previousPayout = TcCuPreviousPayoutModel.fromJson(jsonResponse);
        Logger.success('Successfully parsed previous payout data');
      } else {
        _error =
            'Failed to fetch previous payouts. Status: ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      Logger.error('Error fetching TC CU previous payouts: $e\n$s');
      _error = 'Error fetching previous payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= Next Payout API =================
  Future<void> apiGetTcCuNextPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcCuNextPayouts;
      Logger.info('Fetching TC CU Next Payouts from $url');

      final userId = await SharedPrefHelper().getCurrentUserCustId();

      final Map<String, dynamic> body = {
        'userId': userId,
        'nextDateMonth': nextDateMonth,
        'nextDateYear': nextDateYear,
      };

      Logger.success('Request body for TC CU next payouts: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.info('Response status: ${response.statusCode}');
      Logger.success('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        _nextPayout = TcCuNextPayoutModel.fromJson(jsonResponse);
        Logger.success('Successfully parsed next payout data');
      } else {
        _error = 'Failed to fetch next payouts. Status: ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      Logger.error('Error fetching TC CU next payouts: $e\n$s');
      _error = 'Error fetching next payouts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= ALL Payout API =================
  Future<void> apiGetAllTcCuAllPayouts() async {
    try {
      _isLoading = false;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcCuAllPayouts;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {'userId': userId};
      Logger.success('fetching tc cu all payouts from $url');
      Logger.success('response body for fetching tc cu all payouts: $body');

      final response = await http.post(Uri.parse(url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true && jsonData['payouts'] != null) {
          final List payouts = jsonData['payouts'];
          _tcCuAllPayout.addAll(payouts
              .map((item) => TcCuAllPayoutModel.fromJson(item))
              .toList());
          Logger.success(
              'successfully fetched ${_tcCuAllPayout.length} cu all payouts');
        } else {
          Logger.error('No data found. Response: ${response.body}');
        }
      } else {
        Logger.error('API responded with no data: ${response.body}');
      }
    } catch (e, s) {
      Logger.error(
          'Error fetching tc cu all payouts, Error: $e, Stacktrace: $s');
      _error = 'Error fetching tc cu all payouts, Error: $s';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
