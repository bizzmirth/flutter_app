class TcTopBookingsModel {
  String? orderId;
  String? name;
  String? packageName;
  String? amount;
  String? bookingDate;
  String? travelDate;

  TcTopBookingsModel({
    this.orderId,
    this.name,
    this.packageName,
    this.amount,
    this.bookingDate,
    this.travelDate,
  });

  TcTopBookingsModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    name = json['name'];
    packageName = json['package_name'];
    amount = json['amount'];
    bookingDate = json['booking_date'];
    travelDate = json['travel_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['name'] = name;
    data['package_name'] = packageName;
    data['amount'] = amount;
    data['booking_date'] = bookingDate;
    data['travel_date'] = travelDate;
    return data;
  }
}
