import 'package:isar/isar.dart';

part 'registered_employee_model.g.dart';

@collection
class RegisteredEmployeeModel {
  Id? id = Isar.autoIncrement;
  String? regId;
  String? name;
  String? mobileNumber;
  String? email;
  String? address;
  String? gender;
  String? dateOfBirth;
  String? dateOfJoining;
  int? status;
  String? department;
  String? designation;
  String? zone;
  String? branch;
  String? reportingManager;

  String? profilePicture;
  String? idProof;
  String? bankDetails;
}
