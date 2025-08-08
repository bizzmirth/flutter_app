import 'package:flutter/material.dart';

class SummaryCardData {
  final String title;

  final String value;
  final String? thisMonthValue;
  final IconData icon;

  SummaryCardData(
      {required this.title,
      required this.value,
      this.thisMonthValue,
      required this.icon});
}
