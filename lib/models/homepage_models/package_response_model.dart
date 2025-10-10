import 'package:bizzmirth_app/models/homepage_models/package_details_model.dart';
import 'package:bizzmirth_app/models/homepage_models/package_images_model.dart';
import 'package:bizzmirth_app/models/homepage_models/package_itinerary_model.dart';
import 'package:bizzmirth_app/models/homepage_models/package_price_model.dart';
import 'package:bizzmirth_app/models/homepage_models/package_tour_plan_model.dart';

class PackageResponse {
  final String status;
  final List<PackageDetails> packageDetails;
  final List<PackagePrice> packagePrice;
  final List<PackagePicture> packagePictures;
  final List<String> packageHotels;
  final List<String> packageMeals;
  final List<String> packageVehicles;
  final List<String> packageOccupancyType;
  final List<PackageItinerary> packageItinerary;
  final List<PackageTourPlan> packageTourPlan;

  PackageResponse({
    required this.status,
    required this.packageDetails,
    required this.packagePrice,
    required this.packagePictures,
    required this.packageHotels,
    required this.packageMeals,
    required this.packageVehicles,
    required this.packageOccupancyType,
    required this.packageItinerary,
    required this.packageTourPlan,
  });

  factory PackageResponse.fromJson(Map<String, dynamic> json) {
    return PackageResponse(
      status: json['status'] ?? '',
      packageDetails: (json['package_details'] as List<dynamic>?)
              ?.map((item) => PackageDetails.fromJson(item))
              .toList() ??
          [],
      packagePrice: (json['package_price'] as List<dynamic>?)
              ?.map((item) => PackagePrice.fromJson(item))
              .toList() ??
          [],
      packagePictures: (json['package_pictures'] as List<dynamic>?)
              ?.map((item) => PackagePicture.fromJson(item))
              .toList() ??
          [],
      packageHotels: (json['package_hotels'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      packageMeals: (json['package_meals'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      packageVehicles: (json['package_vehicles'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      packageOccupancyType: (json['package_occupancy_type'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      packageItinerary: (json['package_itenary'] as List<dynamic>?)
              ?.map((item) => PackageItinerary.fromJson(item))
              .toList() ??
          [],
      packageTourPlan: (json['package_tour_plan'] as List<dynamic>?)
              ?.map((item) => PackageTourPlan.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'package_details': packageDetails.map((item) => item.toJson()).toList(),
      'package_price': packagePrice.map((item) => item.toJson()).toList(),
      'package_pictures': packagePictures.map((item) => item.toJson()).toList(),
      'package_hotels': packageHotels,
      'package_meals': packageMeals,
      'package_vehicles': packageVehicles,
      'package_occupancy_type': packageOccupancyType,
      'package_itenary': packageItinerary.map((item) => item.toJson()).toList(),
      'package_tour_plan':
          packageTourPlan.map((item) => item.toJson()).toList(),
    };
  }

  // Helper methods
  bool get isSuccess => status.toLowerCase() == 'success';

  PackageDetails? get firstPackageDetails =>
      packageDetails.isNotEmpty ? packageDetails.first : null;

  PackagePrice? get firstPackagePrice =>
      packagePrice.isNotEmpty ? packagePrice.first : null;

  PackageItinerary? get firstPackageItinerary =>
      packageItinerary.isNotEmpty ? packageItinerary.first : null;

  // Get tour plan sorted by day number
  List<PackageTourPlan> get sortedTourPlan {
    final sorted = List<PackageTourPlan>.from(packageTourPlan);
    sorted.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));
    return sorted;
  }

  // Get all meals across all days
  Set<String> get allMealsIncluded {
    final meals = <String>{};
    for (final day in packageTourPlan) {
      meals.addAll(day.mealsList);
    }
    return meals;
  }

  // Get summary information
  String get packageSummary {
    final details = firstPackageDetails;
    final price = firstPackagePrice;
    if (details == null) return 'No package details available';

    final priceInfo =
        price != null ? ' - Starting from ${price.formattedAdultPrice}' : '';

    return '${details.name} (${details.tourDays} days)$priceInfo';
  }

  @override
  String toString() {
    return 'PackageResponse(status: $status, packageCount: ${packageDetails.length})';
  }
}
