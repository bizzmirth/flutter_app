import 'package:bizzmirth_app/models/franchise_models/product_all_payout_model.dart';
import 'package:bizzmirth_app/models/franchise_models/product_payout_model.dart';
import 'package:bizzmirth_app/models/franchise_models/product_total_payout_model.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeProductPayoutsController extends ChangeNotifier {
  final ApiService _apiService;

  FranchiseeProductPayoutsController({ApiService? apiService})
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
  double _totalPayoutAmount = 0.0;
  ProductPayoutModel? _previousProductPayout;
  ProductPayoutModel? _nextProductPayout;

  ProductTotalPayoutModel? _totalProductPayout;
  List<ProductAllPayoutModel> _allProductPayouts = [];
double get totalPayoutAmount => _totalPayoutAmount;
  ProductPayoutModel? get previousProductPayout => _previousProductPayout;

  ProductPayoutModel? get nextProductPayout => _nextProductPayout;
  ProductTotalPayoutModel? get totalProductPayout => _totalProductPayout;
  List<ProductAllPayoutModel> get allProductPayouts => _allProductPayouts;

  static const String _url =
      'https://testca.uniqbizz.com/bizzmirth_apis/users/franchise/payouts/product_payouts/product_payouts.php';

  // ─────────────────────────────────────
  // PREVIOUS PAYOUT
  // ─────────────────────────────────────
  Future<void> fetchPreviousProductPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        _url,
        {
          'userId': 'FGA2500004',
          'userType': '29',
          'month': '01',
          'year': '2026',
          'action': 'previous',
        },
      );
      Logger.info('Previous Payout Response: $response');

      if (response['status'] == 'success') {
        _previousProductPayout = ProductPayoutModel.fromJson(response['data']);
        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message'] ?? 'Failed to fetch previous payouts',
        );
        _state = ViewState.error;
      }
    } catch (e) {
      Logger.error('Error fetching previous payouts: $e');
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ─────────────────────────────────────
  // NEXT PAYOUT
  // ─────────────────────────────────────
  Future<void> fetchNextProductPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        _url,
        {
          'userId': 'FGA2500004',
          'userType': '29',
          'month': '12',
          'year': '2025',
          'action': 'next',
        },
      );
      Logger.info('Next Payout Response: $response');

      if (response['status'] == 'success') {
        _nextProductPayout = ProductPayoutModel.fromJson(response['data']);
        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message'] ?? 'Failed to fetch next payouts',
        );
        _state = ViewState.error;
      }
    } catch (e) {
      Logger.error('Error fetching next payouts: $e');
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTotalProductPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        'https://testca.uniqbizz.com/bizzmirth_apis/users/franchise/payouts/product_payouts/product_total_payouts.php',
        {
          'userId': 'FGA2500004',
          'userType': '29',
          'month': '12',
          'year': '2025',
        },
      );
      Logger.info('Total Payout Response: $response');

      if (response['status'] == 'success') {
        _totalProductPayout =
            ProductTotalPayoutModel.fromJson(response['data']);
        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message'] ?? 'Failed to fetch total payouts',
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

  Future<void> fetchAllProductPayouts() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        'https://testca.uniqbizz.com/bizzmirth_apis/users/franchise/payouts/product_payouts/product_all_payouts.php',
        {
          'userId': 'FGA2500004',
          'userType': '29',
        },
      );
      Logger.info('All Payouts Response: $response');

      if (response['status'] == 'success') {
        final List<dynamic> payoutsJson = response['payouts'] ?? [];

        _allProductPayouts =
            payoutsJson.map((e) => ProductAllPayoutModel.fromJson(e)).toList();

        _state = ViewState.success;
      } else {
        _failure = Failure(
          response['message'] ?? 'Failed to fetch all payouts',
        );
        _state = ViewState.error;
      }
    } catch (e) {
      Logger.error('Error fetching all payouts: $e');
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
