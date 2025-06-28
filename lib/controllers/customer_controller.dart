import 'dart:convert';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CustomerController extends ChangeNotifier {
  final String baseUrl = 'https://testca.uniqbizz.com/api/customers';

  bool _isLoading = false; // ✅ Private variable
  bool get isLoading => _isLoading; // ✅ Getter

  List<PendingCustomer> _pendingCustomer = [];
  List<PendingCustomer> get pendingCustomer => _pendingCustomer;

  List<RegisteredCustomer> _registeredCustomer = [];
  List<RegisteredCustomer> get registeredCustomer => _registeredCustomer;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<List<PendingCustomer>> apifetchPendingEmployee() async {
    List<PendingCustomer> customers = [];

    try {
      setLoading(true);

      final fullUrl = '$baseUrl/customers.php?action=pending_cust';
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );

      Logger.success("Fetched Pending customer ${response.body}");

      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        customers = (jsonData['data'] as List)
            .map((item) => PendingCustomer.fromJson(item))
            .toList();
        _pendingCustomer = customers;
        notifyListeners();
      } else {
        Logger.error("Unexpected response format or empty data.");
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching pending customer, Error: $e, Stacktrace: $s");
    } finally {
      setLoading(false);
    }

    return customers;
  }

  Future<List<RegisteredCustomer>> apiFetchRegisteredCustomer() async {
    List<RegisteredCustomer> customers = [];

    try {
      setLoading(true);

      final fullUrl = '$baseUrl/customers.php?action=registered_cust';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );
      Logger.success("Fetched Registered Customer: ${response.body}");

      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        customers = (jsonData['data'] as List)
            .map((item) => RegisteredCustomer.fromJson(item))
            .toList();
        _registeredCustomer = customers;
        notifyListeners();
      } else {
        Logger.error(
            "Unexpected response format or empty data ${response.body}");
      }
    } catch (e, s) {
      Logger.error(
          "Error fetching registered customer, Error $e, Stacktrace $s");
    } finally {
      setLoading(false);
    }

    return customers;
  }

  Future<void> refreshData() async {
    await apifetchPendingEmployee();
    await apiFetchRegisteredCustomer();
  }
}
