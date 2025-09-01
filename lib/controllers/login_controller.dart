import 'dart:convert';

import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //form state
  bool obscurePassword = true;
  bool rememberMe = false;
  String? selectedUserTypeId;
  String? selectedUserTypeName;
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  List<Map<String, String>> userTypeNames = [];

  bool isLoading = false;

  String? errorMessage;

  LoginController() {
    loadUserTypes();
    _loadSavedCredentials();
  }

  // Load saved credentials if "Remember Me" was enabled
  Future<void> _loadSavedCredentials() async {
    try {
      final savedRememberMe = await _sharedPrefHelper.getRememberMe();
      if (savedRememberMe) {
        final savedEmail = await _sharedPrefHelper.getSavedEmail();
        final savedPassword = await _sharedPrefHelper.getSavedPassword();
        final savedUserTypeId = await _sharedPrefHelper.getSavedUserTypeId();

        if (savedEmail != null) emailController.text = savedEmail;
        if (savedPassword != null) passwordController.text = savedPassword;
        if (savedUserTypeId != null) {
          selectedUserTypeId = savedUserTypeId;
          // Find and set the user type name
          final selectedUserType = userTypeNames.firstWhere(
            (userType) => userType["id"] == savedUserTypeId,
            orElse: () => {"id": "", "name": ""},
          );
          selectedUserTypeName = selectedUserType["name"];
        }

        rememberMe = true;
        notifyListeners();
      }
    } catch (e) {
      Logger.error('Error loading saved credentials: $e');
    }
  }

  // Save credentials securely
  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await _sharedPrefHelper.saveRememberMe(true);
      await _sharedPrefHelper.saveEmail(emailController.text);
      await _sharedPrefHelper.savePassword(passwordController.text);
      if (selectedUserTypeId != null) {
        await _sharedPrefHelper.saveUserTypeId(selectedUserTypeId!);
      }
    } else {
      // Clear saved credentials if "Remember Me" is disabled
      await _sharedPrefHelper.saveRememberMe(false);
      await _sharedPrefHelper.clearSavedCredentials();
    }
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

      final String? storedData =
          await _sharedPrefHelper.getUserDataType('user_data_type');

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

        // After loading user types, try to set the user type name if we have a saved ID
        if (selectedUserTypeId != null && selectedUserTypeName == null) {
          final selectedUserType = userTypeNames.firstWhere(
            (userType) => userType["id"] == selectedUserTypeId,
            orElse: () => {"id": "", "name": ""},
          );
          selectedUserTypeName = selectedUserType["name"];
          notifyListeners();
        }
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
    rememberMe = false;
    // Also clear saved credentials from storage
    _sharedPrefHelper.clearSavedCredentials();
    _sharedPrefHelper.saveRememberMe(false);
    notifyListeners();
  }

  Future<Map<String, dynamic>> loginUser(context) async {
    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      if (selectedUserTypeId == null || selectedUserTypeId!.isEmpty) {
        errorMessage = "Please select a user type";
        isLoading = false;
        notifyListeners();
        ToastHelper.showInfoToast(
          context: context,
          title: "Login Failed",
          description: errorMessage,
        );
        return {"success": false, "message": errorMessage};
      }

      if (emailController.text.isEmpty) {
        errorMessage = "Please enter your email";
        isLoading = false;
        notifyListeners();
        ToastHelper.showInfoToast(
          context: context,
          title: "Login Failed",
          description: "Please enter all the fields.",
        );
        return {"success": false, "message": errorMessage};
      }

      if (passwordController.text.isEmpty) {
        errorMessage = "Please enter your password";
        isLoading = false;
        notifyListeners();
        ToastHelper.showInfoToast(
          context: context,
          title: "Login Failed",
          description: "Please enter all the fields.",
        );
        return {"success": false, "message": errorMessage};
      }

      // API call
      final url = Uri.parse(AppUrls.login);
      final email = emailController.text;
      final password = passwordController.text;

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        'user_type_id': selectedUserTypeId,
        'username': email,
        'password': password,
      });
      final response = await http.post(url, headers: headers, body: body);
      Logger.success("Login URL: $url");
      Logger.success("Login response: ${response.body}");
      Logger.warning("Login Request Body: $body");

      if (response.statusCode == 200) {
        final Map responseData = json.decode(response.body);
        Logger.success("Response Data: $responseData");

        if (responseData["status"] == 1) {
          // success
          String userType = responseData["user_type"];
          String userId = responseData["user_id"];

          await _sharedPrefHelper.saveUserType(userType);
          await _sharedPrefHelper.saveUserEmail(email);
          await _sharedPrefHelper.saveCurrentUserCustId(userId);

          // Save credentials if "Remember Me" is checked
          await _saveCredentials();

          isLoading = false;
          // Don't clear form fields if remember me is enabled
          if (!rememberMe) {
            clearFormFields();
          } else {
            notifyListeners();
          }

          return {"status": true, "user_type": userType, "data": responseData};
        } else {
          // failure from API
          errorMessage = responseData["message"] ?? "Login failed";
          isLoading = false;
          notifyListeners();
          return {"success": false, "message": errorMessage};
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
        isLoading = false;
        notifyListeners();
        ToastHelper.showErrorToast(
          context: context,
          title: "Login Failed",
          description: errorMessage,
        );
        return {
          "success": false,
          "message": errorMessage
        }; // 👈 now always returns
      }
    } catch (e) {
      Logger.error("Error: ${e.toString()}");
      errorMessage = "An error occurred: ${e.toString()}";
      isLoading = false;
      notifyListeners();
      ToastHelper.showErrorToast(
        context: context,
        title: "Login Failed",
        description: errorMessage,
      );
      return {"success": false, "message": errorMessage};
    }
  }

  // Add a logout method to clear credentials
  Future<void> logout() async {
    // Clear only the session-related data, keep remember me credentials if enabled
    await _sharedPrefHelper.clearSessionData();

    // If remember me is not enabled, clear all credentials
    if (!rememberMe) {
      clearFormFields();
    } else {
      // Just clear the controllers but keep the saved state
      emailController.clear();
      passwordController.clear();
      selectedUserTypeId = null;
      selectedUserTypeName = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
