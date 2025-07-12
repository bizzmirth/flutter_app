// customer_controller.dart
import 'package:bizzmirth_app/entities/top_customer_refereral/top_customer_refereral_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerController extends ChangeNotifier {
  int _regCustomerCount = 0;
  bool _isLoading = false;
  String? _error;
  String? _userCustomerId;
  String? _userTaReferenceNo;
  final List<TopCustomerRefereralModel> _topCustomerRefererals = [];

  List<TopCustomerRefereralModel> get topCustomerRefererals =>
      _topCustomerRefererals;
  int get regCustomerCount => _regCustomerCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userCustomerId => _userCustomerId;
  String? get userTaReferenceNo => _userTaReferenceNo;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> getRegCustomerCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String email = await SharedPrefHelper().getUserEmail() ?? "";
      Logger.success("the stored email is $email");

      final response = await http.get(
        Uri.parse(
            'https://testca.uniqbizz.com/api/customers/customers.php?action=registered_cust'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          List<dynamic> customers = jsonData['data'];

          for (var customer in customers) {
            if (customer['email'] == email) {
              _userTaReferenceNo = customer['ta_reference_no'];
              _userCustomerId = customer['ca_customer_id'];
              await SharedPrefHelper().saveCurrentUserCustId(_userCustomerId!);
              Logger.success(
                  "Found user with ca_customer_id: $_userCustomerId");
              Logger.success("User's ta_reference_no: $_userTaReferenceNo");
              break;
            }
          }

          if (_userCustomerId != null) {
            int count = 0;
            for (var customer in customers) {
              if (customer['reference_no'] == _userCustomerId) {
                count++;
              }
            }

            _regCustomerCount = count;

            Logger.success(
                "Total customers with ta_reference_no '$_userTaReferenceNo': $_regCustomerCount");
          } else {
            Logger.error("No customer found with email: $email");
            _regCustomerCount = 0;
            _error = "No customer found with email: $email";
          }
        } else {
          Logger.error("API returned error status: ${jsonData['status']}");
          _error = "API returned error status: ${jsonData['status']}";
        }
      } else {
        Logger.error("HTTP Error: ${response.statusCode}");
        _error = "HTTP Error: ${response.statusCode}";
      }
    } catch (e) {
      Logger.error("Error in getRegCustomerCount: $e");
      _regCustomerCount = 0;
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTopCustomerRefererals() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = await SharedPrefHelper().getCurrentUserCustId();

      final String url =
          'https://testca.uniqbizz.com/api/top_customer_refereral.php';

      final Map<String, dynamic> body = {"userId": userId};
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          _topCustomerRefererals.clear();

          List<dynamic> dataList = jsonData['data'];
          _topCustomerRefererals.addAll(
            dataList.map((e) => TopCustomerRefereralModel.fromJson(e)).toList(),
          );

          Logger.success("Top referral list updated: $_topCustomerRefererals");
        } else {
          _error = "No data found";
          Logger.error("API responded with no data");
        }
      } else {
        _error = "HTTP error: ${response.statusCode}";
        Logger.error("HTTP error: ${response.statusCode}");
      }
    } catch (e, s) {
      Logger.error("Error in apiGetTopCustomerRefererals: $e\n$s");
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCustomerData() async {
    await getRegCustomerCount();
  }

  // Reset controller state
  void reset() {
    _regCustomerCount = 0;
    _isLoading = false;
    _error = null;
    _userCustomerId = null;
    _userTaReferenceNo = null;
    notifyListeners();
  }
}
