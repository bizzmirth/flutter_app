import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_pending_customer_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_registered_customer_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TcCustomerController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TcPendingCustomerModel> _pendingCustomers = [];
  List<TcRegisteredCustomerModel> _registeredCustomers = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TcPendingCustomerModel> get pendingCustomers => _pendingCustomers;
  List<TcRegisteredCustomerModel> get registeredCustomers =>
      _registeredCustomers;

  TcCustomerController() {
    initialize();
  }

  Future<void> initialize() async {
    await apiGetTcPendingCustomers();
    await apiGetTcRegisteredCustomers();
  }

  Future<void> apiGetTcPendingCustomers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcPendingCustomers;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          _pendingCustomers = data
              .map((item) => TcPendingCustomerModel.fromJson(item))
              .toList();
          Logger.success(
            'Fetched ${_pendingCustomers.length} pending customers successfully.',
          );
        } else {
          _pendingCustomers = [];
          _error = 'No pending customers found.';
          Logger.warning(
              'Response did not contain valid data. ${response.body}');
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error(
            'Server error while fetching pending customers.${response.body} ${response.statusCode} ');
      }
    } catch (e, s) {
      _error = 'Error fetching pending customers: Error: $e, StackTrace: $s';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTcRegisteredCustomers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcRegisteredCustomers;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _registeredCustomers.clear();
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          _registeredCustomers = data
              .map((item) => TcRegisteredCustomerModel.fromJson(item))
              .toList();
          Logger.success(
              'Fetched total ${_registeredCustomers.length} registered customers successfully.');
        } else {
          _registeredCustomers = [];
          _error = 'No registered customers found.';
          Logger.warning(
              'Response did not contain valid data. ${response.body}');
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error(
            'Server error while fetching registered customers.${response.body} ${response.statusCode} ');
      }
    } catch (e, s) {
      _error = 'Error fetching registered customers: Error: $e';
      Logger.error(
          'Error fetching registered customers: Error: $e, StackTrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
