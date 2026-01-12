
class FranchiseeCandidateCount {
  String? type;
  int? pending;
  int? registered;
  int? deleted;

  FranchiseeCandidateCount({this.type, this.pending, this.registered, this.deleted});

  FranchiseeCandidateCount.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    pending = json['pending'];
    registered = json['registered'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['pending'] = pending;
    data['registered'] = registered;
    data['deleted'] = deleted;
    return data;
  }
}
