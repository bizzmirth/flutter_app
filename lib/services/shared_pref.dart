import 'dart:convert';
import 'package:bizzmirth_app/models/login_models/login_response_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final String _userDataTypeKey = 'user_data_type';

  static final String _currentUserRegDate = 'current_user_reg_date';

  static final String _customerTypeKey = 'customer_type';

  static final String _saveLoginResponse = 'login_response';

  static final String _rememberMe = 'remember_me';

  static final String _savedPassword = 'saved_password';

  static final String _savedEmail = 'saved_email';

  Future<void> saveUserDataType(String userDataType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataTypeKey, userDataType);
  }

  Future<void> saveCustomerType(String customerType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerTypeKey, customerType);
  }

  Future<void> saveCurrentUserRegDate(String regDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserRegDate, regDate);
  }

  // Save remember me preference
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMe, value);
  }

  Future<void> saveLoginResponse(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_saveLoginResponse, jsonEncode(data));
  }

  Future<String?> getCurrentUserRegDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserRegDate);
  }

  Future<String?> getUserDataType(String s) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataTypeKey);
  }

  Future<String?> getCustomerType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerTypeKey);
  }

  Future<LoginResponseModel?> getLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_saveLoginResponse);
    if (jsonString == null) return null;
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return LoginResponseModel.fromJson(data);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> removeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserRegDate);
    await prefs.remove(_customerTypeKey);
    Logger.warning('message: User details removed from shared preferences');
  }

  Future<void> clearUserDataType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data_type');
  }

// Get remember me preference
  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMe) ?? false;
  }

// Save email
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedEmail, email);
  }

// Get saved email
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmail);
  }

// Save password
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedPassword, password);
  }

// Get saved password
  Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedPassword);
  }

// Save user type ID
  // Future<void> saveUserTypeId(String userTypeId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_savedUserTypeId, userTypeId);
  // }

// Get saved user type ID
  // Future<String?> getSavedUserTypeId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_savedUserTypeId);
  // }

// Clear all saved credentials
  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmail);
    await prefs.remove(_savedPassword);
  }

// Clear session data (for logout)
  Future<void> clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_type');
    await prefs.remove('user_email');
    await prefs.remove('current_user_cust_id');
    // Don't clear remember me preferences and saved credentials
  }
}
