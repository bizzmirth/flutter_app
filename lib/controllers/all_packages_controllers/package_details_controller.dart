import 'dart:convert';

import 'package:bizzmirth_app/models/package_details_model.dart';
import 'package:bizzmirth_app/models/package_images_model.dart';
import 'package:bizzmirth_app/models/package_itinerary_model.dart';
import 'package:bizzmirth_app/models/package_price_model.dart';
import 'package:bizzmirth_app/models/package_response_model.dart';
import 'package:bizzmirth_app/models/package_tour_plan_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PackageDetailsController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  PackageResponse? _packageResponse;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PackageResponse? get packageResponse => _packageResponse;

  // Convenience getters for easier access to data
  PackageDetails? get packageDetails => _packageResponse?.firstPackageDetails;
  PackagePrice? get packagePrice => _packageResponse?.firstPackagePrice;
  List<PackageTourPlan> get tourPlan => _packageResponse?.sortedTourPlan ?? [];
  List<PackagePicture> get pictures => _packageResponse?.packagePictures ?? [];
  PackageItinerary? get itinerary => _packageResponse?.firstPackageItinerary;
  List<String> get hotels => _packageResponse?.packageHotels ?? [];
  List<String> get meals => _packageResponse?.packageMeals ?? [];
  List<String> get vehicles => _packageResponse?.packageVehicles ?? [];

  // Check if data is available
  bool get hasData => _packageResponse != null && _packageResponse!.isSuccess;

  Future<void> getPackageDetails({String? packageId}) async {
    _isLoading = true;
    _error = null;
    _packageResponse = null;
    notifyListeners();

    try {
      final fullUrl = AppUrls.getTourPackageDetails; // Use the URL from AppUrls

      final Map<String, dynamic> body = {'id': packageId};
      final encodeBody = jsonEncode(body);

      Logger.warning('Fetching package details for ID: $encodeBody');

      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodeBody,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Logger.info('full package details URL: $fullUrl');
      Logger.info('Response status code: ${response.statusCode}');
      Logger.info('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Parse the response using our model
        _packageResponse = PackageResponse.fromJson(jsonData);

        // Check if the API response indicates success
        if (_packageResponse!.isSuccess) {
          Logger.info('Successfully fetched package details');
        } else {
          _error =
              'API returned unsuccessful status: ${_packageResponse!.status}';
          Logger.error(_error!);
        }
      } else {
        _error =
            'Failed to fetch package details. Status code: ${response.statusCode}';
        Logger.error(_error!);
      }
    } catch (e, s) {
      _error = 'Error fetching package details: $e';
      Logger.error('Error fetching package details. Error: $e, Stacktrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Additional helper methods for UI

  // Get formatted package summary for display
  String getPackageSummary() {
    if (!hasData) return 'No package data available';
    return _packageResponse!.packageSummary;
  }

  // Calculate total price for given passengers
  double calculateTotalPrice(int adults, int children) {
    if (packagePrice == null) return 0.0;
    return packagePrice!.calculateTotalPrice(adults, children);
  }

  // Get formatted total price
  String getFormattedTotalPrice(int adults, int children) {
    if (packagePrice == null) return '₹0.00';
    return packagePrice!.getFormattedTotalPrice(adults, children);
  }

  // Get tour duration
  String getTourDuration() {
    if (packageDetails == null) return 'Not specified';
    return '${packageDetails!.tourDays} days';
  }

  // Check if package is valid (not expired)
  bool isPackageValid() {
    if (packageDetails == null) return false;
    final validityDate = packageDetails!.validityDate;
    if (validityDate == null) return true; // Assume valid if no date specified
    return validityDate.isAfter(DateTime.now());
  }

  // Get package images with full URLs
  List<String> getImageUrls({String? baseUrl}) {
    final effectiveBaseUrl = baseUrl ?? AppUrls.getImageBaseUrl;
    return pictures
        .map((picture) => picture.getFullImageUrl(baseUrl: effectiveBaseUrl))
        .toList();
  }

  // Get places to visit across all days
  List<String> getAllPlacesToVisit() {
    final places = <String>[];
    for (final day in tourPlan) {
      places.addAll(day.placesToVisit);
    }
    return places.toSet().toList(); // Remove duplicates
  }

  // Refresh data
  void refreshPackageDetails({String? packageId}) {
    final id = packageId ?? '160';
    getPackageDetails(packageId: id);
  }

  // Clear data
  void clearData() {
    _packageResponse = null;
    _error = null;
    notifyListeners();
  }

  // Check if specific meal is included
  bool isMealIncluded(String meal) {
    return meals.any((m) => m.toLowerCase().contains(meal.toLowerCase()));
  }

  // Get cancellation policy
  Map<String, String> getCancellationPolicy() {
    if (itinerary == null) return {};
    return itinerary!.cancellationPolicy;
  }
}
