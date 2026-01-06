class ProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String address;

  final String country;
  final String state;
  final String city;
  final String zipCode;

  final String profilePic;
  final String bankPassbook;
  final String panCard;
  final String aadharCard;
  final String votingCard;
  final String idProof;

  final String compCheck;
  final String customerType;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.zipCode,
    required this.profilePic,
    required this.bankPassbook,
    required this.panCard,
    required this.aadharCard,
    required this.votingCard,
    required this.idProof,
    required this.compCheck,
    required this.customerType,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
    String? Function(String?) formatUrl,
  ) {
    return ProfileModel(
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_no'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['pincode'] ?? '',
      profilePic: formatUrl(json['profile_pic']) ?? '',
      bankPassbook: formatUrl(json['bank_passbook']) ?? '',
      panCard: formatUrl(json['pan_card']) ?? '',
      aadharCard: formatUrl(json['aadhar_card']) ?? '',
      votingCard: formatUrl(json['voting_card']) ?? '',
      idProof: formatUrl(json['id_proof']) ?? '',
      compCheck: json['comp_chek'] ?? '',
      customerType: json['customer_type'] ?? '',
    );
  }
}
