class Payment {
  int? percentFill;
  String? paidAmount;
  String? fullAmount;

  Payment({this.percentFill, this.paidAmount, this.fullAmount});

  Payment.fromJson(Map<String, dynamic> json) {
    percentFill = json['percent_fill'];
    paidAmount = json['paid_amount'];
    fullAmount = json['full_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percent_fill'] = percentFill;
    data['paid_amount'] = paidAmount;
    data['full_amount'] = fullAmount;
    return data;
  }
}
