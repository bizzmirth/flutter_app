class Commission {
  String? confirmed;
  String? pending;

  Commission({this.confirmed, this.pending});

  Commission.fromJson(Map<String, dynamic> json) {
    confirmed = json['confirmed'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirmed'] = confirmed;
    data['pending'] = pending;
    return data;
  }
}
