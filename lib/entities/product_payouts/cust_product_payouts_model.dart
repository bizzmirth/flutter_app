import 'package:isar_community/isar.dart';

@collection
class CustProductPayoutsModel {
  final String date;
  final String payoutDetails;
  final double amount;
  final double tds;
  final double totalPayable;
  final String remark;

  CustProductPayoutsModel({
    required this.date,
    required this.payoutDetails,
    required this.amount,
    required this.tds,
    required this.totalPayable,
    required this.remark,
  });
}
