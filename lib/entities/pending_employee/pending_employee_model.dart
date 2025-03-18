import 'package:isar/isar.dart';

part 'pending_employee_model.g.dart';

@collection
class PendingEmployeeModel {
  Id? id = Isar.autoIncrement;
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

  String? profilePicture; // this will be image path
  String? idProof; // this will be image path
  String? bankDetails; // this will be image path
}
