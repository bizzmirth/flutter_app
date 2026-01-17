class FranchiseeRegisteredTc {
  String? id;
  String? caTravelagencyId;
  String? firstname;
  String? lastname;
  String? nomineeName;
  String? nomineeRelation;
  String? email;
  String? countryCode;
  String? contactNo;
  String? dateOfBirth;
  String? age;
  String? gender;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? address;
  String? note;
  String? profilePic;
  String? panCard;
  String? aadharCard;
  String? votingCard;
  String? passbook;
  String? paymentProof;
  String? amount;
  String? paymentMode;
  String? chequeNo;
  String? chequeDate;
  String? bankName;
  String? transactionNo;
  String? userType;
  String? compCheck;
  String? registrant;
  String? referenceNo;
  String? registerBy;
  String? addedOn;
  String? registerDate;
  dynamic deletedDate;
  String? status;
  String? editFor;

  FranchiseeRegisteredTc(
      {this.id,
      this.caTravelagencyId,
      this.firstname,
      this.lastname,
      this.nomineeName,
      this.nomineeRelation,
      this.email,
      this.countryCode,
      this.contactNo,
      this.dateOfBirth,
      this.age,
      this.gender,
      this.country,
      this.state,
      this.city,
      this.pincode,
      this.address,
      this.note,
      this.profilePic,
      this.panCard,
      this.aadharCard,
      this.votingCard,
      this.passbook,
      this.paymentProof,
      this.amount,
      this.paymentMode,
      this.chequeNo,
      this.chequeDate,
      this.bankName,
      this.transactionNo,
      this.userType,
      this.compCheck,
      this.registrant,
      this.referenceNo,
      this.registerBy,
      this.addedOn,
      this.registerDate,
      this.deletedDate,
      this.status,
      this.editFor,});

  FranchiseeRegisteredTc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caTravelagencyId = json['ca_travelagency_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    email = json['email'];
    countryCode = json['country_code'];
    contactNo = json['contact_no'];
    dateOfBirth = json['date_of_birth'];
    age = json['age'];
    gender = json['gender'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    address = json['address'];
    note = json['note'];
    profilePic = json['profile_pic'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    votingCard = json['voting_card'];
    passbook = json['passbook'];
    paymentProof = json['payment_proof'];
    amount = json['amount'];
    paymentMode = json['payment_mode'];
    chequeNo = json['cheque_no'];
    chequeDate = json['cheque_date'];
    bankName = json['bank_name'];
    transactionNo = json['transaction_no'];
    userType = json['user_type'];
    compCheck = json['comp_check'];
    registrant = json['registrant'];
    referenceNo = json['reference_no'];
    registerBy = json['register_by'];
    addedOn = json['added_on'];
    registerDate = json['register_date'];
    deletedDate = json['deleted_date'];
    status = json['status'];
    editFor = json['editfor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ca_travelagency_id'] = caTravelagencyId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['contact_no'] = contactNo;
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['gender'] = gender;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['pincode'] = pincode;
    data['address'] = address;
    data['note'] = note;
    data['profile_pic'] = profilePic;
    data['pan_card'] = panCard;
    data['aadhar_card'] = aadharCard;
    data['voting_card'] = votingCard;
    data['passbook'] = passbook;
    data['payment_proof'] = paymentProof;
    data['amount'] = amount;
    data['payment_mode'] = paymentMode;
    data['cheque_no'] = chequeNo;
    data['cheque_date'] = chequeDate;
    data['bank_name'] = bankName;
    data['transaction_no'] = transactionNo;
    data['user_type'] = userType;
    data['comp_check'] = compCheck;
    data['registrant'] = registrant;
    data['reference_no'] = referenceNo;
    data['register_by'] = registerBy;
    data['added_on'] = addedOn;
    data['register_date'] = registerDate;
    data['deleted_date'] = deletedDate;
    data['status'] = status;
    data['editfor'] = editFor;
    return data;
  }
}
