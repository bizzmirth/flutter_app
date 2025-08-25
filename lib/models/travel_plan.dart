class TravelPlanTopSellingDestinations {
  String? id;
  String? destination;
  String? image;

  TravelPlanTopSellingDestinations({this.id, this.destination, this.image});

  TravelPlanTopSellingDestinations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['destination'] = destination;
    data['image'] = image;
    return data;
  }
}
