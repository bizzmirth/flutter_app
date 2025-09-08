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
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("contact us URL: $fullUrl");
      Logger.success("Requesr body for contact us: $encodeBody");
      if (response.statusCode == 200) {
        Logger.success("Response from contact us ${response.body}");
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          ToastHelper.showSuccessToast(
            context: context,
            title: data["message"] ?? "Message sent successfully.",
          );
        } else {
          ToastHelper.showErrorToast(
            context: context,
            title: data["message"] ?? "Something went wrong.",
          );
        }
      } else {
        ToastHelper.showErrorToast(
          context: context,
          title: "Server error: ${response.statusCode}",
        );
      }
    } catch (e, s) {
      _error = "Error sending message to the server. $e";
      Logger.error(
          "Error sending message to the sevrer. Error: $e, Stacktree: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
