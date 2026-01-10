import 'package:bizzmirth_app/models/franchise_models/cu_membership_payout_response.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeCuPayoutsController extends ChangeNotifier {
  final ApiService _apiService;
  FranchiseeCuPayoutsController({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ─────────────────────────────────────
  // State
  // ─────────────────────────────────────
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  CuMembershipPayoutData? _previousPayoutData;
  CuMembershipPayoutData? _nextPayoutData;

  // ─────────── SUMMARY GETTERS ───────────
  double get previousTotalPayout =>
      _previousPayoutData?.summary.totalPayout ?? 0;

  double get previousTdsAmount => _previousPayoutData?.summary.tdsAmount ?? 0;

  double get previousTotalPayable =>
      _previousPayoutData?.summary.totalPayable ?? 0;

  double get previousTdsPercentage =>
      _previousPayoutData?.summary.tdsPercentage ?? 0;

  String get previousPayoutMonth => _previousPayoutData?.summary.month ?? '';

  String get previousPayoutYear => _previousPayoutData?.summary.year ?? '';

  int get previousPayoutCount => _previousPayoutData?.count ?? 0;

  List<PayoutItem> get previousPayoutList => _previousPayoutData?.payouts ?? [];

  // ─────────── NEXT SUMMARY GETTERS ───────────
  double get nextTotalPayout => _nextPayoutData?.summary.totalPayout ?? 0;

  double get nextTdsAmount => _nextPayoutData?.summary.tdsAmount ?? 0;

  double get nextTotalPayable => _nextPayoutData?.summary.totalPayable ?? 0;

  double get nextTdsPercentage => _nextPayoutData?.summary.tdsPercentage ?? 0;

  String get nextPayoutMonth => _nextPayoutData?.summary.month ?? '';

  String get nextPayoutYear => _nextPayoutData?.summary.year ?? '';

  int get nextPayoutCount => _nextPayoutData?.count ?? 0;

  List<PayoutItem> get nextPayoutList => _nextPayoutData?.payouts ?? [];

  // ===== Commonly Used Date Info =====
  late final String prevDateMonth;
  late final String prevDateYear;
  late final String nextDateMonth;
  late final String nextDateYear;

  Future<void> initializeDateInfo() async {
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

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  // ─────────────────────────────────────
  // PREVIOUS PAYOUT
  // ─────────────────────────────────────

  Future<void> fetchPreviousPayouts() async {
    try {
      _state = ViewState.loading;
      _failure = null;
      notifyListeners();

      final userId = await _getUserId();

      final Map<String, dynamic> body = {
        'userId': 'FGA2500004',
        'year': '2025',
        'month': '09',
        'type': 'previous'
      };

      final response = await _apiService.post(
        'https://testca.uniqbizz.com/bizzmirth_apis/users/franchise/payouts/cu_membership_payouts/cu_membership_payouts.php',
        body,
      );

      Logger.info('Previous payout response → $response');

      final parsedResponse = CuMembershipPayoutResponse.fromJson(response);

      if (parsedResponse.status.toLowerCase() != 'success') {
        throw Failure(
          'Failed to fetch previous payouts',
        );
      }

      _previousPayoutData = parsedResponse.data;

      _state = ViewState.success;
      notifyListeners();
    } catch (e, stackTrace) {
      Logger.error(
        'Error fetching previous payouts $e, Stacktrace: $stackTrace',
      );

      _failure = e is Failure ? e : Failure('Something went wrong');

      _state = ViewState.error;
      notifyListeners();
    }
  }

  Future<void> fetchNextPayouts() async {
    try {
      _state = ViewState.loading;
      _failure = null;
      notifyListeners();

      final userId = await _getUserId();

      final Map<String, dynamic> body = {
        'userId': 'FGA2500004',
        'year': '2025',
        'month': '09',
        'type': 'next'
      };

      final response = await _apiService.post(
        'https://testca.uniqbizz.com/bizzmirth_apis/users/franchise/payouts/cu_membership_payouts/cu_membership_payouts.php',
        body,
      );

      Logger.info('Next payout response → $response');

      final parsedResponse = CuMembershipPayoutResponse.fromJson(response);

      if (parsedResponse.status.toLowerCase() != 'success') {
        throw Failure('Failed to fetch next payouts');
      }

      _nextPayoutData = parsedResponse.data;

      _state = ViewState.success;
      notifyListeners();
    } catch (e, stackTrace) {
      Logger.error(
        'Error fetching next payouts $e, Stacktrace: $stackTrace',
      );

      _failure = e is Failure ? e : Failure('Something went wrong');

      _state = ViewState.error;
      notifyListeners();
    }
  }
}
