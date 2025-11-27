import 'package:bizzmirth_app/models/order_history/booking.dart';
import 'package:bizzmirth_app/models/order_history/member.dart';
import 'package:bizzmirth_app/models/order_history/package.dart';

class OrderHistoryDetails {
  String? status;
  Booking? booking;
  String? customerId;
  String? customerName;
  List<Member>? members;
  Package? package;
  String? packagePicture;
  String? totalPrice;
  String? couponCode;
  String? couponAmount;
  String? discountedPrice;

  OrderHistoryDetails(
      {this.status,
      this.booking,
      this.customerId,
      this.customerName,
      this.members,
      this.package,
      this.packagePicture,
      this.totalPrice,
      this.couponCode,
      this.couponAmount,
      this.discountedPrice});

  OrderHistoryDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    customerId = json['customer_id'];
    customerName = json['customer_name'];

    if (json['members'] != null) {
      members = <Member>[];
      json['members'].forEach((v) {
        members!.add(Member.fromJson(v));
      });
    }
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
    packagePicture = json['package_picture'];
    totalPrice = json['total_price'];
    couponCode = json['coupon_code'];
    couponAmount = json['coupon_amount'];
    discountedPrice = json['discounted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;

    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;

    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }

    if (package != null) {
      data['package'] = package!.toJson();
    }
    data['package_picture'] = packagePicture;
    data['total_price'] = totalPrice;
    data['coupon_code'] = couponCode;
    data['coupon_amount'] = couponAmount;
    data['discounted_price'] = discountedPrice;
    return data;
  }
}
