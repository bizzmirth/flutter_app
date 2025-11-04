class TcProductPayoutModel {
  String? date;
  String? packageName;
  String? customerName;
  String? noOfAdults;
  String? noOfChildren;
  String? message;
  String? amount;
  int? tds;
  int? totalPayable;
  String? status;
  String? markup;

  TcProductPayoutModel({
    this.date,
    this.packageName,
    this.customerName,
    this.noOfAdults,
    this.noOfChildren,
    this.message,
    this.amount,
    this.tds,
    this.totalPayable,
    this.status,
    this.markup,
  });

  TcProductPayoutModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    packageName = json['packageName'];
    customerName = json['customerName'];
    noOfAdults = json['noOfAdults'];
    noOfChildren = json['noOfChildren'];
    message = json['message'];
    amount = json['amount'].toString();
    tds = json['tds'];
    totalPayable = json['totalPayable'];
    status = json['status'];
    markup = json['markup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['packageName'] = packageName;
    data['customerName'] = customerName;
    data['noOfAdults'] = noOfAdults;
    data['noOfChildren'] = noOfChildren;
    data['message'] = message;
    data['amount'] = amount;
    data['tds'] = tds;
    data['totalPayable'] = totalPayable;
    data['status'] = status;
    data['markup'] = markup;
    return data;
  }
}
