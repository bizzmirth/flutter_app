class TcTopupRequestList {
  int? srNo;
  String? topUpAmount;
  String? createdDate;
  String? updatedDate;
  String? statusCode;
  String? statusLabel;

  TcTopupRequestList(
      {this.srNo,
      this.topUpAmount,
      this.createdDate,
      this.updatedDate,
      this.statusCode,
      this.statusLabel});

  TcTopupRequestList.fromJson(Map<String, dynamic> json) {
    srNo = json['sr_no'];
    topUpAmount = json['top_up_amount'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    statusCode = json['status_code'];
    statusLabel = json['status_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sr_no'] = srNo;
    data['top_up_amount'] = topUpAmount;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    data['status_code'] = statusCode;
    data['status_label'] = statusLabel;
    return data;
  }
}
