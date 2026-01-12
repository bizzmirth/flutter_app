class RegisteredCustomers {
  String? total;
  String? thisMonth;

  RegisteredCustomers({this.total, this.thisMonth});

  RegisteredCustomers.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    thisMonth = json['this_month'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['this_month'] = thisMonth;
    return data;
  }
}
