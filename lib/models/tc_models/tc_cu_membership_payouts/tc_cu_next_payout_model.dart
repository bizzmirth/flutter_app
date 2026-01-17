import 'dart:convert';

import 'package:bizzmirth_app/models/tc_models/tc_cu_membership_payouts/payout_data.dart';

class TcCuNextPayoutModel {
  final bool success;
  final double totalNextPayout;
  final String nextDateMonth;
  final String nextDateYear;
  final int totalRecords;
  final List<PayoutData> data;

  TcCuNextPayoutModel({
    required this.success,
    required this.totalNextPayout,
    required this.nextDateMonth,
    required this.nextDateYear,
    required this.totalRecords,
    required this.data,
  });

  factory TcCuNextPayoutModel.fromJson(Map<String, dynamic> json) {
    return TcCuNextPayoutModel(
      success: json['success'] == true,
      totalNextPayout: _toDouble(json['totalnextPayout']),
      nextDateMonth: json['nextDateMonth']?.toString() ?? '',
      nextDateYear: json['nextDateYear']?.toString() ?? '',
      totalRecords: _toInt(json['total_records']),
      data: (json['data'] is List)
          ? (json['data'] as List).map((e) => PayoutData.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalnextPayout': totalNextPayout,
      'nextDateMonth': nextDateMonth,
      'nextDateYear': nextDateYear,
      'total_records': totalRecords,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  static TcCuNextPayoutModel fromRawJson(String str) =>
      TcCuNextPayoutModel.fromJson(jsonDecode(str));

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
