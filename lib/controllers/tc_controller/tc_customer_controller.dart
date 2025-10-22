import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_pending_customer_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_registered_customer_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
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

  Future<void> apiDeleteRegisteredCustomer(
    BuildContext context,
    TcRegisteredCustomerModel customer,
  ) async {
    try {
      // _isLoading = true;
      // _error = null;
      // notifyListeners();

      final url = AppUrls.deleteTcCustomer;
      final Map<String, dynamic> body = {
        'id': customer.id,
        'fid': customer.taReferenceNo,
        'refid': customer.caCustomerId,
        'action': 'registered',
      };
      final encodeBody = jsonEncode(body);
      Logger.success(
          'request body for tc delete registered customer $encodeBody');

      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success(
          'raw response for deleting registered customer ${response.body}');

      if (response.statusCode == 200) {
        final index =
            _registeredCustomers.indexWhere((c) => c.id == customer.id);

        if (index != -1) {
          _registeredCustomers[index].status = '3';
          notifyListeners();
        }
        ToastHelper.showSuccessToast(
            title: 'Customer status updated successfully!');
      } else {
        _error = 'Failed to update status';
        ToastHelper.showErrorToast(title: _error ?? 'Error updating status');
      }
    } catch (e, s) {
      _error = 'Error deleting customer. Error: $e';
      Logger.error('Error deleting customer. Stacktrace: $s');
      ToastHelper.showErrorToast(title: _error ?? 'Error updating status : $e');
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiRestoreRegisteredCustomer(
    BuildContext context,
    TcRegisteredCustomerModel customer,
  ) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.deleteTcCustomer;

      final Map<String, dynamic> body = {
        'id': customer.id,
        'fid': customer.taReferenceNo,
        'refid': customer.caCustomerId,
        'action': 'deactivate',
      };

      final encodeBody = jsonEncode(body);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: encodeBody,
      );

      if (response.statusCode == 200) {
        // final responseData = jsonDecode(response.body);

        customer.status = '1';
        Logger.info('Customer restored successfully: ${customer.id}');

        ToastHelper.showSuccessToast(title: 'Customer restored successfully!');

        notifyListeners();
      } else {
        _error = 'Server error: ${response.statusCode}';

        ToastHelper.showErrorToast(
            title: _error ?? 'Server Error: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error restoring customer: $e';
      Logger.error('$_error\nStacktrace: $s');

      ToastHelper.showErrorToast(title: _error ?? 'Error restoring customer');
    } finally {
      notifyListeners();
    }
  }
}
