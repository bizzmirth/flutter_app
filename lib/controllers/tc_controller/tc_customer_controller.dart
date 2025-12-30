import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_pending_customer_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_registered_customer_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TcCustomerController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isCheckingEmail = false;
  String? _emailError;
  String? _error;
  List<TcPendingCustomerModel> _pendingCustomers = [];
  List<TcRegisteredCustomerModel> _registeredCustomers = [];

  bool get isLoading => _isLoading;
  bool get isCheckingEmail => _isCheckingEmail;
  String? get error => _error;
  String? get emailError => _emailError;
  List<TcPendingCustomerModel> get pendingCustomers => _pendingCustomers;
  List<TcRegisteredCustomerModel> get registeredCustomers =>
      _registeredCustomers;

  TcCustomerController() {
    initialize();
  }

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
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
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.tcUserType,
      };
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          _pendingCustomers = data
              .map((item) => TcPendingCustomerModel.fromJson(item))
              .toList();
          Logger.success(
              'response to the URL: $url, Response: ${response.body}');
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
         final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.tcUserType,
      };
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        _registeredCustomers.clear();
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          _registeredCustomers = data
              .map((item) => TcRegisteredCustomerModel.fromJson(item))
              .toList();
               Logger.success(
              'response to the registered customer URL: $url, Response: ${response.body}');
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

  Future<void> apiAddCustomer(TcPendingCustomerModel customer) async {
    try {
      _isLoading = false;
      _error = null;
      notifyListeners();
      if (customer.dateOfBirth != null && customer.dateOfBirth!.isNotEmpty) {
        try {
          final oldDob = customer.dateOfBirth!;
          final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(oldDob);
          customer.dateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          Logger.warning('Invalid DOB format: ${customer.dateOfBirth}');
        }
      }

      if (customer.profilePic != null) {
        customer.profilePic =
            extractPathSegment(customer.profilePic!, 'profile_pic/');
      }
      if (customer.aadharCard != null) {
        customer.aadharCard =
            extractPathSegment(customer.aadharCard!, 'aadhar_card/');
      }
      if (customer.panCard != null) {
        customer.panCard = extractPathSegment(customer.panCard!, 'pan_card/');
      }
      if (customer.passbook != null) {
        customer.passbook = extractPathSegment(customer.passbook!, 'passbook/');
      }
      if (customer.votingCard != null) {
        customer.votingCard =
            extractPathSegment(customer.votingCard!, 'voting_card/');
      }
      if (customer.paymentProof != null) {
        customer.paymentProof =
            extractPathSegment(customer.paymentProof!, 'payment_proof/');
      }

      final Map<String, dynamic> body = customer.toJson();

      Logger.success('Final Customer Body: $body');

      final response = await http.post(
        Uri.parse(AppUrls.addTcCustomer),
        body: jsonEncode(body),
      );

      Logger.success(
          'API Response: ${response.body} and statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(title: 'Added customer successfully');
        await apiGetTcPendingCustomers();
      } else {
        ToastHelper.showErrorToast(
            title: 'Error adding customer ${response.body}');
      }
    } catch (e, s) {
      Logger.error('Error adding customer: $e, Stacktrace: $s');
      _error = 'Error adding customer $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiUpdateRegsiteredCustomer(
      TcRegisteredCustomerModel customer) async {
    try {
      _isLoading = false;
      _error = null;
      notifyListeners();

      final url = AppUrls.updateTcCustomer;

      if (customer.dateOfBirth != null && customer.dateOfBirth!.isNotEmpty) {
        try {
          final oldDob = customer.dateOfBirth!;
          final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(oldDob);
          customer.dateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          Logger.warning('Invalid DOB format: ${customer.dateOfBirth}');
        }
      }

      if (customer.profilePic != null) {
        customer.profilePic =
            extractPathSegment(customer.profilePic!, 'profile_pic/');
      }
      if (customer.aadharCard != null) {
        customer.aadharCard =
            extractPathSegment(customer.aadharCard!, 'aadhar_card/');
      }
      if (customer.panCard != null) {
        customer.panCard = extractPathSegment(customer.panCard!, 'pan_card/');
      }
      if (customer.passbook != null) {
        customer.passbook = extractPathSegment(customer.passbook!, 'passbook/');
      }
      if (customer.votingCard != null) {
        customer.votingCard =
            extractPathSegment(customer.votingCard!, 'voting_card/');
      }
      if (customer.paymentProof != null) {
        customer.paymentProof =
            extractPathSegment(customer.paymentProof!, 'payment_proof/');
      }

      final Map<String, dynamic> body = customer.toJson();
      body['editfor'] = 'registered';
      final encodeBody = jsonEncode(body);
      Logger.success('final url : $url, final customer body : $encodeBody');

      final response = await http.post(Uri.parse(url), body: encodeBody);
      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(title: 'Customer updated successfully');
        await apiGetTcRegisteredCustomers();
      } else {
        ToastHelper.showErrorToast(
            title: 'Error adding customer ${response.body}');
      }

      Logger.success(
          'API Response: ${response.body} and statuscode: ${response.statusCode}');
    } catch (e, s) {
      Logger.error('Error updating customer: $e, Stacktrace: $s');
      _error = 'Error adding customer $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkEmail(String email) async {
    if (email.isEmpty) {
      _emailError = 'Please enter your email';
      notifyListeners();
      return;
    }

    _isCheckingEmail = true;
    notifyListeners();
    try {} catch (e, s) {
      _emailError = 'Error connecting to server $e';
      Logger.error('Error checking email. Error:$e, Stacktrace: $s');
    }
  }

  Future<void> uploadImage(String folder, String savedImagePath) async {
    try {
      final fullUrl = AppUrls.uploadImage;
      final request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', savedImagePath));
      request.fields['folder'] = folder;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Logger.warning('Raw API response body: $responseBody');
      Logger.success('Upload Api FULL URL: $fullUrl');
      Logger.info('this is reuest $request');

      // if (responseBody == '1') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Upload Failed  $responseBody")));
      // } else if (responseBody == '2') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Invalid File Extension  $responseBody")));
      // } else if (responseBody == '3') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("No File Selected  $responseBody")));
      // } else if (responseBody == '4') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("File Size Exceeds 2MB  $responseBody")));
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Upload Successful: $responseBody")));
      // }
    } catch (e) {
      Logger.error('Error uploading image: $e');
    }
  }
}
