class TravelAgency {
  String? caTravelagencyId;
  String? firstname;
  String? lastname;
  String? email;
  String? contactNo;

  TravelAgency({
    this.caTravelagencyId,
    this.firstname,
    this.lastname,
    this.email,
    this.contactNo,
  });

  TravelAgency.fromJson(Map<String, dynamic> json) {
    caTravelagencyId = json['ca_travelagency_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    contactNo = json['contact_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ca_travelagency_id'] = caTravelagencyId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['contact_no'] = contactNo;
    return data;
  }
}
