class CustOrderHistoryRecentBooking {
  String? id;
  String? orderId;
  String? packageId;
  String? date;
  String? customerId;
  String? name;
  String? status;
  String? taId;
  String? packageName;
  String? customerProfilePic;
  String? packageImage;

  CustOrderHistoryRecentBooking(
      {this.id,
      this.orderId,
      this.packageId,
      this.date,
      this.customerId,
      this.name,
      this.status,
      this.taId,
      this.packageName,
      this.customerProfilePic,
      this.packageImage});

  CustOrderHistoryRecentBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    packageId = json['package_id'];
    date = json['date'];
    customerId = json['customer_id'];
    name = json['name'];
    status = json['status'];
    taId = json['ta_id'];
    packageName = json['package_name'];
    customerProfilePic = json['customer_profile_pic'];
    packageImage = json['package_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['package_id'] = packageId;
    data['date'] = date;
    data['customer_id'] = customerId;
    data['name'] = name;
    data['status'] = status;
    data['ta_id'] = taId;
    data['package_name'] = packageName;
    data['customer_profile_pic'] = customerProfilePic;
    data['package_image'] = packageImage;
    return data;
  }
}
