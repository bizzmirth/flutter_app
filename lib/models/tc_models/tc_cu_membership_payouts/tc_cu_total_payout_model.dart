class TcCuTotalPayoutModel {
  String? date;
  String? message;
  int? commission;
  int? tds;
  int? totalPayable;
  String? remark;

  TcCuTotalPayoutModel(
      {this.date,
      this.message,
      this.commission,
      this.tds,
      this.totalPayable,
      this.remark});

  TcCuTotalPayoutModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    message = json['message'];
    commission = json['commission'];
    tds = json['tds'];
    totalPayable = json['total_payable'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['message'] = message;
    data['commission'] = commission;
    data['tds'] = tds;
    data['total_payable'] = totalPayable;
    data['remark'] = remark;
    return data;
  }
}
