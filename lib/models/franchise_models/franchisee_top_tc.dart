
class FranchiseeTopTc {
  String? id;
  String? name;
  String? registerDate;
  int? totalReferrals;
  int? activeCount;
  int? inactiveCount;

  FranchiseeTopTc({this.id, this.name, this.registerDate, this.totalReferrals, this.activeCount, this.inactiveCount});

  FranchiseeTopTc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registerDate = json['registerDate'];
    totalReferrals = json['totalReferrals'];
    activeCount = json['activeCount'];
    inactiveCount = json['inactiveCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['registerDate'] = registerDate;
    data['totalReferrals'] = totalReferrals;
    data['activeCount'] = activeCount;
    data['inactiveCount'] = inactiveCount;
    return data;
  }
}
