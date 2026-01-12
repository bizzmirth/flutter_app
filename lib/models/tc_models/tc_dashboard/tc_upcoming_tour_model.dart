class UpcomingTours {
  String? total;
  String? thisMonth;

  UpcomingTours({this.total, this.thisMonth});

  UpcomingTours.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    thisMonth = json['this_month'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['this_month'] = thisMonth;
    return data;
  }
}
