import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_customer.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_customer.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeCustomerController extends ChangeNotifier {
  final ApiService _apiService;
  FranchiseeCustomerController({ApiService? apiService})
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
  List<FranchiseePendingCustomer> _pendingCustomers = [];
  List<FranchiseeRegisteredCustomer> _registeredCustomers = [];
  List<FranchiseePendingCustomer> get pendingCustomers => _pendingCustomers;
  List<FranchiseeRegisteredCustomer> get registeredCustomers =>
      _registeredCustomers;

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> fetchFranchiseePendingCustomers() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType
      };
      Logger.info('Franchisee Pending Customers Request Body: $body');
      final response =
          await _apiService.post(AppUrls.getFranchiseePendingCustomers, body);
      Logger.info('Franchisee Pending Customers Response: $response');
      if (response['success'] != true) {
        _failure = Failure(response['message'] ?? 'Something went wrong');
        _state = ViewState.error;
      }
      final List<dynamic> data = response['data'] ?? [];
      _pendingCustomers =
          data.map((e) => FranchiseePendingCustomer.fromJson(e)).toList();
      Logger.success('Fetched ${_pendingCustomers.length} pending customers');
      _state = ViewState.success;
    } catch (e) {
      Logger.error('Error fetching franchisee pending customers: $e');
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchFranchiseeRegisteredCustomers() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType
      };
      Logger.info('Franchisee Registered Customers Request Body: $body');
      final response = await _apiService.post(
          AppUrls.getFranchiseeRegisteredCustomers, body);
      Logger.info('Franchisee Registered Customers Response: $response');
      if (response['success'] != true) {
        _failure = Failure(response['message'] ?? 'Something went wrong');
        _state = ViewState.error;
      } else {
        final List<dynamic> data = response['data'] ?? [];
        _registeredCustomers =
            data.map((e) => FranchiseeRegisteredCustomer.fromJson(e)).toList();
        Logger.success(
            'Fetched ${_registeredCustomers.length} registered customers');
        _state = ViewState.success;
      }
    } catch (e) {
      Logger.error('Error fetching franchisee registered customers: $e');
      _failure = Failure(e.toString());
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
