class Member {
  String? id;
  String? bookingsId;
  String? name;
  String? age;
  String? gender;

  Member({this.id, this.bookingsId, this.name, this.age, this.gender});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingsId = json['bookings_id'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookings_id'] = bookingsId;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    return data;
  }
}
