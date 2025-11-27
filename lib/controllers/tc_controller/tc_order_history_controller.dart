import 'dart:convert';

import 'package:bizzmirth_app/models/order_history/order_history_details.dart';
import 'package:bizzmirth_app/models/order_history/order_history_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_order_history/tc_order_history_recent_booking.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TcOrderHistoryController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _pendingBookingCount;
  String? _inTransitBookingCount;
  String? _completedBookingCount;
  String? _cancelledBookingCount;
  String? _pendingPaymentAmt;
  String? _completedPaymentAmt;
  List<OrderHistoryModel> _orderHistoryData = [];
  List<TcOrderHistoryRecentBooking> _tcOrderHistoryRecentBookings = [];
  OrderHistoryDetails? _orderHistoryDetails;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get pendingBookingCount => _pendingBookingCount;
  String? get inTransitBookingCount => _inTransitBookingCount;
  String? get completedBookingCount => _completedBookingCount;
  String? get cancelledBookingCount => _cancelledBookingCount;
  String? get pendingPaymentAmt => _pendingPaymentAmt;
  String? get completedPaymentAmt => _completedPaymentAmt;
  List<OrderHistoryModel> get orderHistoryData => _orderHistoryData;
  List<TcOrderHistoryRecentBooking> get tcOrderHistoryRecentBookings =>
      _tcOrderHistoryRecentBookings;
  OrderHistoryDetails? get orderHistoryDetails => _orderHistoryDetails;

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  TcOrderHistoryController() {
    initialize();
  }

  Future<void> initialize() async {
    await apiGetStatCount();
    await apiGetRecentBookings();
    await apiGetAllOrderHistoryTableData();
  }

  Future<void> apiGetStatCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String url = AppUrls.getTcOrderHistoryStatCount;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api called made for(get stat count) $url and body: $encodeBody');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: encodeBody,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true && jsonData['data'] != null) {
          final dataCount = jsonData['data'];
          _pendingBookingCount = dataCount['pending_booking_count']?.toString();
          _inTransitBookingCount =
              dataCount['in_transit_booking_count']?.toString();
          _completedBookingCount =
              dataCount['completed_booking_count']?.toString();
          _cancelledBookingCount =
              dataCount['canceled_booking_count']?.toString();
          _pendingPaymentAmt = dataCount['pending_payment_amt']?.toString();
          _completedPaymentAmt = dataCount['completed_payment_amt']?.toString();
        } else {
          _error = 'Cannot fetch stat details. ${response.body}.';
          Logger.error(
              'Failed to fetch stat details. body: ${response.body}. statusCode: ${response.statusCode}');
        }
      } else {
        _error = 'Failed to fetch stat count. ${response.statusCode}';
        Logger.error('Failed with status code: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching order stat counts: $e';
      Logger.error('Error fetching order stat counts: Error:$e, Stacktree: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetRecentBookings({String? selectedDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcRecentBookings;
      final userId = await _getUserId();
      final userTypeId = AppData.tcUserType;
      final body = {
        'userId': userId,
        'userType': userTypeId,
        'selected_date': selectedDate ?? '',
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for tc order history recent booking -> $url. body -> $encodeBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: encodeBody,
      );
      Logger.info('RESPONSE → ${response.body}');

      if (response.statusCode != 200) {
        _error = 'HTTP Error ${response.statusCode}';
        Logger.error('HTTP ERROR ${response.statusCode}');
        return;
      }

      final jsonData = jsonDecode(response.body);
      Logger.info('BOOKINGS JSON → ${jsonData['bookings']}');

      _tcOrderHistoryRecentBookings.clear();

      if (jsonData['bookings'] != null) {
        _tcOrderHistoryRecentBookings = (jsonData['bookings'] as List)
            .map((item) => TcOrderHistoryRecentBooking.fromJson(item))
            .toList();

        Logger.info('Parsed bookings: ${_tcOrderHistoryRecentBookings.length}');
      } else {
        Logger.info('No bookings found.');
      }
    } catch (e, s) {
      _error = 'Error fetching recent bookings: $e';
      Logger.error('Exception → $e\nStacktrace → $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetAllOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcAllTableData;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': startDate ?? '',
        'endDate': endDate ?? ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(tc get all table data) $url, body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for tc all data table ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
          Logger.success('api fetched total ${_orderHistoryData.length}');
        } else {
          _orderHistoryData = [];
          Logger.warning(
              'status is not success or bookings are empty. ${response.body}');
        }
      } else {
        Logger.error(
            'HTTP error. statuscode: ${response.statusCode}, body: ${response.body}');
        _error = 'HTTP error. Please try again';
      }
    } catch (e, s) {
      _error = 'Error fetching data. $e';
      Logger.error(
          'Error fethcing all order history table data. Error: $e, Stacktrace: $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetPendingOrderHisotryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcPendingTableData;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': startDate ?? '',
        'endDate': endDate ?? ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info('api call made for(tc pending table data) $url, Body: $body');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      // Logger.success('respose for pending table data: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
        } else {
          Logger.warning('tc pending table data is empty');
          _orderHistoryData = [];
        }
      } else {
        _error = 'HTTP error. Please try again later';
        Logger.error(
            'Error fetching data, Error: ${response.body}, statuscode: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching pending table data. $e';
      Logger.error(
          'Error fetching tc pending table data. Error: $e, Stacktrace: $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetBookedOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcBookingTableData;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': startDate ?? '',
        'endDate': endDate ?? ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(booked table data) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for tc booked table data ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
        } else {
          Logger.warning('booking table data is empty');
          _orderHistoryData = [];
        }
      } else {
        _error = 'HTTP error. Please try again later';
        Logger.error(
            'Error fetching data, Error: ${response.body}, statuscode: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching booked order history table data. Error: $e';
      Logger.error(
          'Error fetching booked order history table data. Error: $e, Stacktrace: $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetCancelledOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getCancelledTableData;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': startDate ?? '',
        'endDate': endDate ?? ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(cancelled table data) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for tc cancelled table data ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
        } else {
          Logger.warning('booking table data is empty');
          _orderHistoryData = [];
        }
      } else {
        _error = 'HTTP error. Please try again later';
        Logger.error(
            'Error fetching data, Error: ${response.body}, statuscode: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching cancelled order hisotry table data. Error: $e';
      Logger.error(
          'Error fetching cancelled order history table. Error: $e, Stacktrace: $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetRefundOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcRefundTableData;
      final userId = await _getUserId();
      final userType = AppData.tcUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': startDate ?? '',
        'endDate': endDate ?? ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(tc refund order history table data) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for refund table data ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
        } else {
          Logger.warning('booking table data is empty');
          _orderHistoryData = [];
        }
      } else {
        _error = 'HTTP error. Please try again later';
        Logger.error(
            'Error fetching data, Error: ${response.body}, statuscode: ${response.statusCode}');
      }
    } catch (e, s) {
      _error = 'Error fetching refund ordeer history data. Error: $e';
      Logger.error(
          'Error fetching refund order hsitory table. Error: $e, Stacktrace: $s');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiGetOrderHistoryData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getTcOrderDetailsData;
      final orderId = '6';
      final Map<String, dynamic> body = {'id': orderId};
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response from order hisotry data ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['booking'] != null) {
          _orderHistoryDetails = OrderHistoryDetails.fromJson(jsonData);
          Logger.info('details: $_orderHistoryDetails');
        }
      }
    } catch (e, s) {
      _error = 'Error fetching order details. Error: $e';
      Logger.error('Error fetching order details. Error: $e, Stacktrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
