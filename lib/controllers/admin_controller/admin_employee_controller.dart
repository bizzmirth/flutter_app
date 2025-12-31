import 'dart:convert';
import 'dart:io';

import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminEmployeeController extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  final String baseUrl =
      'https://testca.uniqbizz.com/api/employees/all_employees';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<PendingEmployeeModel> _employees = [];
  List<PendingEmployeeModel> get employees => _employees;

  List<RegisteredEmployeeModel> _registerEmployee = [];
  List<RegisteredEmployeeModel> get registerEmployees => _registerEmployee;

  Future<bool> _hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<void> fetchAndSavePendingEmployees() async {
    try {
      _isLoading = true;
      notifyListeners();

      final hasNetwork = await _hasNetwork();
      if (!hasNetwork) {
        Logger.warning('No network connection, using local data');
        _employees = await _isarService.getAll<PendingEmployeeModel>();
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch from API
      final List<PendingEmployeeModel> apiEmployees =
          await _fetchPendingEmployeeFromServer();
      await _isarService.clearAll<PendingEmployeeModel>();
      // Save to local DB
      for (var employee in apiEmployees) {
        await _isarService.save<PendingEmployeeModel>(employee);
      }

      // Update state
      _employees = apiEmployees;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      Logger.error('Error in fetchAndSavePendingEmployees: $e');
      throw Exception('Failed to fetch and save employees');
    }
  }

  // Getter for the employees list

  Future<List<PendingEmployeeModel>> _fetchPendingEmployeeFromServer() async {
    try {
      final fullUrl = '$baseUrl/employee.php?action=pending_employees';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        Logger.warning('API response $jsonResponse');
        Logger.success('Full URL: $fullUrl');

        if (jsonResponse.containsKey('status') &&
            jsonResponse.containsKey('data')) {
          if (jsonResponse['status'] == 'success' &&
              jsonResponse['data'] is List) {
            // Extract the data array
            final List<dynamic> dataList = jsonResponse['data'];
            return dataList
                .map((e) => _pendingEmployeeFromJson(e as Map<String, dynamic>))
                .toList()
                .cast<PendingEmployeeModel>();
          }
        }

        Logger.error('Unexpected API response format');
        return [];
      } else {
        Logger.error('Failed to load employees: ${response.statusCode}');
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error fetching employee: $e');
      throw Exception('Error fetching employee: $e');
    }
  }

  Future<void> fetchAndSaveRegisterEmployees() async {
    try {
      _isLoading = true;
      notifyListeners();

      final hasNetwork = await _hasNetwork();
      if (!hasNetwork) {
        Logger.warning('No network connection, using local data');
        _registerEmployee =
            await _isarService.getAll<RegisteredEmployeeModel>();
        _isLoading = false;
        notifyListeners();
        return;
      }

      final List<RegisteredEmployeeModel> apiEmployees =
          await _fetchregisterEmployeeFromServer();
      await _isarService.clearAll<RegisteredEmployeeModel>();
      for (var employee in apiEmployees) {
        await _isarService.save<RegisteredEmployeeModel>(employee);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      Logger.error('Error in fetchAndSaveRegisterEmployees: $e');
      throw Exception('Failed to fetch and save register employees');
    }
  }

  Future<List<RegisteredEmployeeModel>>
      _fetchregisterEmployeeFromServer() async {
    try {
      final fullUrl = '$baseUrl/employee.php?action=registered_employees';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        Logger.success('API response from register $jsonResponse');
        Logger.success('Full URL: $fullUrl');

        if (jsonResponse.containsKey('status') &&
            jsonResponse.containsKey('data')) {
          if (jsonResponse['status'] == 'success' &&
              jsonResponse['data'] is List) {
            final List<dynamic> dataList = jsonResponse['data'];
            return dataList
                .map((e) =>
                    _registeredEmployeeFromJson(e as Map<String, dynamic>))
                .toList()
                .cast<RegisteredEmployeeModel>();
          }
        }
        Logger.error('Unexpected API response format');
        return [];
      } else {
        Logger.error('Failed to load employees: ${response.statusCode}');
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error fetching register employee: $e');
      throw Exception('Error fetching register employee: $e');
      // return []; // Return empty list on error
    }
  }

  Future<String> convertImageToBase64(String imagePath) async {
    try {
      // Read the image as bytes
      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      // Convert the image bytes to a Base64 string
      return base64Encode(bytes);
    } catch (e) {
      Logger.error('Error converting image to Base64: $e');
      return '';
    }
  }

  String formatDateForApi(String inputDate) {
    try {
      // Parse the input date in dd-mm-yyyy format
      final List<String> dateParts = inputDate.split('-');
      if (dateParts.length != 3) {
        Logger.error('Invalid date format: $inputDate');
        return inputDate; // Return original if format is invalid
      }

      final String day = dateParts[0].padLeft(2, '0'); // Ensure day is 2 digits
      final String month =
          dateParts[1].padLeft(2, '0'); // Ensure month is 2 digits
      final String year = dateParts[2];

      // Construct date in YYYY-MM-DD format
      return '$year-$month-$day';
    } catch (e) {
      Logger.error('Error formatting date: $e');
      return inputDate; // Return original in case of error
    }
  }

  Future<bool> addEmployee(PendingEmployeeModel employee) async {
    try {
      final fullUrl = '$baseUrl/add_employee_data.php';
      formatDateForApi(employee.dateOfBirth!);
      formatDateForApi(employee.dateOfJoining!);

      final profilePicPath = employee.profilePicture != null
          ? extractPathSegment(employee.profilePicture!, 'profile_pic/')
          : '';
      final idProofPath = employee.idProof != null
          ? extractPathSegment(employee.idProof!, 'id_proof/')
          : '';
      final bankDetailsPath = employee.bankDetails != null
          ? extractPathSegment(employee.bankDetails!, 'passbook/')
          : '';

      Logger.success('Trimmed profile path : $profilePicPath');
      Logger.success('Trimmed ID Proof : $idProofPath');
      Logger.success('Trimmed bank details : $bankDetailsPath');

      final Map<String, dynamic> requestBody = {
        'name': employee.name,
        'birth_date': employee.dateOfBirth,
        'country_cd': '91', // Hard-coded as per your example
        'contact': employee.mobileNumber,
        'email': employee.email,
        'address': employee.address,
        'gender': employee.gender,
        'joining_date': employee.dateOfJoining,
        'department': employee.department,
        'designation': employee.designation,
        'zone': employee.zone,
        'branch': employee.branch,
        'reporting_manager': employee.reportingManager,
        'profile_pic': profilePicPath,
        'id_proof': idProofPath,
        'bank_details': bankDetailsPath,
      };

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      Logger.info(
          'Add employee API response status: ${json.encode(requestBody)}');
      Logger.info('Add employee API response body: ${response.body}');

      if (response.statusCode == 200) {
        Logger.error('Full Url : $fullUrl');
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData['status'] == 'success') {
          Logger.success('Employee added successfully');
          return true;
        } else {
          Logger.error(
              'Failed to add employee: ${responseData['message'] ?? 'Unknown error'}');
          return false;
        }
      } else {
        Logger.error('Failed to add employee: ${response.statusCode}');
        Logger.error('Failed to add employee: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger.error('Error adding employee: $e');
      return false;
    }
  }

  Future<void> uploadImage(String folder, String savedImagePath) async {
    try {
      final fullUrl = 'http://testca.uniqbizz.com/api/upload_mobile.php';
      final request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', savedImagePath));
      request.fields['folder'] = folder;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Logger.warning('Raw API response body: $responseBody');
      Logger.success('Upload Api FULL URL: $fullUrl');
      Logger.info('this is reuest $request');
    } catch (e) {
      Logger.error('Error uploading image: $e');
    }
  }

// for now this delete function is just changing the status of the employee
  Future<void> deletePendingEmployee(int employeeId) async {
    try {
      final fullUrl = '$baseUrl/delete_employee.php';
      final formData = {
        'id': employeeId.toString(),
        'action': 'deactivate',
        'reid': '',
        'userType': '25',
      };

      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: formData,
          encoding: Encoding.getByName('utf-8'));
      Logger.info('Raw API response body: ${response.statusCode}');

      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = json.decode(response.body);
        Logger.warning('Delete API response: ${response.body}');
        Logger.success('Full URL: $fullUrl');
      } else {
        Logger.error('Failed to delete employee: ${response.body.trim()}');
      }
    } catch (e) {
      Logger.error('Error deleting employee: $e');
    }
  }

  Future<void> deleteRegisteredEmployee(int employeeID) async {
    try {
      final fullUrl = '$baseUrl/delete_employee.php';
      final formData = {
        'id': employeeID.toString(),
        'action': 'deactivate',
        'reid': '',
        'userType': '25',
      };

      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: formData,
          encoding: Encoding.getByName('utf-8'));
      Logger.info('Raw API response body: ${response.statusCode}');

      if (response.statusCode == 200) {
        Logger.warning('Delete API response: ${response.body}');
        Logger.success('Full URL: $fullUrl');
      } else {
        Logger.error('Failed to delete employee: ${response.body.trim()}');
      }
    } catch (e) {
      Logger.error('Error deleting employee: $e');
    }
  }

  Future<bool> updatePendingEmployees(PendingEmployeeModel employee) async {
    try {
      final fullUrl = '$baseUrl/edit_employee_data.php';
      final profilePicPath =
          extractPathSegment(employee.profilePicture!, 'profile_pic/');
      final idProofPath = extractPathSegment(employee.idProof!, 'id_proof/');
      final bankDetailsPath =
          extractPathSegment(employee.bankDetails!, 'passbook/');
      Logger.success('Trimmed profile path : ${employee.profilePicture!}');

      final Map<String, dynamic> requestBody = {
        'editfor': 'pending',
        'id': employee.id.toString(),
        'name': employee.name,
        'birth_date': employee.dateOfBirth,
        'country_cd': '91', // Hard-coded as per your example
        'contact': employee.mobileNumber,
        'email': employee.email,
        'address': employee.address,
        'gender': employee.gender,
        'joining_date': employee.dateOfJoining,
        'department': employee.department,
        'designation': employee.designation,
        'zone': employee.zone,
        'branch': employee.branch,
        'reporting_manager': employee.reportingManager,
        'profile_pic': profilePicPath,
        'id_proof': idProofPath,
        'bank_details': bankDetailsPath,
      };

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody));

      Logger.info(
          'Edit employee API request body: ${json.encode(requestBody)}');
      Logger.info('Edit employee API response body: ${response.body}');
      Logger.info('Edit employee API response body: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.body;
        Logger.success('response of update api:  $responseData');
        return true;
      } else {
        Logger.error('Failed to update employee: ${response.statusCode}');
        Logger.error('Failed to update employee: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger.error('Error updating pending employee: $e');
      return false;
    }
  }

  Future<bool> updateRegisterEmployee(RegisteredEmployeeModel employee) async {
    try {
      final fullUrl = '$baseUrl/edit_employee_data.php';
      final profilePicPath =
          extractPathSegment(employee.profilePicture!, 'profile_pics/');
      final idProofPath = extractPathSegment(employee.idProof!, 'id_proof/');
      final bankDetailsPath =
          extractPathSegment(employee.bankDetails!, 'passbook/');

      final Map<String, dynamic> requestBody = {
        'editfor': 'registered',
        'id': employee.regId,
        'name': employee.name,
        'birth_date': employee.dateOfBirth,
        'country_cd': '91', // Hard-coded as per your example
        'contact': employee.mobileNumber,
        'email': employee.email,
        'address': employee.address,
        'gender': employee.gender,
        'joining_date': employee.dateOfJoining,
        'department': employee.department,
        'designation': employee.designation,
        'zone': employee.zone,
        'branch': employee.branch,
        'reporting_manager': employee.reportingManager,
        'profile_pic': profilePicPath,
        'id_proof': idProofPath,
        'bank_details': bankDetailsPath,
      };

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody));

      Logger.info(
          'Edit employee API request body: ${json.encode(requestBody)}');
      Logger.info('Edit employee API response body: ${response.body}');
      Logger.info('Edit employee API response body: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.body;
        Logger.success('response of update api:  $responseData');
        return true;
      } else {
        Logger.error('Failed to update employee: ${response.statusCode}');
        Logger.error('Failed to update employee: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger.error('Error updating pending employee: $e');
      return false;
    }
  }

  Future<bool> apiUpdateEmployeeStatus(
      BuildContext context, Id? id, String? email) async {
    try {
      final fullUrl = '$baseUrl/confirm_employee.php';
      final Map<String, dynamic> requestBody = {
        'id': id.toString(),
        'uname': email,
      };

      final encodeBody = jsonEncode(requestBody);

      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: encodeBody);

      Logger.success('Api Request body : $requestBody');
      Logger.success('Api Response body : ${response.body}');
      Logger.info('Api response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Wait for the fetch to complete
        await fetchAndSaveRegisterEmployees();
        notifyListeners();
        return true;
      } else {
        Logger.error(
            'Failed to update employee status: ${response.statusCode}');
        Logger.error('Failed to update employee status: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger.error('Error updating employee status: $e');
      return false;
    }
  }

  Future<void> apiGetZone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullUrl = '$baseUrl/add_employees_zone.php';
      final response = await http.get(Uri.parse(fullUrl));
      Logger.success(
          'Response Code: ${response.statusCode} Api Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          // Convert the zones array to a string for storage
          final zonesData = json.encode(jsonData['zones']);

          // Save zones data to SharedPreferences
          await prefs.setString('zones', zonesData);
          Logger.success('Zones data saved to SharedPreferences');
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
        }
      }
    } catch (e) {
      Logger.error('Error getting zones: $e');
    }
  }

  Future<void> apiGetBranchs(String zoneId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullUrl = '$baseUrl/add_employees_branch.php';
      final requestBody = {'zone_id': zoneId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success(
          'Response Code: ${response.statusCode} Api Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final branchesData = json.encode(jsonData['branches']);
          await prefs.setString('branches_$zoneId', branchesData);
          Logger.success(
              'Branches data saved to SharedPreferences for zone $zoneId');
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
        }
      }
    } catch (e) {
      Logger.error('Error getting branches: $e');
    }
  }

  PendingEmployeeModel _pendingEmployeeFromJson(Map<String, dynamic> json) {
    try {
      final employee = PendingEmployeeModel()
        ..id = parseIntSafely(json['id']) // Use auto-increment for local ID
        ..regId = json['employee_id'] ?? ''
        ..name = json['name'] ?? ''
        ..mobileNumber = json['contact'] ?? ''
        ..email = json['email'] ?? ''
        ..address = json['address'] ?? ''
        ..gender = capitalize(json['gender'] ?? '')
        ..dateOfBirth = json['date_of_birth'] ?? ''
        ..dateOfJoining = json['added_on'] ?? ''
        ..status = parseIntSafely(json['status']) ?? 1
        ..department = parseIntSafely(json['department']).toString()
        ..designation = parseIntSafely(json['designation']).toString()
        ..zone = parseIntSafely(json['zone']).toString()
        ..branch = parseIntSafely(json['branch']).toString()
        ..reportingManager = json['reporting_manager'] ?? ''
        ..reportingManagerName = json['reporting_manager_name'] ?? ''
        ..profilePicture = json['profile_pic'] ?? ''
        ..idProof = json['id_proof'] ?? ''
        ..bankDetails = json['bank_details'] ?? '';

      return employee;
    } catch (e) {
      Logger.error('Error parsing employee: $e for data: $json');
      throw Exception('Error parsing employee: $e');
    }
  }

  RegisteredEmployeeModel _registeredEmployeeFromJson(
      Map<String, dynamic> json) {
    try {
      final employee = RegisteredEmployeeModel()
        ..id = parseIntSafely(json['id']) // Use auto-increment for local ID
        ..regId = json['employee_id']
        ..name = json['name'] ?? ''
        ..mobileNumber = json['contact'] ?? ''
        ..email = json['email'] ?? ''
        ..address = json['address'] ?? ''
        ..gender = capitalize(json['gender'] ?? '')
        ..dateOfBirth = json['date_of_birth'] ?? ''
        ..dateOfJoining = json['date_of_joining'] ?? ''
        ..status = parseIntSafely(json['status']) ?? 1
        ..department = parseIntSafely(json['department']).toString()
        ..designation = parseIntSafely(json['designation']).toString()
        ..zone = parseIntSafely(json['zone']).toString()
        ..branch = parseIntSafely(json['branch']).toString()
        ..reportingManager = json['reporting_manager'] ?? ''
        ..reportingManagerName = json['reporting_manager_name'] ?? ''
        ..profilePicture = json['profile_pic'] ?? ''
        ..idProof = json['id_proof'] ?? ''
        ..bankDetails = json['bank_details'] ?? ''
        ..userType = json['user_type'];

      return employee;
    } catch (e) {
      Logger.error('Error parsing registered employee: $e for data: $json');
      throw Exception('Error parsing registered employee: $e');
    }
  }
}
