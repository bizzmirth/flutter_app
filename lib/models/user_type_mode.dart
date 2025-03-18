class UserTypeResponse {
  bool status;
  String result;
  List<UserType> data;

  UserTypeResponse({
    required this.status,
    required this.result,
    required this.data,
  });

  factory UserTypeResponse.fromJson(Map<String, dynamic> json) {
    return UserTypeResponse(
      status: json['status'] == 'true',
      result: json['result'],
      data: List<UserType>.from(json['data'].map((x) => UserType.fromJson(x))),
    );
  }
}

class UserType {
  String id;
  String name;
  String status;
  String refName;

  UserType({
    required this.id,
    required this.name,
    required this.status,
    required this.refName,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      refName: json['ref name'],
    );
  }
}