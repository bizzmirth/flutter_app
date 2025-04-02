import 'dart:convert';

class Designation {
  final String id;
  final String desgName;
  final String deptId;
  final String deptName;
  final String createdDate;
  final String status;

  Designation({
    required this.id,
    required this.desgName,
    required this.deptId,
    required this.deptName,
    required this.createdDate,
    required this.status,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'] ?? '',
      desgName: json['designation_name'] ?? '',
      deptId: json['dept_id'],
      deptName: json['dept_name'],
      createdDate: json['created_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation_name': desgName,
      'dept_id': deptId,
      'dept_name': deptName,
      'created_date': createdDate,
      'status': status,
    };
  }
}
