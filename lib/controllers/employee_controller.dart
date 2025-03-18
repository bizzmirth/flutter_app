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

  Future<List<PendingEmployeeModel>> _fetchEmployeeFromServer() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employee.php?action=pending_employees'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => _pendingEmployeeFromJson(json)).toList();
      } else {
        Logger.error('Failed to load employees: ${response.statusCode}');
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      Logger.error("Error fetching employee: $e");
      throw Exception('Error fetching employee');
    }
  }

  PendingEmployeeModel _pendingEmployeeFromJson(Map<String, dynamic> json) {
    final employee = PendingEmployeeModel()
      ..id = json['id'] ?? Isar.autoIncrement
      ..name = json['name']
      ..mobileNumber = json['mobileNumber'] ?? json['mobile_number']
      ..email = json['email']
      ..address = json['address']
      ..gender = json['gender']
      ..dateOfBirth = json['dateOfBirth'] ?? json['date_of_birth']
      ..dateOfJoining = json['dateOfJoining'] ?? json['date_of_joining']
      ..status = json['status'] ?? 1
      ..department = json['department']
      ..designation = json['designation']
      ..zone = json['zone']
      ..branch = json['branch']
      ..reportingManager = json['reportingManager'] ?? json['reporting_manager']
      ..profilePicture = json['profilePicture'] ?? json['profile_picture']
      ..idProof = json['idProof'] ?? json['id_proof']
      ..bankDetails = json['bankDetails'] ?? json['bank_details'];

    return employee;
  }
}
