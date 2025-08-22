class PackageDetails {
  final String id;
  final String packageType;
  final String name;
  final String uniqueCode;
  final String packageKeywords;
  final String description;
  final String sightseeingType;
  final String status;
  final String validity;
  final String tourDays;

  PackageDetails({
    required this.id,
    required this.packageType,
    required this.name,
    required this.uniqueCode,
    required this.packageKeywords,
    required this.description,
    required this.sightseeingType,
    required this.status,
    required this.validity,
    required this.tourDays,
  });

  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      id: json['id']?.toString() ?? '',
      packageType: json['package_type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      uniqueCode: json['unique_code']?.toString() ?? '',
      packageKeywords: json['package_keywords']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sightseeingType: json['sightseeing_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      validity: json['validity']?.toString() ?? '',
      tourDays: json['tour_days']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package_type': packageType,
      'name': name,
      'unique_code': uniqueCode,
      'package_keywords': packageKeywords,
      'description': description,
      'sightseeing_type': sightseeingType,
      'status': status,
      'validity': validity,
      'tour_days': tourDays,
    };
  }

  // Helper methods
  int get tourDaysInt => int.tryParse(tourDays) ?? 0;
  bool get isActive => status == '1';
  List<String> get keywordsList =>
      packageKeywords.split(',').map((e) => e.trim()).toList();

  DateTime? get validityDate {
    try {
      return DateTime.parse(validity);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'PackageDetails(id: $id, name: $name, tourDays: $tourDays)';
  }
}
