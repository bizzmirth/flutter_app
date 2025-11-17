import 'package:bizzmirth_app/models/order_history/order_history_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_order_history/tc_order_history_recent_booking.dart';
import 'package:flutter/material.dart';

class TcOrderHistoryController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<OrderHistoryModel> _orderHistoryData = [];
  List<TcOrderHistoryRecentBooking> _tcOrderHistoryRecentBookings = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<OrderHistoryModel> get orderHistoryData => _orderHistoryData;
  List<TcOrderHistoryRecentBooking> get tcOrderHistoryRecentBookings =>
      _tcOrderHistoryRecentBookings;
}
