import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeTcController extends ChangeNotifier {
  final ApiService _apiService;
  FranchiseeTcController({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ─────────────────────────────────────
  // State
  // ─────────────────────────────────────
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  // ─────────────────────────────────────
  // Data (Single Source of Truth)
  // ─────────────────────────────────────
  List<FranchiseePendingTc> _pendingTcs = [];
  List<FranchiseePendingTc> get pendingTcs => _pendingTcs;

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> fetchPendingTcs() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType
      };
      Logger.info(
          'fetchPendingTcs body: $body, url: ${AppUrls.getFranchiseePendingTc}');
      final response =
          await _apiService.post(AppUrls.getFranchiseePendingTc, body);
      if (response['success'] != true) {
        throw Failure(
            response['message'] ?? 'Failed to load top travel consultants');
      }
      Logger.info('Franchisee Pending TCs: $response');
      final List data = response['data'] ?? [];
      _pendingTcs =
          data.map((item) => FranchiseePendingTc.fromJson(item)).toList();
      _state = ViewState.success;
    } catch (e) {
      _failure = e is Failure ? e : Failure('Something went wrong');
      Logger.error('FranchiseeTcController.fetchPendingTcs: $e');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRegisteredTcs() async{}
}
