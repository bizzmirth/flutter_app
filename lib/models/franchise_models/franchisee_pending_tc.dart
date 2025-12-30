
class FranchiseePendingTc {
  String? id;
  String? name;
  String? refId;
  String? refName;
  String? phone;
  String? joiningDate;
  String? status;
  String? statusBadge;

  FranchiseePendingTc({this.id, this.name, this.refId, this.refName, this.phone, this.joiningDate, this.status, this.statusBadge});

  FranchiseePendingTc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    refId = json['ref_id'];
    refName = json['ref_name'];
    phone = json['phone'];
    joiningDate = json['joining_date'];
    status = json['status'];
    statusBadge = json['status_badge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ref_id'] = refId;
    data['ref_name'] = refName;
    data['phone'] = phone;
    data['joining_date'] = joiningDate;
    data['status'] = status;
    data['status_badge'] = statusBadge;
    return data;
  }
}
