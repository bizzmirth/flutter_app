import 'package:bizzmirth_app/models/order_history/customer.dart';
import 'package:bizzmirth_app/models/order_history/payment.dart';
import 'package:bizzmirth_app/models/order_history/travel_agency.dart';

class OrderHistoryModel {
  String? id;
  String? orderId;
  String? date;
  String? packageName;
  Customer? customer;
  TravelAgency? travelAgency;
  Payment? payment;
  String? status;

  OrderHistoryModel({
    this.id,
    this.orderId,
    this.date,
    this.packageName,
    this.customer,
    this.travelAgency,
    this.payment,
    this.status,
  });

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    date = json['date'];
    packageName = json['package_name'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    travelAgency = json['travel_agency'] != null
        ? TravelAgency.fromJson(json['travel_agency'])
        : null;
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['date'] = date;
    data['package_name'] = packageName;

    if (customer != null) {
      data['customer'] = customer!.toJson();
    }

    if (travelAgency != null) {
      data['travel_agency'] = travelAgency!.toJson();
    }

    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    data['status'] = status;
    return data;
  }
}
