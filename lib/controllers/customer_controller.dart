import 'dart:convert';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<dynamic>> apiGetCountry() async {
    try {
      final fullUrl = "https://testca.uniqbizz.com/api/country.php";

      final response = await http.get(Uri.parse(fullUrl));
      Logger.success("message");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error getting countries: $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetStates(String countryId) async {
    try {
      final fullUrl = "http://testca.uniqbizz.com/api/state_city.php";
      final requestBody = {"country_id": countryId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("State Response ${response.body}");
      Logger.success("State request body $encodeBody");
      Logger.success("State response code ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error fetching States $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetCity(String stateId) async {
    try {
      final fullUrl = "http://testca.uniqbizz.com/api/state_city.php";
      final requestBody = {"state_id": stateId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("City Response : ${response.body}");
      Logger.success("City Request Body : $encodeBody");
      Logger.success("City Full Url : $fullUrl");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error fethcing cities : $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetZone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullUrl =
          'https://testca.uniqbizz.com/api/employees/all_employees/add_employees_zone.php';
      final response = await http.get(Uri.parse(fullUrl));
      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final zonesList = jsonData['zones'];

          final zonesData = json.encode(zonesList);
          await prefs.setString('zones', zonesData);
          Logger.success("Zones data saved to SharedPreferences");

          // Return the zones list directly
          return zonesList;
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      }
      return [];
    } catch (e) {
      Logger.error("Error getting zones: $e");
      return [];
    }
  }

  Future<String> apiGetPincode(String cityId) async {
    try {
      final fullUrl = "https://testca.uniqbizz.com/api/pincode.php";
      final requestBody = {'city_id': cityId};
      final encodedBody = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodedBody,
      );

      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          return jsonData['data']['pincode'] ?? "";
        } else {
          Logger.error("API returned success code but invalid data structure");
          return "";
        }
      } else {
        Logger.error("API returned error code: ${response.statusCode}");
        return "";
      }
    } catch (e) {
      Logger.success("Error fetching Pincode: $e");
      return "";
    }
  }

  Future<List<dynamic>> apiGetBranchs(String zoneId) async {
    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/employees/all_employees/add_employees_branch.php";
      final requestBody = {'zone_id': zoneId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          // Return the branches list directly
          return jsonData['branches'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      }
      return [];
    } catch (e) {
      Logger.error("Error getting branches: $e");
      return [];
    }
  }
}
