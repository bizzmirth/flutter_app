import 'dart:convert';
import 'package:bizzmirth_app/models/coupons_data_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileController extends ChangeNotifier {
  // Loading and error state
  static const String _baseUrl = "https://testca.uniqbizz.com/";
  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CouponData> _couponsData = [];
  List<CouponData> get couponsData => _couponsData;

  // Personal details
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _gender;
  String? _dob;
  String? _fullAddress;
  String? _compCheck;
  String? _customerType;

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get gender => _gender;
  String? get dob => _dob;
  String? get fullAddress => _fullAddress;
  String? get compCheck => _compCheck;
  String? get customerType => _customerType;

  // Location details
  String? _country;
  String? _state;
  String? _city;
  String? _zipCode;

  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  String? get zipCode => _zipCode;

  // Profile picture
  String? _profilePic;
  String? get profilePic => _profilePic;

  // Documents
  String? _bankPassbook;
  String? _panCard;
  String? _aadharCard;
  String? _votingCard;
  String? _idProof;

  String? get bankPassbook => _bankPassbook;
  String? get panCard => _panCard;
  String? get aadharCard => _aadharCard;
  String? get votingCard => _votingCard;
  String? get idProof => _idProof;

  String? _formatUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    return path.startsWith("http")
        ? path
        : _baseUrl + path.replaceFirst("../", "");
  }

  Future<void> apiGetPersonalDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getPersonalDetails;

      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {"userId": userId, "userType": "10"};

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success("Response from Profile API: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 'success') {
          _customerType = decoded['data']['customer_type'];
          final basicInfo = decoded['data']['basic_info'];
          final location = decoded['data']['location'];
          final documents = decoded['data']['documents'];
          final compCheck = decoded['data']['comp_chek'];
          _compCheck = compCheck;

          Logger.success("Customer Type from API: $_customerType");
          Logger.success("documents $documents and comp check is $_compCheck");

          // Personal Info
          _firstName = basicInfo['first_name'];
          _lastName = basicInfo['last_name'];
          _email = basicInfo['email'];
          _phone = basicInfo['phone'];
          _gender = basicInfo['gender'];
          _dob = basicInfo['dob'];
          _fullAddress = basicInfo['address'];

          // Location Info
          _country = location['country']?['name'];
          _state = location['state']?['name'];
          _city = location['city']?['name'];
          _zipCode = location['pincode']?.toString();

          // Documents
          // Documents with formatted full URLs
          _profilePic = _formatUrl(basicInfo['profile_pic']);
          _bankPassbook = _formatUrl(documents['bank_passbook']);
          _panCard = _formatUrl(documents['pan_card']);
          _aadharCard = _formatUrl(documents['aadhar_card']);
          _votingCard = _formatUrl(documents['voting_card']);
          _idProof = _formatUrl(documents['id_proof']);

          Logger.success(
              "Profile Picture $_profilePic, $_bankPassbook, $_panCard");

          Logger.success("Personal Details loaded successfully");
        } else {
          _errorMessage = decoded['message'] ?? "Unknown error occurred.";
        }
      } else {
        _errorMessage = "Failed to fetch data. Status: ${response.statusCode}";
      }
    } catch (e, s) {
      _errorMessage = "Failed to fetch personal details. ${e.toString()}";
      Logger.error("Error in apiGetPersonalDetails: $e, Stack trace: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetUserDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const String fullUrl =
          "https://testca.uniqbizz.com/api/customers/profile_page.php";

      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {"userId": userId, "userType": "10"};

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success("Response from User Details API: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 'success') {
          final basicInfo = decoded['data']['basic_info'];

          // Only populate user name and profile pic
          _firstName = basicInfo['first_name'];
          _lastName = basicInfo['last_name'];
          _profilePic = _formatUrl(basicInfo['profile_pic']);

          Logger.success(
              "User Details loaded successfully - Name: $_firstName $_lastName, Profile Pic: $_profilePic");
        } else {
          _errorMessage = decoded['message'] ?? "Unknown error occurred.";
        }
      } else {
        _errorMessage =
            "Failed to fetch user details. Status: ${response.statusCode}";
      }
    } catch (e, s) {
      _errorMessage = "Failed to fetch user details. ${e.toString()}";
      Logger.error("Error in apiGetUserDetails: $e, Stack trace: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void getCouponDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullUrl = "https://testca.uniqbizz.com/api/customers/coupons.php";
      final String? userId = await SharedPrefHelper().getCurrentUserCustId();
      final body = {"userId": userId};
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);

      Logger.success("Response from coupons Api ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> couponsJson = jsonResponse['coupons'] ?? [];

          _couponsData = couponsJson.map((couponJson) {
            return CouponData(
              id: couponJson['id']?.toString() ?? '',
              userId: couponJson['user_id']?.toString() ?? '',
              paymentId: couponJson['payment_id']?.toString() ?? '',
              code: couponJson['code']?.toString() ?? '',
              couponAmt: couponJson['coupon_amt']?.toString() ?? '0',
              usageStatus: couponJson['usage_status']?.toString() ?? '0',
              confirmStatus: couponJson['confirm_status']?.toString() ?? '0',
              createdDate: couponJson['created_date']?.toString() ?? '',
              usedDate: couponJson['used_date']?.toString(),
              deletedDate: couponJson['deleted_date']?.toString(),
              expiryDate: couponJson['expiry_date']?.toString() ?? '',
            );
          }).toList();

          Logger.success("Successfully parsed ${_couponsData.length} coupons");
        } else {
          _errorMessage = jsonResponse['message'] ?? "Failed to fetch coupons";
          Logger.error("API returned error status: ${jsonResponse['message']}");
        }
      } else {
        _errorMessage = "HTTP Error: ${response.statusCode}";
        Logger.error("HTTP Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      _errorMessage = "Error Fetching Coupons. Error: $e";
      Logger.error("Error Fetching coupons, Error: $e, Stacktrace: $s");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
