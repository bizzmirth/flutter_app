import 'dart:convert';
import 'package:bizzmirth_app/models/tc_models/tc_markup/tc_markup_model.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcMarkupController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TcMarupModel> _tcMarkupDetails = [];
  List<TcMarupModel> _allTcMarkupDetails = [];
  List<TcMarupModel> _masterMarkupDetails = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TcMarupModel> get tcMarkupDetails => _tcMarkupDetails;

  TcMarkupController() {
    initialize();
  }

  Future<void> initialize() async {
    await apiGetProductMarkup();
  }

  // ✅ Fetch Markup Details
  Future<void> apiGetProductMarkup() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final String url = AppUrls.getTcMarkupDetails;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        'user_id': userId,
        'user_type': AppData.tcUserType,
      };
      final encodeBody = jsonEncode(body);

      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success(
          'Markup details, URL: $url  \n Body: $encodeBody \n Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];

          final List<TcMarupModel> fetched =
              data.map((item) => TcMarupModel.fromJson(item)).toList();

          _masterMarkupDetails = List.from(fetched); // ✅ Keep original copy
          _allTcMarkupDetails = List.from(fetched);
          _tcMarkupDetails = List.from(fetched);

          Logger.success('Fetched ${_tcMarkupDetails.length} markup details.');
          Logger.success(
              'Markup details, URL: $url  \n Body: $encodeBody \n Response: ${response.body}');
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

  // ✅ Update displayed list manually (if needed)
  void setMarkupDetails(List<TcMarupModel> details) {
    _allTcMarkupDetails = List.from(details);
    _tcMarkupDetails = List.from(details);
    notifyListeners();
  }

  // ✅ Filter by Package Type (includes "All")
  void filterMarkupByPackageType(String? selectedPackageType) {
    if (selectedPackageType == null ||
        selectedPackageType.isEmpty ||
        selectedPackageType.toLowerCase() == 'all') {
      _tcMarkupDetails = List.from(_allTcMarkupDetails);
    } else {
      _tcMarkupDetails = _allTcMarkupDetails
          .where((item) => item.packageType == selectedPackageType)
          .toList();
    }
    notifyListeners();
  }

  Future<void> apiGetFilterMarkupByPackageType(
      String? selectedPackageType) async {
    try {
      // _isLoading = true;
      _error = null;
      notifyListeners();

      if (selectedPackageType == null ||
          selectedPackageType.isEmpty ||
          selectedPackageType.toLowerCase() == 'all') {
        _allTcMarkupDetails = List.from(_masterMarkupDetails);
        _tcMarkupDetails = List.from(_masterMarkupDetails);
        notifyListeners();
        return;
      }
      final String url = AppUrls.getTcMarkupDetails;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        'user_id': userId,
        'user_type': AppData.tcUserType,
        'travelType': selectedPackageType
      };

      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      Logger.success(
          'Filtered markup details, \t URL: $url, \t Body: $body, \t Response: ${response.body}, \t StatusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];

          _allTcMarkupDetails =
              data.map((item) => TcMarupModel.fromJson(item)).toList();
          _tcMarkupDetails = List.from(_allTcMarkupDetails);
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
      Logger.error('Error fethcing filtered markup details, $e, Stacktree: $s');
      _error = 'Error in fetching markup details';
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Update Markup API
  Future<void> apiUpdateMarkUp(
    String packageId,
    String markup,
    String adultPrice,
    String childPrice,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final String url = AppUrls.getTcUpdateMarkup;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        'ta_id': userId,
        'package_id': packageId,
        'product_price_adult': adultPrice,
        'product_price_child': childPrice,
        'markup': markup,
      };

      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);

      Logger.warning(
          'Response: ${response.body} ======= statusCode: ${response.statusCode}');
    } catch (e, s) {
      Logger.error('Error updating markup. $e, $s');
      _error = 'Error updating markup: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
