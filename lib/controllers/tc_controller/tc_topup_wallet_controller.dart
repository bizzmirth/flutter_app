import 'dart:convert';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_list_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_wallet_balance_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcTopupWalletController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  TcTopupWalletBalanceModel? _walletBalanceModel;
  List<TcTopupRequestList> _topUpRequests = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  TcTopupWalletBalanceModel? get walletBalanceModel => _walletBalanceModel;
  List<TcTopupRequestList> get topUpRequests => _topUpRequests;

  TcTopupWalletController() {
    initialiseData();
  }

  Future<void> initialiseData() async {
    await apiGetTcTopupWalletBalance();
    await apiGetTcTopupRequestList();
  }

  Future<void> apiGetTcTopupWalletBalance() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcTopupWalletDetails;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final Map<String, dynamic> body = {
        'userId': userId,
      };
      Logger.info('Fetching wallet balance from $url with body: $body');

      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Logger.success('Wallet Balance Response: $responseData');
        if (responseData['success'] == true) {
          final data = responseData['data'];
          _walletBalanceModel = TcTopupWalletBalanceModel.fromJson(data);
        } else {
          _error = responseData['message'] ?? 'Unknown error occurred';
          Logger.error('Error fetching wallet balance: ${response.body}');
        }
      } else {
        _error =
            'Failed to fetch wallet balance. Status code: ${response.statusCode}';
        Logger.error(
            'Failed to fetch wallet balance. Response Body: ${response.body} Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching wallet balance: Error:$e';
      Logger.error('Error fetching wallet balance. Error: $e, Stacktrace:$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> apiAddTcTopupWalletBalance(TopUpRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.addTcTopupWalletAmount;
      final body = request.toJson();

      Logger.info('Adding Topup Wallet Amount at $url with body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success(
          'Topup Wallet Response: ${response.body} and Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          // ✅ Success case
          final data = responseData['data'];
          Logger.success('✅ Wallet Top-up Successful: $data');
          return true;
        } else {
          _error = responseData['message'] ?? 'Unknown error occurred';
          Logger.error('⚠️ Wallet Top-up Failed: $_error');
          return false;
        }
      } else {
        _error =
            'Failed to add wallet balance. Status code: ${response.statusCode}';
        Logger.error(
            '❌ HTTP Error: ${response.statusCode}, Response: ${response.body}');
        return false;
      }
    } catch (e, s) {
      _error = 'Error adding wallet balance: $e';
      Logger.error('💥 Exception in Topup Wallet: $e\n$s');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetTcTopupRequestList() async {
    try {
      final url = AppUrls.getTcTopupRequestList;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userId = loginRes?.userId ?? '';
      final body = {'userId': userId};
      Logger.info('Fetching topup request list from $url with body: $body');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      Logger.success(
          'Topup Request List Response: ${response.body} and Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          _topUpRequests =
              data.map((item) => TcTopupRequestList.fromJson(item)).toList();
        } else {
          _error = responseData['message'] ?? 'Unknown error occurred';
          Logger.error('Error fetching topup request list: ${response.body}');
        }
      } else {
        _error =
            'Failed to fetch topup request list. Status code: ${response.statusCode}';
        Logger.error(
            'Failed to fetch topup request list. Response Body: ${response.body} Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      Logger.error(
          'Error fetching topup request list:Error $e, Stacktrace: $s');
      _error = 'Error fetching topup request list: Error $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
