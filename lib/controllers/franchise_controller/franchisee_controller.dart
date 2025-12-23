import 'package:bizzmirth_app/models/franchise_models/franchisee_candidate_count.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_top_tc.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<double> _chartData = [];
  String? _selectedYear;

  FranchiseDashboardCount? get dashboardCount => _dashboardCount;
  List<double> get chartData => _chartData;

  String? get selectedYear => _selectedYear;

  List<FranchiseeCandidateCount> _candidateCount = [];
  List<FranchiseeTopTc> _topTcs = [];

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

  List<FranchiseeCandidateCount> get candidateCount => _candidateCount;
  List<FranchiseeTopTc> get topTcs => _topTcs;

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

  Future<void> apiGetChartData(String selectedYear) async {
    try {
      _state = ViewState.loading;
      _failure = null;
      notifyListeners();

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';

      final response = await _apiService.postRaw(
        AppUrls.getFranchiseLineChartData,
        {
          'year': selectedYear,
          'current_year': 2025,
          'user_id': userId,
          'user_type': AppData.franchiseeUserType,
        },
      );

      Logger.info('Chart response: $response');

      List<num> rawValues = [];

      // ✅ Robust validation + fallback
      if (response is List && response.isNotEmpty && response.first is List) {
        rawValues = List<num>.from(response.first);
      }

      // 🔁 Fallback when empty or invalid
      if (rawValues.isEmpty) {
        Logger.warning('Chart data empty, using fallback baseline');
        rawValues = List<num>.filled(12, 0);
      }

      // Normalize → List<double>
      _chartData = rawValues.map((e) => e.toDouble()).toList();
      _selectedYear = selectedYear;

      Logger.info('Final chart data: $_chartData');

      _state = ViewState.success;
    } catch (e) {
      _failure = e is Failure ? e : Failure('Chart load failed');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  List<FlSpot> getChartSpots() {
    final int currentYear = DateTime.now().year;
    final int currentMonth = DateTime.now().month;
    final int limit = selectedYear == currentYear.toString()
        ? currentMonth
        : _chartData.length;

    final List<FlSpot> spots = [];

    for (int i = 0; i < limit && i < _chartData.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), _chartData[i]));
    }

    return spots;
  }

  Future<void> fetchCandidateCounts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType,
      };

      final response =
          await _apiService.post(AppUrls.getFranchiseeCandidates, body);

      if (response['success'] != true) {
        throw Failure(response['message'] ?? 'Failed to load candidate counts');
      }
      Logger.info('Franchisee Candidate counts: $response');

      final List data = response['data'] ?? [];

      _candidateCount =
          data.map((item) => FranchiseeCandidateCount.fromJson(item)).toList();

      _state = ViewState.success;
    } catch (e) {
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTopTcs() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType,
      };
      final response = await _apiService.post(
          AppUrls.getFranchiseeTopTravelConsultants, body);

      if (response['success'] != true) {
        throw Failure(
            response['message'] ?? 'Failed to load top travel consultants');
      }
      Logger.info('Franchisee Top TCs: $response');
      final List data = response['data'] ?? [];
      _topTcs = data.map((item) => FranchiseeTopTc.fromJson(item)).toList();
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
