
class FranchiseeTotalCuPayout {
  String? id;
  String? date;
  String? message;
  String? amount;
  int? tds;
  int? totalPayable;
  String? status;
  String? statusCode;
  String? paydate;

  FranchiseeTotalCuPayout({this.id, this.date, this.message, this.amount, this.tds, this.totalPayable, this.status, this.statusCode, this.paydate});

  FranchiseeTotalCuPayout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    message = json['message'];
    amount = json['amount'];
    tds = json['tds'];
    totalPayable = json['totalPayable'];
    status = json['status'];
    statusCode = json['status_code'];
    paydate = json['paydate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['message'] = message;
    data['amount'] = amount;
    data['tds'] = tds;
    data['totalPayable'] = totalPayable;
    data['status'] = status;
    data['status_code'] = statusCode;
    data['paydate'] = paydate;
    return data;
  }
}
