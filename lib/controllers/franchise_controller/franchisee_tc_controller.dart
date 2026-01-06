import 'dart:convert';

import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FranchiseeTcController extends ChangeNotifier {
  final ApiService _apiService;
  FranchiseeTcController({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ─────────────────────────────────────
  // State
  // ─────────────────────────────────────
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  // ─────────────────────────────────────
  // Data (Single Source of Truth)
  // ─────────────────────────────────────
  List<FranchiseePendingTc> _pendingTcs = [];
  List<FranchiseeRegisteredTc> _registeredTcs = [];
  List<FranchiseePendingTc> get pendingTcs => _pendingTcs;
  List<FranchiseeRegisteredTc> get registeredTcs => _registeredTcs;

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> fetchPendingTcs() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType
      };
      Logger.info(
          'fetchPendingTcs body: $body, url: ${AppUrls.getFranchiseePendingTc}');
      final response =
          await _apiService.post(AppUrls.getFranchiseePendingTc, body);
      if (response['success'] != true) {
        throw Failure(
            response['message'] ?? 'Failed to load top travel consultants');
      }
      Logger.info('Franchisee Pending TCs: $response');
      final List data = response['data'] ?? [];
      _pendingTcs =
          data.map((item) => FranchiseePendingTc.fromJson(item)).toList();
      _state = ViewState.success;
    } catch (e) {
      Logger.error('Error in fetchPendingTcs: ${e.toString()}');
      _failure = e is Failure ? e : Failure('Something went wrong');
      Logger.error('FranchiseeTcController.fetchPendingTcs: ${e.toString()}');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchRegisteredTcs() async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': AppData.franchiseeUserType
      };
      Logger.info(
          'fetchRegisteredTcs body: $body, url: ${AppUrls.getFranchiseeRegisteredTc}');
      final response =
          await _apiService.post(AppUrls.getFranchiseeRegisteredTc, body);
      if (response['success'] != true) {
        throw Failure(response['message'] ??
            'Failed to load registered travel consultants');
      }
      Logger.info('Franchisee Registered TCs: $response');
      final List data = response['data'] ?? [];
      _registeredTcs =
          data.map((item) => FranchiseeRegisteredTc.fromJson(item)).toList();
      _state = ViewState.success;
    } catch (e) {
      _failure = e is Failure ? e : Failure('Something went wrong');
      Logger.error('FranchiseeTcController.fetchPendingTcs: $e');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiAddTc(FranchiseePendingTc pendingTc) async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      if (pendingTc.dateOfBirth != null && pendingTc.dateOfBirth!.isNotEmpty) {
        try {
          final oldDob = pendingTc.dateOfBirth!;
          final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(oldDob);
          pendingTc.dateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          Logger.warning('Invalid DOB format: ${pendingTc.dateOfBirth}');
        }
      }

      if (pendingTc.profilePic != null) {
        pendingTc.profilePic =
            extractPathSegment(pendingTc.profilePic!, 'profile_pic/');
      }
      if (pendingTc.aadharCard != null) {
        pendingTc.aadharCard =
            extractPathSegment(pendingTc.aadharCard!, 'aadhar_card/');
      }
      if (pendingTc.panCard != null) {
        pendingTc.panCard = extractPathSegment(pendingTc.panCard!, 'pan_card/');
      }
      if (pendingTc.passbook != null) {
        pendingTc.passbook =
            extractPathSegment(pendingTc.passbook!, 'passbook/');
      }
      if (pendingTc.votingCard != null) {
        pendingTc.votingCard =
            extractPathSegment(pendingTc.votingCard!, 'voting_card/');
      }
      if (pendingTc.paymentProof != null) {
        pendingTc.paymentProof =
            extractPathSegment(pendingTc.paymentProof!, 'payment_proof/');
      }

      final Map<String, dynamic> body = pendingTc.toJson();

      Logger.success('Final Pending TC Body: $body');
      final response = await http.post(
        Uri.parse(AppUrls.franchiseeAddTc),
        body: jsonEncode(body),
      );

      Logger.success(
          'API Response: ${response.body} and statuscode: ${response.statusCode}');
      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(title: 'Added customer successfully');
        await fetchPendingTcs();
      } else {
        ToastHelper.showErrorToast(
            title: 'Error adding customer ${response.body}');
      }

      _state = ViewState.success;
    } catch (e, s) {
      Logger.error('Error adding customer: $e, Stacktrace: $s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
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

  Future<void> apiUpdateRegisteredTc(
      FranchiseeRegisteredTc registeredTc) async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      if (registeredTc.dateOfBirth != null && registeredTc.dateOfBirth!.isNotEmpty) {
        try {
          final oldDob = registeredTc.dateOfBirth!;
          final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(oldDob);
          registeredTc.dateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          Logger.warning('Invalid DOB format: ${registeredTc.dateOfBirth}');
        }
        if (registeredTc.profilePic != null) {
          registeredTc.profilePic =
              extractPathSegment(registeredTc.profilePic!, 'profile_pic/');
        }
        if (registeredTc.aadharCard != null) {
          registeredTc.aadharCard =
              extractPathSegment(registeredTc.aadharCard!, 'aadhar_card/');
        }
        if (registeredTc.panCard != null) {
          registeredTc.panCard =
              extractPathSegment(registeredTc.panCard!, 'pan_card/');
        }
        if (registeredTc.passbook != null) {
          registeredTc.passbook =
              extractPathSegment(registeredTc.passbook!, 'passbook/');
        }
        if (registeredTc.votingCard != null) {
          registeredTc.votingCard =
              extractPathSegment(registeredTc.votingCard!, 'voting_card/');
        }
        if (registeredTc.paymentProof != null) {
          registeredTc.paymentProof =
              extractPathSegment(registeredTc.paymentProof!, 'payment_proof/');
        }
        final Map<String, dynamic> body = registeredTc.toJson();
        Logger.info(
            'Final FranchiseeTcController.apiUpdateRegisteredTc Body: $body');
        final response = await _apiService.post(AppUrls.franchiseeEditTc, body);
        if (response['success'] != true) {
          throw Failure(
              response['message'] ?? 'Failed to load top travel consultants');
        }
        Logger.info('Franchisee Registered TCs: $response');
        ToastHelper.showSuccessToast(title: '${response['message']}');
        Logger.info('Franchisee Registered TCs: $response');
        await fetchRegisteredTcs();
        _state = ViewState.success;
      }
    } catch (e, s) {
      Logger.error('Error updating registered TC: $e, Stacktrace: $s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiDeleteRegisteredTc(
      FranchiseeRegisteredTc registeredTc) async {
    _state = ViewState.loading;
    _failure = null;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
       
        'refid': '',
        'fid': '',
        'action': 'deleted',
        'userId': '',
        'userType': AppData.franchiseeUserType
      };
      Logger.info(
          'Final FranchiseeTcController.apiDeleteRegisteredTc Body: $body');
          // final response = await _apiService.post(AppUrls.deleteFranchiseeTc, body);
    
    } catch (e, s) {
      Logger.error('Error deleting TC registered TC: $e, Stacktrace: $s');
      _failure = e is Failure ? e : Failure('Something went wrong');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }
}
