import 'dart:convert';
import 'package:bizzmirth_app/models/best_deals_model.dart';
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
  List<BestDealsModel> _bestDealPackages = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TourPackageModel> get tourPackages => _tourPackages;
  List<TravelPlanTopSellingDestinations> get topTourPackages =>
      _topTourPackages;
  List<BestDealsModel> get bestDealPackages => _bestDealPackages;

  // In TourPackagesController class
  List<TourPackageModel> get filteredPackages {
    if (_searchQuery.isEmpty) {
      return tourPackages;
    }
    return tourPackages.where((package) {
      return package.destination
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ==
              true ||
          package.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
              true;
    }).toList();
  }

  String _searchQuery = '';

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

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

          // _tourPackages =
          //     packageList.map((pkg) => TourPackageModel.fromJson(pkg)).toList();

          _topTourPackages = packageList
              .take(10)
              .map((pkg) => TravelPlanTopSellingDestinations.fromJson(pkg))
              .toList();

          // Logger.success(
          //     "Tour packages populated: ${_tourPackages.length} items");
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

  void apiGetFilteredPackages(
      List<String> selectedStars,
      String minBudget,
      String maxBudget,
      String minDuration,
      String maxDuration,
      String tripDuration) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl =
          "https://ca.uniqbizz.com/api/packages/filtered_package.php";
      final Map<String, dynamic> body = {
        "userId": "",
        "usertype": "",
        "minPrice": minBudget,
        "maxPrice": maxBudget,
        "minDuration": minDuration,
        "maxDuration": maxDuration,
        "sort": "",
        "ratings": selectedStars,
        "destination": ""
      };
      final encodeBody = json.encode(body);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("Encoded body of filtered $encodeBody");

      Logger.success("Raw Data fetched from filtered api ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> packages = jsonData["packages"];
        Logger.warning("filtered packages : $packages");
        _tourPackages =
            packages.map((pkg) => TourPackageModel.fromJson(pkg)).toList();
      } else {
        _error = "Server error : ${response.body}";
        Logger.error("Server error : ${response.body}");
      }

      Logger.warning(
          "Total Packages after filter applied ${_tourPackages.length}");
    } catch (e, s) {
      _error = "Error fetching filtered data, Error: $e";
      Logger.error("Error fetching filtered data, Error: $e, Stacktree: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void apiGetBestDeals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl =
          "https://ca.uniqbizz.com/api/packages/best_deals.php";
      final response = await http.get(Uri.parse(fullUrl),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        Logger.success("Raw response from best deals api : ${response.body}");
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success' && jsonData['packages'] != null) {
          List<dynamic> bestDeals = jsonData['packages'];
          _bestDealPackages = bestDeals
              .take(5)
              .map((bestDeal) => BestDealsModel.fromJson(bestDeal))
              .toList();
        } else {
          _error = "Error populating entries in the model ${response.body}";
        }
      } else {
        _error = "Error from the api : ${response.body}";
      }
      Logger.success(
          "Total Best deals populated is ${_bestDealPackages.length}");
    } catch (e, s) {
      _error = "Error fetching best deals $e";
      Logger.error("Error fetching best deals. Error: $e, Stacktree: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
