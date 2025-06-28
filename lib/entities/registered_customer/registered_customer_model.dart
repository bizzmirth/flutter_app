import 'package:isar/isar.dart';

// part 'registered_customer_model.g.dart';

@collection
class RegisteredCustomer {
  Id id = Isar.autoIncrement;

  String? caCustomerId;
  String? name;
  String? firstname;
  String? lastname;
  String? nomineeName;
  String? nomineeRelation;
  String? email;
  String? countryCd;
  String? phoneNumber;
  String? dob;
  String? age;
  String? gender;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? address;
  String? note;
  String? paymentMode;
  String? profilePicture;
  String? adharCard;
  String? panCard;
  String? bankPassbook;
  String? votingCard;
  String? paymentProof;
  String? checqueNo;
  String? chequeDate;
  String? bankDate;
  String? transaction;
  String? userType;
  String? registrant;
  String? referenceNo;
  String? taReferenceNo;
  String? taReferenceName;
  String? registerBy;
  String? paidAmount;
  String? customerType;
  String? compChek;
  String? addedOn;
  String? registerDate;
  String? deletedDate;
  String? status;

  RegisteredCustomer();

  // ✅ fromJson
  factory RegisteredCustomer.fromJson(Map<String, dynamic> json) {
    return RegisteredCustomer()
      ..id = int.tryParse(json['id']?.toString() ?? '') ?? Isar.autoIncrement
      ..caCustomerId = json['ca_customer_id']
      ..firstname = json['firstname']
      ..lastname = json['lastname']
      ..name = "${json['firstname'] ?? ''} ${json['lastname'] ?? ''}".trim()
      ..nomineeName = json['nominee_name']
      ..nomineeRelation = json['nominee_relation']
      ..email = json['email']
      ..countryCd = json['country_code']
      ..phoneNumber = json['contact_no']
      ..dob = json['date_of_birth']
      ..age = json['age']
      ..gender = json['gender']
      ..country = json['country']
      ..state = json['state']
      ..city = json['city']
      ..pincode = json['pincode']
      ..address = json['address']
      ..note = json['note']
      ..paymentMode = json['payment_mode']
      ..profilePicture = json['profile_pic']
      ..adharCard = json['aadhar_card']
      ..panCard = json['pan_card']
      ..bankPassbook = json['passbook']
      ..votingCard = json['voting_card']
      ..paymentProof = json['payment_proof']
      ..checqueNo = json['cheque_no']
      ..chequeDate = json['cheque_date']
      ..bankDate = json['bank_name']
      ..transaction = json['transaction_no']
      ..userType = json['user_type']
      ..registrant = json['registrant']
      ..referenceNo = json['reference_no']
      ..taReferenceNo = json['ta_reference_no']
      ..taReferenceName = json['ta_reference_name']
      ..registerBy = json['register_by']
      ..paidAmount = json['paid_amount']
      ..customerType = json['customer_type']
      ..compChek = json['comp_chek']
      ..addedOn = json['added_on']
      ..registerDate = json['register_date']
      ..deletedDate = json['deleted_date']
      ..status = json['status'];
  }

  // ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'ca_customer_id': caCustomerId,
      'firstname': firstname,
      'lastname': lastname,
      'name': name,
      'nominee_name': nomineeName,
      'nominee_relation': nomineeRelation,
      'email': email,
      'country_code': countryCd,
      'contact_no': phoneNumber,
      'date_of_birth': dob,
      'age': age,
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'pincode': pincode,
      'address': address,
      'note': note,
      'payment_mode': paymentMode,
      'profile_pic': profilePicture,
      'aadhar_card': adharCard,
      'pan_card': panCard,
      'passbook': bankPassbook,
      'voting_card': votingCard,
      'payment_proof': paymentProof,
      'cheque_no': checqueNo,
      'cheque_date': chequeDate,
      'bank_name': bankDate,
      'transaction_no': transaction,
      'user_type': userType,
      'registrant': registrant,
      'reference_no': referenceNo,
      'ta_reference_no': taReferenceNo,
      'ta_reference_name': taReferenceName,
      'register_by': registerBy,
      'paid_amount': paidAmount,
      'customer_type': customerType,
      'comp_chek': compChek,
      'added_on': addedOn,
      'register_date': registerDate,
      'deleted_date': deletedDate,
      'status': status,
    };
  }
}
