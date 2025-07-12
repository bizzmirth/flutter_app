import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String _userDataTypeKey = "user_data_type";

  static String _userTypeKey = "user_type";

  static String _userEmailKey = "user_email";

  static String _currUserCustId = "ca_customer_id";

  static String _currentUserRegDate = "current_user_reg_date";

  Future<void> saveUserDataType(String userDataType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataTypeKey, userDataType);
  }

  Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
  }

  Future<void> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, userEmail);
  }

  Future<void> saveCurrentUserCustId(String custId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currUserCustId, custId);
  }

  Future<void> saveCurrentUserRegDate(String regDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserRegDate, regDate);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  Future<String?> getCurrentUserRegDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserRegDate);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserDataType(String s) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataTypeKey);
  }

  Future<String?> getCurrentUserCustId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currUserCustId);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> removeUserEmailAndType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userTypeKey);
  }
}
