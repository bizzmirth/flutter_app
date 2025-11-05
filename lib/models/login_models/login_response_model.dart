import 'dart:convert';

class LoginResponseModel {
  final int? status;
  final String? message;
  final String? userType;
  final String? userId;
  final String? userFname;
  final String? userLname;
  final String? name; // ✅ Combined full name
  final String? email;
  final String? token;
  final Map<String, dynamic>? extra; // store any extra unknown keys

  LoginResponseModel({
    this.status,
    this.message,
    this.userType,
    this.userId,
    this.userFname,
    this.userLname,
    this.name, // ✅
    this.email,
    this.token,
    this.extra,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackEmail,
  }) {
    final extraData = Map<String, dynamic>.from(json);
    extraData.removeWhere((key, _) => [
          'status',
          'message',
          'user_type',
          'user_id',
          'user_fname',
          'user_lname',
          'email',
          'token'
        ].contains(key));

    final fname = json['user_fname']?.toString().trim() ?? '';
    final lname = json['user_lname']?.toString().trim() ?? '';
    final fullName = [fname, lname].where((e) => e.isNotEmpty).join(' ');

    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      userType: json['user_type'],
      userId: json['user_id'],
      userFname: fname,
      userLname: lname,
      name: fullName, // ✅ combined name
      email: json['email'] ?? fallbackEmail,
      token: json['token'],
      extra: extraData.isNotEmpty ? extraData : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'user_type': userType,
        'user_id': userId,
        'user_fname': userFname,
        'user_lname': userLname,
        'name': name, // ✅ added
        'email': email,
        'token': token,
        if (extra != null) ...extra!,
      };

  @override
  String toString() => jsonEncode(toJson());
}
