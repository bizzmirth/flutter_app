import 'package:isar/isar.dart';

part 'pending_business_mentor_model.g.dart';

@collection
class PendingBusinessMentorModel {
  Id? id = Isar.autoIncrement;
  String? designation;
  String? userId;
  String? refName;
  String? name;
  String? nomineeName;
  String? nomineeRelation;
  String? countryCd;
  String? phoneNumber;
  String? email;
  String? gender;
  String? dob;
  int? status;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? address;
  String? zone;
  String? branch;
  String? paymentMode;

  String? profilePicture;
  String? adharCard;
  String? panCard;
  String? bankPassbook;
  String? votingCard;
  String? paymentProof;

  // New fields added from the API response
  int? businessMentorId;
  String? firstName;
  String? lastName;
  int? age;
  String? gstNo;
  String? kyc;
  String? chequeNo;
  String? chequeDate;
  String? bankName;
  String? transactionNo;
  String? registrant;
  String? referenceNo;
  int? registerBy;
  int? userType;
  String? addedOn;
  String? registerDate;
  String? deletedDate;
}
