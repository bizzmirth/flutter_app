
class FranchiseeRegisteredTc {
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

  FranchiseeRegisteredTc({this.tcId, this.tcName, this.refId, this.refName, this.phone, this.joiningDate, this.status, this.statusBadge, this.hasActions, this.canEdit, this.canDelete, this.tcIdForAction, this.referenceNoForAction, this.country, this.state, this.city, this.tableName, this.listType});

  FranchiseeRegisteredTc.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
