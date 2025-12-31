import 'package:isar_community/isar.dart';

part 'pending_techno_enterprise_model.g.dart';

@collection
class PendingTechnoEnterpriseModel {
  Id? id = Isar.autoIncrement;
  String? userId;
  String? refName;
  String? name;
  String? nomineeName;
  String? nomineeRelation;
  String? businessPackage;
  String? amount;
  String? gstNo;
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
  String? packageFor;

  String? profilePicture;
  String? adharCard;
  String? panCard;
  String? bankPassbook;
  String? votingCard;
  String? paymentProof;
}
