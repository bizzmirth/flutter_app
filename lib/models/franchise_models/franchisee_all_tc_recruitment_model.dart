
class FranchiseeAllTcRecruitmentModel {
  String? date;
  String? payoutDetails;
  int? amount;
  int? tds;
  int? totalPayable;
  String? status;
  String? id;

  FranchiseeAllTcRecruitmentModel({this.date, this.payoutDetails, this.amount, this.tds, this.totalPayable, this.status, this.id});

  FranchiseeAllTcRecruitmentModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    payoutDetails = json['payout_details'];
    amount = json['amount'];
    tds = json['tds'];
    totalPayable = json['total_payable'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['payout_details'] = payoutDetails;
    data['amount'] = amount;
    data['tds'] = tds;
    data['total_payable'] = totalPayable;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
