class CustRedeemableWalletHistory {
  String? message;
  String? amount;
  String? date;
  String? status;

  CustRedeemableWalletHistory(
      {this.message, this.amount, this.date, this.status});

  CustRedeemableWalletHistory.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    amount = json['amount'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['amount'] = amount;
    data['date'] = date;
    data['status'] = status;
    return data;
  }
}
