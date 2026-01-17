import 'dart:convert';
import 'package:bizzmirth_app/models/profile_models/coupons_data_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileController extends ChangeNotifier {
  // Loading and error state
  static const String _baseUrl = 'https://testca.uniqbizz.com/uploading/';
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

  int _eligibleCouponCount = 0;
  int get eligibleCouponCount => _eligibleCouponCount;

  ProfileController() {
    initiazeProfile();
  }

  Future<String> _getUserId() async {
    final loginRes = await SharedPrefHelper().getLoginResponse();
    return loginRes?.userId ?? '';
  }

  Future<void> initiazeProfile() async {
    await apiGetPersonalDetails();
    await apiGetUserDetails();
  }

  String? _formatUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    return path.startsWith('http')
        ? path
        : _baseUrl + path.replaceFirst('../', '');
  }

  // Add this method to count eligible coupons
  void _countEligibleCoupons() {
    _eligibleCouponCount = 0;

    for (var coupon in _couponsData) {
      // Check if usage_status is "1" (utilized)
      if (coupon.usageStatus == '1') {
        try {
          // Parse the created date
          final DateTime createdDate = DateTime.parse(coupon.createdDate);

          // Check if used_date exists and parse it
          if (coupon.usedDate != null && coupon.usedDate!.isNotEmpty) {
            final DateTime usedDate = DateTime.parse(coupon.usedDate!);

            // Calculate the difference in years
            final int yearsDifference =
                usedDate.difference(createdDate).inDays ~/ 365;

            // Check if used within 3 years from creation
            if (yearsDifference <= 3) {
              _eligibleCouponCount++;
            }
          }
        } catch (e) {
          Logger.error('Error parsing coupon dates: $e');
          continue; // Skip this coupon if date parsing fails
        }
      }
    }

    Logger.success('Eligible coupon count: $_eligibleCouponCount');
  }

  Future<void> apiGetPersonalDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.getPersonalDetails;
      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userTypeId = loginRes?.userTypeId ?? '';

      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': userTypeId,
      };

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success('Request Body: ${jsonEncode(body)}');
      Logger.success('Request URL: $fullUrl');
      Logger.success('Response from Profile API: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];

          // ✅ Personal Info
          _firstName = data['firstname'];
          _lastName = data['lastname'];
          _email = data['email'];
          _phone = data['phone_no'];
          _gender = data['gender'];
          _dob = data['dob'];
          _fullAddress = data['address'];

          // ✅ Location Info
          _country = data['country'];
          _state = data['state'];
          _city = data['city'];
          _zipCode = data['pincode'];

          // ✅ Documents (with proper URL formatting)
          _profilePic = _formatUrl(data['profile_pic']);
          _bankPassbook = _formatUrl(data['bank_passbook']);
          _panCard = _formatUrl(data['pan_card']);
          _aadharCard = _formatUrl(data['aadhar_card']);
          _votingCard = _formatUrl(data['voting_card']);
          _idProof =
              _formatUrl(data['id_proof']); // keep optional if not provided

          // ✅ Other fields (if available)
          _compCheck = data['comp_chek']; // optional if still used
          _customerType = data['customer_type']; // optional if exists

          Logger.success('Personal Details loaded successfully');
        } else {
          _errorMessage = decoded['message'] ?? 'Unknown error occurred.';
        }
      } else {
        _errorMessage = 'Failed to fetch data. Status: ${response.statusCode}';
      }
    } catch (e, s) {
      _errorMessage = 'Failed to fetch personal details. ${e.toString()}';
      Logger.error('Error in apiGetPersonalDetails: $e\nStack trace: $s');
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
      final String fullUrl = AppUrls.getPersonalDetails;

      final loginRes = await SharedPrefHelper().getLoginResponse();
      final userTypeId = loginRes?.userTypeId ?? '';

      final Map<String, dynamic> body = {
        'userId': await _getUserId(),
        'userType': userTypeId,
      };

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      Logger.success('Request Body: ${jsonEncode(body)}');
      Logger.success('User details API URL: $fullUrl');
      Logger.success('Response from User Details API: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ Now the API returns status as boolean
        if (decoded['status'] == true) {
          final data = decoded['data'];

          // ✅ Directly extract the flat fields
          _firstName = data['firstname'];
          _lastName = data['lastname'];
          _profilePic = _formatUrl(data['profile_pic']);

          Logger.success(
            'User Details loaded successfully - Name: $_firstName $_lastName, Profile Pic: $_profilePic',
          );
        } else {
          _errorMessage = decoded['message'] ?? 'Unknown error occurred.';
        }
      } else {
        _errorMessage =
            'Failed to fetch user details. Status: ${response.statusCode}';
      }
    } catch (e, s) {
      _errorMessage = 'Failed to fetch user details. ${e.toString()}';
      Logger.error('Error in apiGetUserDetails: $e\nStack trace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCouponDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullUrl = 'https://testca.uniqbizz.com/api/customers/coupons.php';

      final body = {'userId': await _getUserId()};
      final encodeBody = jsonEncode(body);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);

      Logger.success('Response from coupons Api ${response.body}');

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

          // Count eligible coupons after parsing
          _countEligibleCoupons();

          Logger.success('Successfully parsed ${_couponsData.length} coupons');
          Logger.success('Eligible coupons count: $_eligibleCouponCount');
        } else {
          _errorMessage = jsonResponse['message'] ?? 'Failed to fetch coupons';
          Logger.error("API returned error status: ${jsonResponse['message']}");
        }
      } else {
        _errorMessage = 'HTTP Error: ${response.statusCode}';
        Logger.error('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, s) {
      _errorMessage = 'Error Fetching Coupons. Error: $e';
      Logger.error('Error Fetching coupons, Error: $e, Stacktrace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
