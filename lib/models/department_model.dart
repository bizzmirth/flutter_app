class Department {
  final String id;
  final String deptName;
  final String createdDate;
  final String status;

  Department({
    required this.id,
    required this.deptName,
    required this.createdDate,
    required this.status,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? '',
      deptName: json['dept_name'] ?? '',
      createdDate: json['created_date'] ?? '',
      status: json['status'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dept_name': deptName,
      'created_date': createdDate,
      'status': status,
    };
  }
}
