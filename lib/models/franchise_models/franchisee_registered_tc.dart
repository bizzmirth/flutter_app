class FranchiseeRegisteredTc {
  /// ---------- EXISTING FIELDS (UNCHANGED) ----------
  String? tcId;
  String? tcName;
  String? refId;
  String? refName;
  String? phone;
  String? joiningDate;
  String? status;
  String? statusBadge;
  bool? hasActions;
  bool? canEdit;
  bool? canDelete;
  String? tcIdForAction;
  String? referenceNoForAction;
  String? country;
  String? state;
  String? city;
  String? tableName;
  String? listType;

  /// ---------- NEW FIELDS (ADDED) ----------
  String? firstname;
  String? lastname;
  String? nomineeName;
  String? nomineeRelation;
  String? email;
  String? gender;
  String? countryCode; // backend key is `county_code`
  String? dob;
  String? profilePic;
  String? panCard;
  String? aadharCard;
  String? votingCard;
  String? passbook;
  String? paymentProof;
  String? paymentMode;
  String? chequeNo;
  String? chequeDate;
  String? bankName;
  String? transactionNo;
  String? address;
  String? pincode;
  String? editFor;
  String? registerBy;
  String? userType;
  String? userId;
  String? userIdName;
  String? id; // local use only, not in toJson/fromJson

  FranchiseeRegisteredTc({
    this.tcId,
    this.tcName,
    this.refId,
    this.refName,
    this.phone,
    this.joiningDate,
    this.status,
    this.statusBadge,
    this.hasActions,
    this.canEdit,
    this.canDelete,
    this.tcIdForAction,
    this.referenceNoForAction,
    this.country,
    this.state,
    this.city,
    this.tableName,
    this.listType,
    this.firstname,
    this.lastname,
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
    this.paymentMode,
    this.chequeNo,
    this.chequeDate,
    this.bankName,
    this.transactionNo,
    this.address,
    this.pincode,
    this.editFor,
    this.registerBy,
    this.userType,
    this.userIdName,
    this.id,
  });

  FranchiseeRegisteredTc.fromJson(Map<String, dynamic> json) {
    /// existing
    tcId = json['tc_id'];
    tcName = json['tc_name'];
    refId = json['ref_id'];
    refName = json['ref_name'];
    phone = json['phone'];
    joiningDate = json['joining_date'];
    status = json['status'];
    statusBadge = json['status_badge'];
    hasActions = json['has_actions'];
    canEdit = json['can_edit'];
    canDelete = json['can_delete'];
    tcIdForAction = json['tc_id_for_action'];
    referenceNoForAction = json['reference_no_for_action'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    tableName = json['table_name'];
    listType = json['list_type'];

    /// new
    firstname = json['firstname'];
    lastname = json['lastname'];
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
    paymentMode = json['paymentMode'];
    chequeNo = json['cheque_no'];
    chequeDate = json['cheque_date'];
    bankName = json['bank_name'];
    transactionNo = json['transaction_no'];
    address = json['address'];
    pincode = json['pincode'];
    editFor = json['editfor'];
    registerBy = json['register_by'];
    userType = json['userType'];
    userIdName = json['user_id_name'];
    id = json['id'];
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    /// existing
    data['tc_id'] = tcId;
    data['tc_name'] = tcName;
    data['ref_id'] = refId;
    data['ref_name'] = refName;
    data['phone'] = phone;
    data['joining_date'] = joiningDate;
    data['status'] = status;
    data['status_badge'] = statusBadge;
    data['has_actions'] = hasActions;
    data['can_edit'] = canEdit;
    data['can_delete'] = canDelete;
    data['tc_id_for_action'] = tcIdForAction;
    data['reference_no_for_action'] = referenceNoForAction;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['table_name'] = tableName;
    data['list_type'] = listType;

    /// new
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['email'] = email;
    data['gender'] = gender;
    data['country_code'] = countryCode;
    data['dob'] = dob;
    data['profile_pic'] = profilePic;
    data['pan_card'] = panCard;
    data['aadhar_card'] = aadharCard;
    data['voting_card'] = votingCard;
    data['passbook'] = passbook;
    data['payment_proof'] = paymentProof;
    data['paymentMode'] = paymentMode;
    data['cheque_no'] = chequeNo;
    data['cheque_date'] = chequeDate;
    data['bank_name'] = bankName;
    data['transaction_no'] = transactionNo;
    data['address'] = address;
    data['pincode'] = pincode;
    data['editfor'] = editFor;
    data['register_by'] = registerBy;
    data['userType'] = userType;
    data['user_id_name'] = userIdName;
    data['id'] = id;

    return data;
  }
}
