class CompletedTours {
  String? total;
  String? thisMonth;

  CompletedTours({this.total, this.thisMonth});

  CompletedTours.fromJson(Map<String, dynamic> json) {
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
