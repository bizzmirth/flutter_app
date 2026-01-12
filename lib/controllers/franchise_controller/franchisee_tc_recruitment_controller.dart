import 'package:bizzmirth_app/models/franchise_models/franchisee_all_tc_recruitment_model.dart';
import 'package:bizzmirth_app/services/api_service.dart';
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
  // Data (Separate Sources of Truth)
  // ─────────────────────────────────────
  List<FranchiseeAllTcRecruitmentModel> _allTcRecruitmentPayouts = [];

  List<FranchiseeAllTcRecruitmentModel> get allTcRecruitmentPayouts =>
      _allTcRecruitmentPayouts;

  Future<void> fetchAllTCRecruitmentPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {'userId': 'FGA2500004'};

      final response = await _apiService.post(
        AppUrls.getFranchiseeAllTCRecruitmentPayouts,
        body,
      );
      Logger.info('tc recruitment payouts call made with: $body');
      Logger.info('all tc payout recruitment response: $response');

      if (response['status'] == 'success') {
        final List payouts = response['payouts'];
        _allTcRecruitmentPayouts = payouts
            .map((item) => FranchiseeAllTcRecruitmentModel.fromJson(item))
            .toList();

        Logger.warning(
            'total payout fetched ${_allTcRecruitmentPayouts.length}');
        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message'] ?? 'Failed to fetch all tc recruitment payouts',
        );
        _state = ViewState.error;
      }
    } catch (e) {
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
