class FranchiseePendingTc {
  /// ---------- EXISTING FIELDS (UNCHANGED) ----------
  String? id;
  String? name;
  String? refId;
  String? refName;
  String? phone;
  String? joiningDate;
  String? status;
  String? statusBadge;

  /// ---------- NEW FIELDS (ADDED) ----------
  String? userId;
  String? userType;
  String? userIdName;
  String? referenceName;

  String? firstName;
  String? lastName;

  String? nomineeName;
  String? nomineeRelation;

  String? email;
  String? gender;
  String? countryCode;
  String? dob;

  String? profilePic;
  String? panCard;
  String? aadharCard;
  String? votingCard;
  String? passbook;

  String? paymentProof;
  String? paymentFee;
  String? paymentMode;
  String? chequeNo;
  String? chequeDate;
  String? bankName;
  String? transactionNo;

  String? address;
  String? pincode;
  String? country;
  String? state;
  String? city;

  FranchiseePendingTc({
    this.id,
    this.name,
    this.refId,
    this.refName,
    this.phone,
    this.joiningDate,
    this.status,
    this.statusBadge,

    this.userId,
    this.userType,
    this.userIdName,
    this.referenceName,
    this.firstName,
    this.lastName,
    this.nomineeName,
    this.nomineeRelation,
    this.email,
    this.gender,
    this.countryCode,
    this.dob,
    this.profilePic,
    this.panCard,
    this.aadharCard,
    this.votingCard,
    this.passbook,
    this.paymentProof,
    this.paymentFee,
    this.paymentMode,
    this.chequeNo,
    this.chequeDate,
    this.bankName,
    this.transactionNo,
    this.address,
    this.pincode,
    this.country,
    this.state,
    this.city,
  });

  FranchiseePendingTc.fromJson(Map<String, dynamic> json) {
    /// existing
    id = json['id'];
    name = json['name'];
    refId = json['ref_id'];
    refName = json['ref_name'];
    phone = json['phone'];
    joiningDate = json['joining_date'];
    status = json['status'];
    statusBadge = json['status_badge'];

    /// new
    userId = json['userId'];
    userType = json['userType'];
    userIdName = json['user_id_name'];
    referenceName = json['reference_name'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    email = json['email'];
    gender = json['gender'];
    countryCode = json['country_code'];
    dob = json['dob'];
    profilePic = json['profile_pic'];
    panCard = json['pan_card'];
    aadharCard = json['aadhar_card'];
    votingCard = json['voting_card'];
    passbook = json['passbook'];
    paymentProof = json['payment_proof'];
    paymentFee = json['payment_fee'];
    paymentMode = json['paymentMode'];
    chequeNo = json['chequeNo'];
    chequeDate = json['chequeDate'];
    bankName = json['bankName'];
    transactionNo = json['transactionNo'];
    address = json['address'];
    pincode = json['pincode'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    /// existing
    data['id'] = id;
    data['name'] = name;
    data['ref_id'] = refId;
    data['ref_name'] = refName;
    data['phone'] = phone;
    data['joining_date'] = joiningDate;
    data['status'] = status;
    data['status_badge'] = statusBadge;

    /// new (exact backend keys)
    data['userId'] = userId;
    data['userType'] = userType;
    data['user_id_name'] = userIdName;
    data['reference_name'] = referenceName;
    data['firstname'] = firstName;
    data['lastname'] = lastName;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['email'] = email;
    data['gender'] = gender;
    data['country_code'] = countryCode;
    data['phone'] = phone; // reused
    data['dob'] = dob;
    data['profile_pic'] = profilePic;
    data['pan_card'] = panCard;
    data['aadhar_card'] = aadharCard;
    data['voting_card'] = votingCard;
    data['passbook'] = passbook;
    data['payment_proof'] = paymentProof;
    data['payment_fee'] = paymentFee;
    data['paymentMode'] = paymentMode;
    data['chequeNo'] = chequeNo;
    data['chequeDate'] = chequeDate;
    data['bankName'] = bankName;
    data['transactionNo'] = transactionNo;
    data['address'] = address;
    data['pincode'] = pincode;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;

    return data;
  }
}
