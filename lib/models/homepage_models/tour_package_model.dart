class TourPackageModel {
  String? id;
  String? name;
  String? description;
  String? destination;
  String? location;
  String? image;
  int? price;
  String? hotelCategory;

  TourPackageModel(
      {this.id,
      this.name,
      this.description,
      this.destination,
      this.location,
      this.image,
      this.price,
      this.hotelCategory});

  TourPackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    destination = json['destination'];
    location = json['location'];
    image = json['image'];
    price = json['price'];
    hotelCategory = json['hotel_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['destination'] = destination;
    data['location'] = location;
    data['image'] = image;
    data['price'] = price;
    data['hotel_category'] = hotelCategory;
    return data;
  }
}
