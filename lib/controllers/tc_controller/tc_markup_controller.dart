import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_markup/tc_markup_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcMarkupController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TcMarupModel> _tcMarkupDetails = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TcMarupModel> get tcMarkupDetails => _tcMarkupDetails;

  TcMarkupController() {
    initialize();
  }

  Future<void> initialize() async {
    await apiGetProductMarkup();
  }

  Future<void> apiGetProductMarkup() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final String url = AppUrls.getTcMarkupDetails;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {'user_id': userId, 'user_type': '11'};
      final encodeBody = jsonEncode(body);

      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success(
          'Markup details, URL: $url  \n Body: $encodeBody \n Response: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          _tcMarkupDetails.clear();
          final List<dynamic> data = jsonData['data'];
          _tcMarkupDetails =
              data.map((item) => TcMarupModel.fromJson(item)).toList();

          Logger.success('Fetched ${_tcMarkupDetails.length} markup details.');
        } else {
          _error = jsonData['message'] ?? 'Failed to fetch markup details';
          Logger.error(
              'Error in fetching markup details: $_error, \n Response: ${response.body}, \n statusCode: ${response.statusCode}');
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        Logger.error(
            'Server error while fetching markup details: ${response.statusCode}, \n Response: ${response.body}');
      }
    } catch (e, s) {
      Logger.error(
          'Error in fetching markup details, error: $e, stackTrace: $s');
      _error = 'Error in fetching markup details';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiUpdateMarkUp(String packageId, String markup,
      String adultPrice, String childPrice) async {
    try {
      _isLoading = false;
      _error = null;
      notifyListeners();

      final String url = AppUrls.getTcUpdateMarkup;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        'ta_id': userId,
        'package_id': packageId,
        'product_price_adult': adultPrice,
        'product_price_child': childPrice,
        'markup': markup
      };
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.warning(
          'Response: ${response.body} ======= statucCode: ${response.statusCode}');
    } catch (e, s) {
      Logger.error('Error updating markup. $e, $s');
      _error = 'Error updating markup: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
