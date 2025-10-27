// function to convert [3 star, 4 star, 5 star] to [3,4,5]
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';

List<String> convertStarsToNumbers(List<String> selectedStars) {
  return selectedStars.map((star) {
    switch (star) {
      case '3 Star':
        return '3';
      case '4 Star':
        return '4';
      case '5 Star':
        return '5';
      case 'Villa':
        return 'Villa'; // Keep Villa as is, or change to a number if needed
      default:
        return star;
    }
  }).toList();
}

// function to get min duration and max duration from values like "4N - 7N"
Map<String, String> getTripDurationValues(String? selectedDuration) {
  switch (selectedDuration) {
    case 'Upto 3N':
      return {'minDuration': '0', 'maxDuration': '3', 'tripDuration': ''};
    case '4N - 7N':
      return {'minDuration': '4', 'maxDuration': '7', 'tripDuration': ''};
    case '7N - 11N':
      return {'minDuration': '7', 'maxDuration': '11', 'tripDuration': ''};
    case '11N - 15N':
      return {'minDuration': '11', 'maxDuration': '15', 'tripDuration': ''};
    case 'Above 15N':
      return {
        'minDuration': '15',
        'maxDuration': '999', // or whatever max value you want
        'tripDuration': ''
      };
    default:
      return {'minDuration': '0', 'maxDuration': '999', 'tripDuration': ''};
  }
}

// this function takes the dob as a arugement and calculates and returns the age
String calculateAge(String dobString) {
  try {
    final parts = dobString.split('-');
    if (parts.length != 3) return 'Invalid date';

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final dob = DateTime(year, month, day);
    final today = DateTime.now();

    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age.toString();
  } catch (e) {
    return 'Invalid date';
  }
}

// this function takes the name as lower case and return the name first alphabet as capital. Eg. input: harsh. output: Harsh
String capitalize(String input) {
  if (input.isEmpty) return '';
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

// this function takes tour days as in put and return the correct days and nights. Eg. input 05. output: 5 days 4 nights
String formatTourDuration(String? tourDays) {
  if (tourDays == null || tourDays.isEmpty) return 'N/A';

  // parse and remove leading zeros
  final int days = int.tryParse(tourDays) ?? 0;
  if (days <= 1) return 'N/A'; // since 1 will never come, but just in case

  final int nights = days - 1;
  return '$days Days $nights Nights';
}

// helper to show the data in the points stype
List<String> formatItineraryText(String? text) {
  if (text == null || text.isEmpty) return [];

  return text
      .split('.') // split by period
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .map((e) => '- $e.') // add `-` at start & keep period
      .toList();
}

// logs out user clearing all the data from the shared pref
Future<void> performLogout(BuildContext context) async {
  final sharedPrefHelper = SharedPrefHelper();
  await sharedPrefHelper.removeDetails();

  // Navigate to LoginPage and remove all previous routes
  if (!context.mounted) return;
  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false,
  );
}

/// handleFile(selectedFiles, 'Profile Picture', customer.profilePic);
/// takes the required input and generates the required url for the key
void handleFile(
    Map<String, dynamic> selectedFiles, String key, String? fileUrl) {
  if (fileUrl == null) return;

  const baseUrl = 'https://testca.uniqbizz.com/uploading/';

  if (fileUrl.startsWith(baseUrl)) {
    selectedFiles[key] = fileUrl;
  } else {
    selectedFiles[key] = '$baseUrl$fileUrl';
  }

  Logger.success('$key: ${selectedFiles[key]}');
}

// takes the selected gender string and return a api ready gender string
String formatGender(String gender) {
  switch (gender.toLowerCase().trim()) {
    case 'male':
      return 'male';
    case 'female':
      return 'female';
    case 'other':
      return 'other';
    default:
      return '---- Select Gender ----';
  }
}

// helper function that takes the selected country code with the leading +91 and return 91
String? sanitizeCountryCode(String? countryCode) {
  if (countryCode == null || countryCode.isEmpty) return null;

  // Remove any leading '+' and trim whitespace
  return countryCode.replaceAll('+', '').trim();
}
