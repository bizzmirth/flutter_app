class TravelPlanTopSellingDestinations {
  String? destination;
  String? image;

  TravelPlanTopSellingDestinations({this.destination, this.image});

  TravelPlanTopSellingDestinations.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination'] = destination;
    data['image'] = image;
    return data;
  }
}
