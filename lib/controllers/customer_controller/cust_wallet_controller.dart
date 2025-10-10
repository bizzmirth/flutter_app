import 'dart:convert';

import 'package:bizzmirth_app/models/customer_models/cust_booking_wallet_history_model.dart';
import 'package:bizzmirth_app/models/customer_models/cust_redeemable_wallet_history_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustWalletController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _referenceCountTotal;
  String? _referenceCountThisMonth;
  String? _bookingPointsCountTotal;
  String? _bookingPointsCountThisMonth;
  final List<CustRedeemableWalletHistory> _custRedeemableWalletHistory = [];
  final List<CustBookingWalletHistory> _custBookingWalletHistory = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get referenceCountTotal => _referenceCountTotal;
  String? get referenceCountThisMonth => _referenceCountThisMonth;
  String? get bookingPointsCountTotal => _bookingPointsCountTotal;
  String? get bookingPointsCountThisMonth => _bookingPointsCountThisMonth;
  List<CustRedeemableWalletHistory> get custRedeemableWalletHistory =>
      _custRedeemableWalletHistory;
  List<CustBookingWalletHistory> get custBookingWalletHistory =>
      _custBookingWalletHistory;

  Future<void> apiGetWalletDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getWalletDetails;
      final String? userId = await SharedPrefHelper().getCurrentUserCustId();

      final Map<String, dynamic> body = {'userId': userId};
      final encodeBody = json.encode(body);

      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);

      Logger.success('Response from wallet details: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          final walletData = data['data'];

          final referenceCount = walletData['reference_count'];
          _referenceCountTotal = referenceCount['total']?.toString();
          _referenceCountThisMonth = referenceCount['this_month']?.toString();

          final bookingPointsCount = walletData['booking_points_count'];
          _bookingPointsCountTotal = bookingPointsCount['total']?.toString();
          _bookingPointsCountThisMonth =
              bookingPointsCount['this_month']?.toString();
          final historyData = walletData['0'];

          _custRedeemableWalletHistory.clear();
          _custBookingWalletHistory.clear();
          Logger.success('wallet details full URL: $fullUrl');

          final redeemableHistory =
              historyData['redeemable_wallet_history'] as List<dynamic>?;
          if (redeemableHistory != null && redeemableHistory.isNotEmpty) {
            for (var historyJson in redeemableHistory) {
              try {
                final historyModel =
                    CustRedeemableWalletHistory.fromJson(historyJson);
                _custRedeemableWalletHistory.add(historyModel);
              } catch (e) {
                Logger.error('Error parsing redeemable wallet history: $e');
              }
            }
          }

          final bookingHistory =
              historyData['booking_wallet_history'] as List<dynamic>?;
          if (bookingHistory != null && bookingHistory.isNotEmpty) {
            for (var historyJson in bookingHistory) {
              try {
                final historyModel =
                    CustBookingWalletHistory.fromJson(historyJson);
                _custBookingWalletHistory.add(historyModel);
              } catch (e) {
                Logger.error('Error parsing booking wallet history: $e');
              }
            }
          }
          Logger.success(
              'Successfully populated customer ${_custRedeemableWalletHistory.length} redeemable wallet history records');
          Logger.success(
              'Successfully populated ${_custBookingWalletHistory.length} booking wallet history records');

          Logger.success('Wallet data populated successfully');
          Logger.success(
              'Reference Count - Total: $_referenceCountTotal, This Month: $_referenceCountThisMonth');
          Logger.success(
              'Booking Points - Total: $_bookingPointsCountTotal, This Month: $_bookingPointsCountThisMonth');
        } else {
          _error = data['message'] ?? 'Failed to fetch wallet details';
          Logger.error("API returned error: ${data['message']}");
        }
      } else {
        _error =
            'Failed to fetch wallet details. Status: ${response.statusCode}';
        Logger.error('HTTP Error: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching wallet details $e';
      Logger.error('Error fetching wallet details. Error: $e, Stacktree: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
