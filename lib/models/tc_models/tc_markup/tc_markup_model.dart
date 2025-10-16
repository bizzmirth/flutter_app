class TcMarupModel {
  String? packageId;
  String? packageName;
  String? packageType;
  double? adultPrice;
  double? childPrice;
  double? commission;
  double? markup;
  double? sellingPrice;

  TcMarupModel(
      {this.packageId,
      this.packageName,
      this.packageType,
      this.adultPrice,
      this.childPrice,
      this.commission,
      this.markup,
      this.sellingPrice});

  TcMarupModel.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    packageName = json['package_name'];
    packageType = json['package_type'];
    adultPrice = (json['adult_price'] != null)
        ? (json['adult_price'] as num).toDouble()
        : null;
    childPrice = (json['child_price'] != null)
        ? (json['child_price'] as num).toDouble()
        : null;
    commission = (json['commission'] != null)
        ? (json['commission'] as num).toDouble()
        : null;
    markup =
        (json['markup'] != null) ? (json['markup'] as num).toDouble() : null;
    sellingPrice = (json['selling_price'] != null)
        ? (json['selling_price'] as num).toDouble()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_id'] = packageId;
    data['package_name'] = packageName;
    data['package_type'] = packageType;
    data['adult_price'] = adultPrice;
    data['child_price'] = childPrice;
    data['commission'] = commission;
    data['markup'] = markup;
    data['selling_price'] = sellingPrice;
    return data;
  }
}
