import 'dart:convert';

import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //form state
  bool obscurePassword = true;
  bool rememberMe = false;
  String? selectedUserTypeId;
  String? selectedUserTypeName;

  List<Map<String, String>> userTypeNames = [];

  bool isLoading = false;

  String? errorMessage;

  LoginController() {
    loadUserTypes();
  }

  // Toggle password visibility
  togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // Handle remember me toggle
  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  void setSelectedUserType(String? id) {
    if (id == null) {
      selectedUserTypeId = null;
      selectedUserTypeName = null;
    } else {
      selectedUserTypeId = id;
      final selectedUserType = userTypeNames.firstWhere(
        (userType) => userType["id"] == id,
        orElse: () => {"id": "", "name": "Not found"},
      );
      selectedUserTypeName = selectedUserType["name"];
    }

    Logger.info("Selected User Type ID: $selectedUserTypeId");
    Logger.info("Selected User Type Name: $selectedUserTypeName");

    notifyListeners();
  }

  Future<void> loadUserTypes() async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString('user_data_type');

      // List of IDs you want to display
      final List<String> allowedIds = ['1', '10', '11', '16', '24', '25', '26'];

      if (storedData != null) {
        final jsonData = json.decode(storedData);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        userTypeNames = userTypeResponse.data
            .where((userType) => allowedIds.contains(userType.id))
            .map((userType) => {"id": userType.id, "name": userType.name})
            .toList();

        Logger.info("Filtered User Type Names: $userTypeNames");
      } else {
        // Fallback data with only allowed IDs
        userTypeNames = [
          {"id": "1", "name": "admin"},
          // Include other defaults only if they match allowed IDs
        ];
      }
    } catch (e) {
      Logger.error('Error loading user types: $e');
      // Fallback data with only allowed IDs
      userTypeNames = [
        {"id": "1", "name": "admin"},
        // Include other defaults only if they match allowed IDs
      ];
      errorMessage = 'Failed to load user types: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
    selectedUserTypeId = null;
    selectedUserTypeName = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> loginUser() async {
    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      // Validate form data
      if (selectedUserTypeId == null || selectedUserTypeId!.isEmpty) {
        errorMessage = "Please select a user type";
        isLoading = false;
        notifyListeners();
        return {"success": false, "message": errorMessage};
      }

      if (emailController.text.isEmpty) {
        errorMessage = "Please enter your email";
        isLoading = false;
        notifyListeners();
        return {"success": false, "message": errorMessage};
      }

      if (passwordController.text.isEmpty) {
        errorMessage = "Please enter your password";
        isLoading = false;
        notifyListeners();
        return {"success": false, "message": errorMessage};
      }

      // API call
      final url = Uri.parse('https://testca.uniqbizz.com/api/login.php');
      final email = emailController.text;
      final password = passwordController.text;

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        'user_type_id': selectedUserTypeId,
        'username': email,
        'password': password
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String userType = responseData["user_type"];

        // Save user type to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_type', userType);

        Logger.success("Login Successful ${response.body}");
        Logger.info("User Type from response: $userType");

        isLoading = false;
        clearFormFields();
        notifyListeners();

        return {"success": true, "user_type": userType, "data": responseData};
      } else {
        Logger.error("Login Failed: ${response.body}");
        errorMessage = "Login failed. Please check your credentials.";
        isLoading = false;
        notifyListeners();
        return {"success": false, "message": errorMessage};
      }
    } catch (e) {
      Logger.error("Error: ${e.toString()}");
      errorMessage = "An error occurred: ${e.toString()}";
      isLoading = false;
      notifyListeners();
      return {"success": false, "message": errorMessage};
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
