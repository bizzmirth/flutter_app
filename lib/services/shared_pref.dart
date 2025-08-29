import 'package:bizzmirth_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String _userDataTypeKey = "user_data_type";

  static String _userTypeKey = "user_type";

  static String _userEmailKey = "user_email";

  static String _currUserCustId = "ca_customer_id";

  static String _currentUserRegDate = "current_user_reg_date";

  static String _customerTypeKey = "customer_type";

  static const String _keyCustomerName = "customer_name";

  static const String _keyCustomerProfilePic = "customer_profile_pic";

  Future<void> saveUserDataType(String userDataType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataTypeKey, userDataType);
  }

  Future<void> saveCustomerType(String customerType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerTypeKey, customerType);
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

  Future<String?> getCustomerType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerTypeKey);
  }

  /// ✅ SETTERS
  Future<void> setCustomerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomerName, name);
  }

  Future<void> setCustomerProfilePic(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomerProfilePic, url);
  }

  /// ✅ GETTERS
  Future<String?> getCustomerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCustomerName);
  }

  Future<String?> getCustomerProfilePic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCustomerProfilePic);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> removeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_currentUserRegDate);
    await prefs.remove(_customerTypeKey);
    await prefs.remove(_currUserCustId);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_keyCustomerName);
    await prefs.remove(_keyCustomerProfilePic);
    Logger.warning("message: User details removed from shared preferences");
  }

  Future<void> clearUserDataType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data_type');
  }

  // Save remember me preference
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

// Get remember me preference
  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

// Save email
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
  }

// Get saved email
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

// Save password
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_password', password);
  }

// Get saved password
  Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_password');
  }

// Save user type ID
  Future<void> saveUserTypeId(String userTypeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_user_type_id', userTypeId);
  }

// Get saved user type ID
  Future<String?> getSavedUserTypeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_user_type_id');
  }

// Clear all saved credentials
  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.remove('saved_user_type_id');
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
