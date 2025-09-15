import 'dart:convert';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactUsController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void contactUs(
      BuildContext context, String name, String email, String message) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.contactUs;
      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "message": message
      };
      final encodeBody = jsonEncode(body);
      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodeBody,
        headers: {'Content-Type': 'application/json'},
      );

      Logger.success("contact us URL: $fullUrl");
      Logger.success("Request body for contact us: $encodeBody");

      // Check if context is still valid before using it
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        Logger.success("Response from contact us ${response.body}");
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          ToastHelper.showSuccessToast(
            title: data["message"] ?? "Message sent successfully.",
          );
        } else {
          ToastHelper.showErrorToast(
            title: data["message"] ?? "Something went wrong.",
          );
        }
      } else {
        ToastHelper.showErrorToast(
          title: "Server error: ${response.statusCode}",
        );
      }
    } catch (e, s) {
      _error = "Error sending message to the server. $e";
      Logger.error(
          "Error sending message to the server. Error: $e, Stacktrace: $s");

      // Check if context is still valid before showing error toast
      if (context.mounted) {
        ToastHelper.showErrorToast(
          title: "Error sending message to the server.",
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
