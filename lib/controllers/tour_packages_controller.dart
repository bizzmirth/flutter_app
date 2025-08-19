import 'dart:convert';
import 'package:bizzmirth_app/models/tour_package_model.dart';
import 'package:bizzmirth_app/models/travel_plan.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TourPackagesController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TourPackageModel> _tourPackages = [];
  List<TravelPlanTopSellingDestinations> _topTourPackages = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TourPackageModel> get tourPackages => _tourPackages;
  List<TravelPlanTopSellingDestinations> get topTourPackages =>
      _topTourPackages;

  void apiGetTourPackages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl =
          "https://ca.uniqbizz.com/api/packages/best_destinations.php";

      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        Logger.success("Response from tour details ${response.body}");

        final Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;

        if (decoded["status"] == "success" && decoded["packages"] != null) {
          final List<dynamic> packageList = decoded["packages"];

          _tourPackages =
              packageList.map((pkg) => TourPackageModel.fromJson(pkg)).toList();

          _topTourPackages = packageList
              .take(10)
              .map((pkg) => TravelPlanTopSellingDestinations.fromJson(pkg))
              .toList();

          Logger.success(
              "Tour packages populated: ${_tourPackages.length} items");
          Logger.success(
              "Top tour packages populated: ${_topTourPackages.length} items");
        } else {
          _error = "No packages found";
          Logger.error("No packages found in response");
        }
      } else {
        _error = "Server error: ${response.statusCode}";
        Logger.error("Failed with status: ${response.statusCode}");
      }
    } catch (e, s) {
      Logger.error("Error fetching tour packages. Error: $e, Stacktrace: $s");
      _error = "Error fetching package details $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
