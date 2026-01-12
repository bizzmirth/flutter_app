import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/utils/logger.dart';

class HomePageController extends ChangeNotifier {
  List<UserType> _userTypes = [];
  bool _isLoading = true;
  String _error = '';
  List<UserType> get userTypes => _userTypes;
  bool get isLoading => _isLoading;
  String get error => _error;

  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  HomePageController() {
    loadUserTypes();
    // Logger.warning('home page controller constructor called');
  }

  Future<void> loadUserTypes() async {
    try {
      final String? storedData =
          await _sharedPrefHelper.getUserDataType('user_data_type');

      if (storedData != null && storedData.isNotEmpty) {
        // Logger.info('Loading user types from SharedPreferences');
        final jsonData = json.decode(storedData);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        _userTypes = userTypeResponse.data;
        _isLoading = false;
        notifyListeners();

        Logger.success(
            'User types loaded from cache: ${_userTypes.length} items');
      } else {
        Logger.info('No cached data found, fetching from API');
        await fetchEmployeeTypeFromAPI();
      }
    } catch (e) {
      Logger.error('Error loading user types: $e');
      await fetchEmployeeTypeFromAPI();
    }
  }

  Future<void> fetchEmployeeTypeFromAPI() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final String url = AppUrls.getAllUserTypes;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Logger.info('Response from user type API: ${response.body}');
        final jsonData = json.decode(response.body);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        await _sharedPrefHelper.saveUserDataType(response.body);
        Logger.success('Get all usertype URL: $url ');
        Logger.success('User types saved to SharedPreferences');

        _userTypes = userTypeResponse.data;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Failed to load user types. Status: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();

        Logger.error('API Error: Status ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error fetching user types from API: $e');
      _error = 'Error fetching user types: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserTypes() async {
    Logger.info('Force refreshing user types from API');
    await fetchEmployeeTypeFromAPI();
  }

  Future<void> clearCachedUserTypes() async {
    try {
      await _sharedPrefHelper.clearUserDataType();
      _userTypes = [];
      _isLoading = true;
      notifyListeners();
      Logger.info('Cached user types cleared');
    } catch (e) {
      Logger.error('Error clearing cached user types: $e');
    }
  }

  Future<void> printSavedUserTypes() async {
    try {
      final String? storedData =
          await _sharedPrefHelper.getUserDataType('user_data_type');

      if (storedData != null) {
        final jsonData = json.decode(storedData);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        Logger.success('Saved User Types:');
        for (var userType in userTypeResponse.data) {
          Logger.info(
              'ID: ${userType.id}, Name: ${userType.name}, Ref Name: ${userType.refName}');
        }
      } else {
        Logger.warning('No saved user types found in SharedPreferences');
      }
    } catch (e) {
      Logger.error('Error retrieving saved user types: $e');
    }
  }
}
