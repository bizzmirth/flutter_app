import 'dart:convert';

import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

class EmployeeController extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  final String baseUrl = 'https://testca.uniqbizz.com/api/employee';

  bool isLoading = false;
  List<PendingEmployeeModel> _employees = [];

  Future<bool> _hasNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> fetchAndSavePendingEmployees() async {
    try {
      isLoading = true;
      notifyListeners();

      final hasNetwork = await _hasNetwork();
      if (!hasNetwork) {
        Logger.warning('No network connection, using local data');
        _employees = await _isarService.getAll<PendingEmployeeModel>();
        isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch from API
      final List<PendingEmployeeModel> apiEmployees =
          await _fetchPendingEmployeeFromServer();

      // Save to local DB
      for (var employee in apiEmployees) {
        await _isarService.save(employee);
      }

      // Update state
      _employees = apiEmployees;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      Logger.error("Error in fetchAndSavePendingEmployees: $e");
      throw Exception('Failed to fetch and save employees');
    }
  }

  // Getter for the employees list
  List<PendingEmployeeModel> get employees => _employees;

  Future<List<PendingEmployeeModel>> _fetchPendingEmployeeFromServer() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employee.php?action=pending_employees'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response as a Map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if the response has the expected format
        if (jsonResponse.containsKey('status') &&
            jsonResponse.containsKey('data')) {
          if (jsonResponse['status'] == 'success' &&
              jsonResponse['data'] is List) {
            // Extract the data array
            final List<dynamic> dataList = jsonResponse['data'];
            return dataList
                .map((json) => _pendingEmployeeFromJson(json))
                .toList();
          }
        }

        Logger.error('Unexpected API response format');
        return [];
      } else {
        Logger.error('Failed to load employees: ${response.statusCode}');
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error("Error fetching employee: $e");
      throw Exception('Error fetching employee: $e');
    }
  }

  PendingEmployeeModel _pendingEmployeeFromJson(Map<String, dynamic> json) {
    try {
      final employee = PendingEmployeeModel()
        ..id = _parseIntSafely(json['id']) // Use auto-increment for local ID
        ..name = json['name'] ?? ''
        ..mobileNumber = json['contact'] ?? ''
        ..email = json['email'] ?? ''
        ..address = json['address'] ?? ''
        ..gender = json['gender'] ?? ''
        ..dateOfBirth = json['date_of_birth'] ?? ''
        ..dateOfJoining = json['date_of_joining'] ?? ''
        ..status = _parseIntSafely(json['status']) ?? 1
        ..department = _parseIntSafely(json['department']).toString()
        ..designation = _parseIntSafely(json['designation']).toString()
        ..zone = _parseIntSafely(json['zone']).toString()
        ..branch = _parseIntSafely(json['branch']).toString()
        ..reportingManager = json['reporting_manager'] ?? ''
        ..profilePicture = json['profile_pic'] ?? ''
        ..idProof = json['id_proof'] ?? ''
        ..bankDetails = json['bank_details'] ?? '';

      return employee;
    } catch (e) {
      Logger.error("Error parsing employee: $e for data: $json");
      throw Exception("Error parsing employee: $e");
    }
  }

// Helper method to safely parse integers
  int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
