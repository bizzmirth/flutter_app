class Data {
  TravelConsultants? travelConsultants;
  Customers? customers;
  Commission? commission;

  Data({this.travelConsultants, this.customers, this.commission});

  Data.fromJson(Map<String, dynamic> json) {
    travelConsultants = json['travel_consultants'] != null
        ? TravelConsultants.fromJson(json['travel_consultants'])
        : null;
    customers = json['customers'] != null
        ? Customers.fromJson(json['customers'])
        : null;
    commission = json['commission'] != null
        ? Commission.fromJson(json['commission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (travelConsultants != null) {
      data['travel_consultants'] = travelConsultants!.toJson();
    }

    if (customers != null) {
      data['customers'] = customers!.toJson();
    }

    if (commission != null) {
      data['commission'] = commission!.toJson();
    }
    return data;
  }
}

class Commission {
  String? confirmed;
  String? pending;

  Commission({this.confirmed, this.pending});

  Commission.fromJson(Map<String, dynamic> json) {
    confirmed = json['confirmed'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirmed'] = confirmed;
    data['pending'] = pending;
    return data;
  }
}

class Customers {
  int? total;
  int? thisMonth;

  Customers({this.total, this.thisMonth});

  Customers.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    thisMonth = json['this_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['this_month'] = thisMonth;
    return data;
  }
}

class TravelConsultants {
  int? total;
  int? thisMonth;

  TravelConsultants({this.total, this.thisMonth});

  TravelConsultants.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    thisMonth = json['this_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['this_month'] = thisMonth;
    return data;
  }
}
