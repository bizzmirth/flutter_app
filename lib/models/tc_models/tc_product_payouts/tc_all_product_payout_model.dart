class TcAllProductPayoutModel {
  String? date;
  String? message;
  String? markup;
  String? amount;
  int? tds;
  int? totalPayable;
  String? status;

  TcAllProductPayoutModel(
      {this.date,
      this.message,
      this.markup,
      this.amount,
      this.tds,
      this.totalPayable,
      this.status});

  TcAllProductPayoutModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    message = json['message'];
    markup = json['markup'];
    amount = json['amount'];
    tds = json['tds'];
    totalPayable = json['total_payable'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['message'] = message;
    data['markup'] = markup;
    data['amount'] = amount;
    data['tds'] = tds;
    data['total_payable'] = totalPayable;
    data['status'] = status;
    return data;
  }
}
