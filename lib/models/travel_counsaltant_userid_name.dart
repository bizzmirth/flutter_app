// models/travel_consultant_model.dart
class TravelConsultant {
  final String id;
  final String caTravelAgencyId;
  final String firstname;
  final String lastname;

  TravelConsultant({
    required this.id,
    required this.caTravelAgencyId,
    required this.firstname,
    required this.lastname,
  });

  factory TravelConsultant.fromJson(Map<String, dynamic> json) {
    return TravelConsultant(
      id: json['id'] ?? '',
      caTravelAgencyId: json['ca_travelagency_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  String get displayName => '$caTravelAgencyId ($firstname $lastname)';
}
