class TourPackageModel {
  String? id;
  String? destination;
  String? image;
  String? tourDays;
  String? name;
  String? lastBookingDate;

  TourPackageModel(
      {this.id,
      this.destination,
      this.image,
      this.tourDays,
      this.name,
      this.lastBookingDate});

  TourPackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    image = json['image'];
    tourDays = json['tour_days'];
    name = json['name'];
    lastBookingDate = json['last_booking_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['destination'] = destination;
    data['image'] = image;
    data['tour_days'] = tourDays;
    data['name'] = name;
    data['last_booking_date'] = lastBookingDate;
    return data;
  }
}
