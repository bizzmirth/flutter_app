import 'package:isar_community/isar.dart';

part 'pending_employee_model.g.dart';

@collection
class PendingEmployeeModel {
    Id isarId = Isar.autoIncrement; // ✅ REQUIRED

  String? id; // backend ID (string, web-safe)
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
  String? reportingManagerName;

  String? profilePicture; // this will be image path
  String? idProof; // this will be image path
  String? bankDetails; // this will be image path
}
