import 'package:bizzmirth_app/models/franchise_models/franchisee_all_tc_recruitment_model.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payout.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payout_response.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_payouts.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_tc_recruitment_total_payout.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/month_year_helper.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeTcRecruitmentController extends ChangeNotifier {
  final ApiService _apiService;
  FranchiseeTcRecruitmentController({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ─────────────────────────────────────
  // State
  // ─────────────────────────────────────
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  // ─────────────────────────────────────
  // ALL PAYOUTS (TABLE)
  // ─────────────────────────────────────
  List<FranchiseeAllTcRecruitmentModel> _allTcRecruitmentPayouts = [];
  List<FranchiseeAllTcRecruitmentModel> get allTcRecruitmentPayouts =>
      _allTcRecruitmentPayouts;

  // ─────────────────────────────────────
  // PREVIOUS PAYOUT
  // ─────────────────────────────────────
  TcRecruitmentData? _previousTcRecruitmentData;
  TcRecruitmentData? get previousTcRecruitmentData =>
      _previousTcRecruitmentData;

  List<CuPayoutItem> get previousPayouts =>
      _previousTcRecruitmentData?.payouts ?? [];

  TcRecruitmentSummary? get previousSummary =>
      _previousTcRecruitmentData?.summary;

  // ─────────────────────────────────────
  // NEXT PAYOUT
  // ─────────────────────────────────────
  TcRecruitmentData? _nextTcRecruitmentData;
  TcRecruitmentData? get nextTcRecruitmentData => _nextTcRecruitmentData;

  List<CuPayoutItem> get nextPayouts => _nextTcRecruitmentData?.payouts ?? [];

  TcRecruitmentSummary? get nextSummary => _nextTcRecruitmentData?.summary;

// ─────────────────────────────────────
// TOTAL TC RECRUITMENT PAYOUT
// ─────────────────────────────────────
  TcRecruitmentTotalResponse? _totalTcRecruitmentResponse;

  TcRecruitmentTotalResponse? get totalTcRecruitmentResponse =>
      _totalTcRecruitmentResponse;

  String get totalTcRecruitmentAmount =>
      _totalTcRecruitmentResponse?.amount ?? '';

  List<CuPayoutItem> get totalTcRecruitmentPayouts =>
      _totalTcRecruitmentResponse?.payoutRecords ?? [];

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  // ─────────────────────────────────────
  // PREVIOUS TC RECRUITMENT PAYOUT
  // ─────────────────────────────────────
  Future<void> fetchPreviousTcRecruitmentPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final dateInfo = resolveMonthYear(type: 'previous');
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'type': 'previous',
        'year': dateInfo['year'],
        'month': dateInfo['month'],
      };

      final response = await _apiService.post(
        AppUrls.getFranchiseeTcRecruitmentPayouts,
        body,
      );

      Logger.info('Previous TC recruitment payout body: $body');
      Logger.info('Previous TC recruitment payout response: $response');

      final parsedResponse = TcRecruitmentResponse.fromJson(response);

      if (parsedResponse.status.toLowerCase() != 'success') {
        throw Failure('Failed to fetch previous TC recruitment payouts');
      }

      _previousTcRecruitmentData = parsedResponse.data;
      _state = ViewState.success;
    } catch (e, s) {
      Logger.error('Previous TC recruitment payout error: $e\n$s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ─────────────────────────────────────
  // NEXT TC RECRUITMENT PAYOUT
  // ─────────────────────────────────────
  Future<void> fetchNextTcRecruitmentPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final dateInfo = resolveMonthYear(type: 'next');
      final Map<String, dynamic> body = {
        'userId': _getUserId(),
        'type': 'next',
        'year': dateInfo['year'],
        'month': dateInfo['month'],
      };

      final response = await _apiService.post(
        AppUrls.getFranchiseeTcRecruitmentPayouts,
        body,
      );

      Logger.info('Next TC recruitment payout body: $body');
      Logger.info('Next TC recruitment payout response: $response');

      final parsedResponse = TcRecruitmentResponse.fromJson(response);

      if (parsedResponse.status.toLowerCase() != 'success') {
        throw Failure('Failed to fetch next TC recruitment payouts');
      }

      _nextTcRecruitmentData = parsedResponse.data;
      _state = ViewState.success;
    } catch (e, s) {
      Logger.error('Next TC recruitment payout error: $e\n$s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ─────────────────────────────────────
  // TOTAL TC RECRUITMENT PAYOUTS (LIST)
  // ─────────────────────────────────────
  Future<void> fetchTotalRecruitmentPayouts(
      String? selectedMonth, String? selectedYear) async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final month = selectedMonth ?? now.month.toString().padLeft(2, '0');
      final year = selectedYear ?? now.year.toString();
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'year': year,
        'month': month
      };

      final response = await _apiService.post(
        AppUrls.getFranchiseeTotalTCRecruitmentPayouts,
        body,
      );

      Logger.info('Total tc recruitment payout body: $body');
      Logger.info('total tc recruitment payout response: $response');

      if (response['success'] == true) {
        _failure = null;

        _totalTcRecruitmentResponse =
            TcRecruitmentTotalResponse.fromJson(response);

        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message']?.toString() ??
              'Failed to fetch total payout data',
        );
        _state = ViewState.error;
      }
    } catch (e, s) {
      Logger.error('Total TC recruitment payout error: $e\n$s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ─────────────────────────────────────
  // ALL TC RECRUITMENT PAYOUTS (LIST)
  // ─────────────────────────────────────
  Future<void> fetchAllTCRecruitmentPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
      };

      final response = await _apiService.post(
        AppUrls.getFranchiseeAllTCRecruitmentPayouts,
        body,
      );

      Logger.info('All TC recruitment payout body: $body');
      Logger.info('All TC recruitment payout response: $response');

      if (response['status'] == 'success') {
        final List payouts = response['payouts'] ?? [];

        _allTcRecruitmentPayouts = payouts
            .map((e) => FranchiseeAllTcRecruitmentModel.fromJson(e))
            .toList();

        _state = ViewState.success;
      } else {
        throw Failure(
          response['message'] ?? 'Failed to fetch all TC recruitment payouts',
        );
      }
    } catch (e, s) {
      Logger.error('All TC recruitment payout error: $e\n$s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
