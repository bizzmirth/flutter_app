import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_all_product_payout_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_product_payouts/tc_product_payout_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcProductPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TcAllProductPayoutModel> _allProductPayouts = [];
  List<TcProductPayoutModel> _previousProductPayouts = [];
  List<TcProductPayoutModel> _nextProductPayouts = [];
  List<TcProductPayoutModel> _totalProductPayouts = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TcAllProductPayoutModel> get allProductPayouts => _allProductPayouts;
  List<TcProductPayoutModel> get previousProductPayouts =>
      _previousProductPayouts;
  List<TcProductPayoutModel> get nextProductPayouts => _nextProductPayouts;
  List<TcProductPayoutModel> get totalProductPayouts => _totalProductPayouts;

  TcProductPayoutController() {
    initialize();
  }

  Future<void> initialize() async {
    await apiGetTcAllProductPayouts();
  }

  Future<void> apiGetPreviousProductPayouts() async {
    // TODO Implementation for fetching previous product payouts
  }

  Future<void> apiGetNextProductPayouts() async {
    // TODO Implementation for fetching next product payouts
  }

  Future<void> apiGetTotalProductPayouts() async {
    // TODO Implementation for fetching total product payouts
  }

  Future<void> apiGetTcAllProductPayouts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcProductAllPayouts;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType
      };
      Logger.info(
          'Fetching TC all product payouts with body: $body from the URL: $url');
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      Logger.info(
          'Received response with status code: ${response.statusCode} and body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['payouts'] != null) {
          final List payouts = jsonResponse['payouts'];
          _allProductPayouts = payouts
              .map((payoutJson) => TcAllProductPayoutModel.fromJson(payoutJson))
              .toList();
          Logger.info(
              'Fetched ${_allProductPayouts.length} product payouts successfully.');
        }
      }
    } catch (e, s) {
      _error = 'Error fetching tc all product payouts: $e';
      Logger.error('Error fetching tc all payouts. Error: $e, Stacktrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
