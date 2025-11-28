class TcCuAllPayoutModel {
  String? id;
  String? date;
  String? payoutDetails;
  String? amount;
  String? tds;
  String? totalPayable;
  String? remark;

  TcCuAllPayoutModel(
      {this.id,
      this.date,
      this.payoutDetails,
      this.amount,
      this.tds,
      this.totalPayable,
      this.remark});

  TcCuAllPayoutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    payoutDetails = json['payout_details'];
    amount = json['amount'];
    tds = json['tds'];
    totalPayable = json['total_payable'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['payout_details'] = payoutDetails;
    data['amount'] = amount;
    data['tds'] = tds;
    data['total_payable'] = totalPayable;
    data['remark'] = remark;
    return data;
  }
}
