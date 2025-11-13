import 'dart:convert';
import 'package:bizzmirth_app/models/customer_models/cust_order_history_recent_booking.dart';
import 'package:bizzmirth_app/models/order_history/customer.dart';
import 'package:bizzmirth_app/models/order_history/order_history_model.dart';
import 'package:bizzmirth_app/models/order_history/payment.dart';
import 'package:bizzmirth_app/models/order_history/travel_agency.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustOrderHistoryController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _pendingBookingCount;
  String? _inTransitBookingCount;
  String? _completedBookingCount;
  String? _cancelledBookingCount;
  String? _pendingPaymentAmt;
  String? _completedPaymentAmt;
  List<CustOrderHistoryRecentBooking> _custOrderHistoryRecentBooking = [];
  List<OrderHistoryModel> _orderHistoryData = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get pendingBookingCount => _pendingBookingCount;
  String? get inTransitBookingCount => _inTransitBookingCount;
  String? get completedBookingCount => _completedBookingCount;
  String? get cancelledBookingCount => _cancelledBookingCount;
  String? get pendingPaymentAmt => _pendingPaymentAmt;
  String? get completedPaymentAmt => _completedPaymentAmt;
  List<CustOrderHistoryRecentBooking> get custOrderHistoryRecentBooking =>
      _custOrderHistoryRecentBooking;

  List<OrderHistoryModel> get orderHistoryData => _orderHistoryData;
  List<TravelAgency?> get allTravelAgencies =>
      _orderHistoryData.map((e) => e.travelAgency).toList();
  List<Customer?> get allCustomers =>
      _orderHistoryData.map((e) => e.customer).toList();
  List<Payment?> get allPayments =>
      _orderHistoryData.map((e) => e.payment).toList();

  CustOrderHistoryController() {
    initalizeData();
  }

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> initalizeData() async {
    await apiGetStatCount();
    await apiGetRecentBookings();
    await apiGetAllOrderHistoryTableData();
    // await apiGetPendingOrderHistoryTableData();
  }

  Future<void> apiGetStatCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getOrderHistoryStatCounts;
      final userId = await _getUserId();
      final userType = AppData.customerUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api called made for(get stat count) $fullUrl and body: $encodeBody');
      final response = await http.post(Uri.parse(fullUrl),
          headers: {'Content-Type': 'application/json'}, body: encodeBody);
      if (response.statusCode == 200) {
        Logger.success('Response from order get count api: ${response.body}');
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final dataCount = data['data'];
          _pendingBookingCount = dataCount['pending_booking_count']?.toString();
          _inTransitBookingCount =
              dataCount['in_transit_booking_count']?.toString();
          _completedBookingCount =
              dataCount['completed_booking_count']?.toString();
          _cancelledBookingCount =
              dataCount['canceled_booking_count']?.toString();
          _pendingPaymentAmt = dataCount['pending_payment_amt']?.toString();
          _completedPaymentAmt = dataCount['completed_payment_amt']?.toString();
        }
      } else {
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

  Future<void> apiGetRecentBookings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getRecentBookings;

      final userId = await _getUserId();
      final userTypeId = AppData.customerUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userTypeId
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(get recent booking) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.info('response from the recent booking api ${response.body}');
      if (response.statusCode == 200) {
        _custOrderHistoryRecentBooking.clear();
        final jsonData = jsonDecode(response.body);
        if (jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _custOrderHistoryRecentBooking = bookings
              .map((item) => CustOrderHistoryRecentBooking.fromJson(item))
              .toList();
          Logger.info(
              'successfully fetched ${_custOrderHistoryRecentBooking.length}');
        } else {
          _custOrderHistoryRecentBooking = [];
          Logger.info(
              'recent booking customer returned empty. ${response.body}');
        }
      } else {
        _error = 'Error in the HTTP method. ${response.statusCode}';
        Logger.error(
            'Error in the api call. ${response.statusCode} and ${response.body}');
      }
    } catch (e, s) {
      _error = 'Error fetching recent bookings: Error:$e';
      Logger.error('Error fetching recent bookings: Error: $e, Stacktrace:$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetAllOrderHistoryTableData() async {
    try {
      // _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getAllTableData;
      final userId = await _getUserId();
      final userType = AppData.customerUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(get all table data) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for all data table ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();

          Logger.success('api fetched total ${_orderHistoryData.length} data');
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
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetPendingOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      // _isLoading = true;
      _error = null;
      notifyListeners();

      final url = AppUrls.getPendingTableData;
      final userId = await _getUserId();
      final userType = AppData.customerUserType;
      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': '',
        'endDate': ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info('api call made for(pending table data) $url, Body: $body');

      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('respose for pending table data: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['bookings'] != null) {
          final List bookings = jsonData['bookings'];
          _orderHistoryData =
              bookings.map((item) => OrderHistoryModel.fromJson(item)).toList();
        } else {
          Logger.warning('pending table data is empty');
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
          'Error fetching pending table data. Error: $e, Stacktrace: $s');
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetBookedOrderHistoryTableData(
      {String? startDate, String? endDate}) async {
    try {
      _error = null;
      notifyListeners();

      final url = AppUrls.getBookedTableData;
      final userId = await _getUserId();
      final userType = AppData.customerUserType;

      final Map<String, dynamic> body = {
        'userId': userId,
        'userType': userType,
        'startDate': '',
        'endDate': ''
      };
      final encodeBody = jsonEncode(body);
      Logger.info(
          'api call made for(booked table data) $url, Body: $encodeBody');
      final response = await http.post(Uri.parse(url), body: encodeBody);
      Logger.success('response for booked table data ${response.body}');
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

  // Future<void> apiGetCancelledOrderHistoryTableData({
  //   String? startDate, String? endDate
  // }) async{
  //   try{

  //   }
  // }
}
