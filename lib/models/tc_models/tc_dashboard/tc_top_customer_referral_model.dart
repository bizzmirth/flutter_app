class TcTopCustomerReferralModel {
  String? id;
  String? name;
  String? registerDate;
  String? totalReferrals;
  String? activeCount;
  String? inactiveCount;

  TcTopCustomerReferralModel(
      {this.id,
      this.name,
      this.registerDate,
      this.totalReferrals,
      this.activeCount,
      this.inactiveCount});

  TcTopCustomerReferralModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registerDate = json['register_date'];
    totalReferrals = json['total_referrals'];
    activeCount = json['active_count'];
    inactiveCount = json['inactive_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['register_date'] = registerDate;
    data['total_referrals'] = totalReferrals;
    data['active_count'] = activeCount;
    data['inactive_count'] = inactiveCount;
    return data;
  }
}
