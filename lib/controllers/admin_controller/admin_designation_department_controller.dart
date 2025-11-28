import 'dart:convert';

import 'package:bizzmirth_app/models/department_model.dart';
import 'package:bizzmirth_app/models/designation_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminDesignationDepartmentController extends ChangeNotifier {
  List<Department> _departments = [];
  List<Designation> _designation = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Department> get departments => _departments;
  List<Designation> get designation => _designation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String baseUrl = 'https://testca.uniqbizz.com/api/employees/dept_design';

  Future<void> fetchDepartments() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse('$baseUrl/department/department.php'),
      );
      Logger.success('Department API response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Clear existing departments
          _departments.clear();

          _departments = (responseData['data'] as List)
              .map((departmentJson) => Department.fromJson(departmentJson))
              .toList();

          // Save departments to SharedPreferences
          final departmentsJson =
              _departments.map((dept) => dept.toJson()).toList();
          final isSaved = await prefs.setString(
              'departmentData', json.encode(departmentsJson));
          Logger.success('Departments saved in SharedPreferences $isSaved');
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDesignations() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final response =
          await http.get(Uri.parse('$baseUrl/designation/designation.php'));
      Logger.success('Designation API response: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          _designation = (responseData['data'] as List)
              .map((designationJson) => Designation.fromJson(designationJson))
              .toList();

          final designationJson =
              _designation.map((desg) => desg.toJson()).toList();
          final isSaved = await prefs.setString(
              'designationData', json.encode(designationJson));
          Logger.success('Designations saved in SharedPreferences $isSaved');
        } else {
          _errorMessage = 'Failed to load departments';
        }
      } else {
        _errorMessage = 'Failed to fetch departments';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiEditDepartment(
      String? id, String departmentName, String? status) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fullUrl = '$baseUrl/department/edit_department_data.php';
      final Map<String, dynamic> data = {
        'id': id,
        'name': departmentName,
        'status': status,
        'message': 'edit'
      };
      final encodeBody = json.encode(data);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('request body $encodeBody');
      Logger.success('API response: ${response.body}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Update Successfull');
        await fetchDepartments();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
      Logger.error('API Error: $e');
    }
  }

  Future<void> apiAddDepartment(String name) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullurl = '$baseUrl/department/add_department_data.php';
      final Map<String, dynamic> data = {'name': name};
      final encodeBody = json.encode(data);
      final response = await http.post(
        Uri.parse(fullurl),
        body: encodeBody,
      );

      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code ${response.statusCode}');
      Logger.success(fullurl);
      if (response.statusCode == 200) {
        Logger.success('Department added successfully');
        notifyListeners();
      } else {
        _errorMessage = 'Failed to add department';
        Logger.error('Error adding department: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
      Logger.error('API Error: $e');
    }
  }

  Future<void> apiEditDesignation(
      String? id, String name, String? deptID, String? status) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fullUrl = '$baseUrl/designation/edit_designation_data.php';
      final Map<String, dynamic> data = {
        'id': id,
        'name': name,
        'dept_id': deptID,
        'message': 'edit',
        'status': status
      };
      final encodeBody = json.encode(data);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('request body $encodeBody');
      Logger.success('API response: ${response.body}');
      Logger.success('API status code : ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Update Successfull');
        await fetchDesignations();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to update designation';
        Logger.error('Error updating designation: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
      Logger.error('API Error: $e');
    }
  }

  Future<void> apiAddDesignation(String desgname, String? id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullUrl = '$baseUrl/designation/add_designation_data.php';
      final Map<String, dynamic> data = {'desig_name': desgname, 'dept_id': id};
      final response =
          await http.post(Uri.parse(fullUrl), body: json.encode(data));
      Logger.success('Add designation Request body: $data');
      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Designation added successfully');
        await fetchDesignations();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to add designation';
        Logger.error('Error adding designation: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      Logger.error('Error uploading designation : $e');
    }
  }

  Future<void> apiDeleteDepartment(Department department) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullUrl = '$baseUrl/department/delete_department_data.php';
      final Map<String, dynamic> data = {
        'id': department.id,
        'message': 'edit',
        'name': department.deptName,
        'status': 2
      };
      final encodeBody = json.encode(data);
      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodeBody,
      );
      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Department deleted successfully');
        await fetchDepartments();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to delete department';
        Logger.error('Error deleting department: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      Logger.error('API Error: $e');
    }
  }

  Future<void> apiRestoreDepartment(Department department) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullUrl = '$baseUrl/department/delete_department_data.php';
      final Map<String, dynamic> data = {
        'id': department.id,
        'message': 'edit',
        'name': department.deptName,
        'status': 1
      };
      final encodeBody = json.encode(data);
      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodeBody,
      );
      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Department restored successfully');
        await fetchDepartments();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to restore department';
        Logger.error('Error restoring department: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      Logger.error('Error restoring department: $e');
    }
  }

  Future<void> apiDeleteDesignation(Designation designation) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullUrl = '$baseUrl/designation/delete_designation_data.php';
      final data = {
        'id': designation.id,
        'message': 'edit',
        'name': designation.desgName,
        'status': 2
      };
      final encodeBody = json.encode(data);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code: ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Designation deleted ');
        await fetchDesignations();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to delete department';
        Logger.error('Error deleting designation: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      Logger.error('API Error : $e');
    }
  }

  Future<void> apiRestoreDesignation(Designation designation) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final fullUrl = '$baseUrl/designation/delete_designation_data.php';
      final data = {
        'id': designation.id,
        'message': 'edit',
        'name': designation.desgName,
        'status': 1
      };
      final encodeBody = json.encode(data);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('API response: ${response.body}');
      Logger.warning('Status Code: ${response.statusCode}');
      Logger.success(fullUrl);
      if (response.statusCode == 200) {
        Logger.success('Designation deleted ');
        await fetchDesignations();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to delete department';
        Logger.error('Error deleting designation: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      Logger.error('API Error : $e');
    }
  }
}
