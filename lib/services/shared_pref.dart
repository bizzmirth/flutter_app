import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String _userDataTypeKey = "user_data_type";

  static String _userTypeKey = "user_type";

  static String _userEmailKey = "user_email";

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

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserDataType(String s) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataTypeKey);
  }
}
