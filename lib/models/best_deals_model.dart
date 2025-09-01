class BestDealsModel {
  String? id;
  String? destination;
  String? image;
  String? tourDays;
  String? name;
  String? status;
  String? lastBookingDate;
  String? totalPackagePricePerAdult;

  BestDealsModel(
      {this.id,
      this.destination,
      this.image,
      this.tourDays,
      this.name,
      this.status,
      this.lastBookingDate,
      this.totalPackagePricePerAdult});

  BestDealsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    image = json['image'];
    tourDays = json['tour_days'];
    name = json['name'];
    status = json['status'];
    lastBookingDate = json['last_booking_date'];
    totalPackagePricePerAdult = json['total_package_price_per_adult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['destination'] = destination;
    data['image'] = image;
    data['tour_days'] = tourDays;
    data['name'] = name;
    data['status'] = status;
    data['last_booking_date'] = lastBookingDate;
    data['total_package_price_per_adult'] = totalPackagePricePerAdult;
    return data;
  }
}
