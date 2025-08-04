import 'dart:convert';

import 'package:bizzmirth_app/models/cust_product_payout_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustProductPayoutController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<CustProductPayoutModel> _allPayouts = [];
  List<CustProductPayoutModel> get allPayouts => _allPayouts;

  void getAllPayouts(userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/payouts/reference_payouts/customer_all_payouts.php";

      final Map<String, dynamic> body = {
        "userId": userId,
      };
      final response = await http.post(Uri.parse(fullUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      Logger.success("Response from all payout: ${response.body}");

      if (response.statusCode == 200) {
        _allPayouts.clear();
        final data = jsonDecode(response.body);
        Logger.success("Data fetched successfully: $data");

        if (data['status'] == true && data['data'] is List) {
          final List<dynamic> payoutList = data['data'];

          for (var payoutJson in payoutList) {
            try {
              final payout = CustProductPayoutModel.fromJson(payoutJson);
              _allPayouts.add(payout);
            } catch (e) {
              Logger.error("Error parsing payout item: $e");
            }
          }

          Logger.success("Successfully loaded ${_allPayouts.length} payouts");
        } else {
          Logger.error(
              "Invalid response structure: ${data['message'] ?? 'Unknown error'}");
          _error = data['message'] ?? "Invalid response format";
        }
      } else {
        Logger.error("Failed to fetch payouts: ${response.statusCode}");
        _error = "Failed to fetch payouts. Please try again later.";
      }
    } catch (e, s) {
      Logger.error("Error fetching payouts: Error: $e, StackTrace: $s");
      _error = "Failed to fetch payouts. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
