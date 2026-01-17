import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/payout_data.dart';

class TcCuPreviousPayoutModel {
  final bool success;
  final double totalPreviousPayout;
  final String prevDateMonth;
  final String prevDateYear;
  final int totalRecords;
  final List<PayoutData> data;

  TcCuPreviousPayoutModel({
    required this.success,
    required this.totalPreviousPayout,
    required this.prevDateMonth,
    required this.prevDateYear,
    required this.totalRecords,
    required this.data,
  });

  factory TcCuPreviousPayoutModel.fromJson(Map<String, dynamic> json) {
    return TcCuPreviousPayoutModel(
      success: json['success'] == true,
      totalPreviousPayout: _toDouble(json['totalpreviousPayout']),
      prevDateMonth: json['prevDateMonth']?.toString() ?? '',
      prevDateYear: json['prevDateYear']?.toString() ?? '',
      totalRecords: _toInt(json['total_records']),
      data: (json['data'] is List)
          ? (json['data'] as List).map((e) => PayoutData.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalpreviousPayout': totalPreviousPayout,
      'prevDateMonth': prevDateMonth,
      'prevDateYear': prevDateYear,
      'total_records': totalRecords,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  static TcCuPreviousPayoutModel fromRawJson(String str) =>
      TcCuPreviousPayoutModel.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  // --- Utility safe type parsers ---
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    }
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value.replaceAll(RegExp(r'[^0-9\-]'), '')) ?? 0;
    }
    return 0;
  }
}
