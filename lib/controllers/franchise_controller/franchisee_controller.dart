import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/models/franchise_models/franchise_dashboard_count.dart';
import 'package:bizzmirth_app/models/franchise_models/data.dart';

class FranchiseeController extends ChangeNotifier {
  final ApiService _apiService;

  FranchiseeController({ApiService? apiService})
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
  FranchiseDashboardCount? _dashboardCount;

  FranchiseDashboardCount? get dashboardCount => _dashboardCount;

  // ─────────────────────────────────────
  // Clean UI Getters (VERY IMPORTANT)
  // ─────────────────────────────────────

  TravelConsultants? get travelConsultants =>
      _dashboardCount?.data?.travelConsultants;

  Customers? get customers => _dashboardCount?.data?.customers;

  Commission? get commission => _dashboardCount?.data?.commission;

  // Optional convenience getters (UI loves this)
  int get totalTravelConsultants => travelConsultants?.total ?? 0;

  int get newTravelConsultantsThisMonth => travelConsultants?.thisMonth ?? 0;

  int get totalCustomers => customers?.total ?? 0;

  int get newCustomersThisMonth => customers?.thisMonth ?? 0;

  String get confirmedCommission => commission?.confirmed ?? '0';

  String get pendingCommission => commission?.pending ?? '0';

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> fetchDashboardCounts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        AppUrls.getFranchiseeDashboardCounts,
        {'userId': await _getUserId()},
      );

      // API-level validation
      if (response['status'] != true) {
        throw Failure(response['message'] ?? 'Failed to load dashboard data');
      }
      Logger.info('Franchisee Dashboard counts: $response');

      // Model parsing (since no repository)
      _dashboardCount = FranchiseDashboardCount.fromJson(response);

      _state = ViewState.success;
    } catch (e) {
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ─────────────────────────────────────
  // Optional reset (screen dispose / logout)
  // ─────────────────────────────────────
  void reset() {
    _state = ViewState.idle;
    _failure = null;
    _dashboardCount = null;
    notifyListeners();
  }
}
