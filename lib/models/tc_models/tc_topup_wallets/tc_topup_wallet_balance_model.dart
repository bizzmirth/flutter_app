class TcTopupWalletBalanceModel {
  String? userId;
  int? availableBalance;
  String? formattedBalance;

  TcTopupWalletBalanceModel(
      {this.userId, this.availableBalance, this.formattedBalance});

  TcTopupWalletBalanceModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    availableBalance = json['available_balance'];
    formattedBalance = json['formatted_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['available_balance'] = availableBalance;
    data['formatted_balance'] = formattedBalance;
    return data;
  }
}
