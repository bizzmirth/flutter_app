// customer_controller.dart
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/entities/top_customer_refereral/top_customer_refereral_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class CustomerController extends ChangeNotifier {
  int _regCustomerCount = 0;
  bool _isLoading = false;
  String? _error;
  String? _userCustomerId;
  String? _customerType;
  String? _customerRefrenceName;
  String? _userTaReferenceNo;
  String? _userTaRefrenceName;
  String? _userRegDate;
  String? _registerCustomerTotal;
  String? _completedTourTotal;
  String? _upcomingTourTotal;
  String? _commisionEarnedTotal;
  String? _pendingCommissionTotal;

  String? _registerCustomerThisMonth;
  String? _completedTourThisMonth;
  String? _upcomingTourThisMonth;

  bool _isCheckingEmail = false;
  String? _emailError;

  bool get isCheckingEmail => _isCheckingEmail;
  String? get emailError => _emailError;
  final List<TopCustomerRefereralModel> _topCustomerRefererals = [];

  String? get registerCustomerTotal => _registerCustomerTotal;
  String? get completedTourTotal => _completedTourTotal;
  String? get upcomingTourTotal => _upcomingTourTotal;
  String? get commisionEarnedTotal => _commisionEarnedTotal;
  String? get pendingCommissionTotal => _pendingCommissionTotal;
  String? get registerCustomerThisMonth => _registerCustomerThisMonth;
  String? get completedTourThisMonth => _completedTourThisMonth;
  String? get upcomingTourThisMonth => _upcomingTourThisMonth;
  final List<RegisteredCustomer> _registeredCustomers = [];
  final List<PendingCustomer> _pendingCustomers = [];
  List<PendingCustomer> get pendingCustomers => _pendingCustomers;
  String? get customerType => _customerType;
  List<RegisteredCustomer> get registeredCustomers => _registeredCustomers;
  List<double> _chartData = [];
  List<double> get chartData => _chartData;
  String? _selectedYear;
  String? get selectedYear => _selectedYear;
  String? get userRegDate => _userRegDate;

  List<TopCustomerRefereralModel> get topCustomerRefererals =>
      _topCustomerRefererals;
  int get regCustomerCount => _regCustomerCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userCustomerId => _userCustomerId;
  String? get customerRefrenceName => _customerRefrenceName;
  String? get userTaReferenceNo => _userTaReferenceNo;
  String? get userTaRefrenceName => _userTaRefrenceName;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setUserRegDate(String regDate) {
    _userRegDate = regDate;
    notifyListeners();
  }

  set setUserCustomerId(String? value) {
    _userCustomerId = value;
    notifyListeners();
  }

  Future<void> checkEmail(String email) async {
    if (email.isEmpty) {
      _emailError = 'Please enter your email';
      notifyListeners();
      return;
    }

    _isCheckingEmail = true;
    notifyListeners();

    try {
      final String fullUrl = AppUrls.validateEmail;
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Logger.success("validate email full URL: $fullUrl");
        final data = jsonDecode(response.body);
        _emailError = data['status'] == true ? data['message'] : null;
      } else {
        _emailError = 'Failed to validate email';
      }
    } catch (e) {
      _emailError = 'Error connecting to server $e';
      Logger.error("Error checking email: $e");
    }

    _isCheckingEmail = false;
    notifyListeners();
  }

  void clearEmailError() {
    _emailError = null;
    notifyListeners();
  }

  Future<void> getRegCustomerCount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String email = await SharedPrefHelper().getUserEmail() ?? "";
      final String url = AppUrls.registeredCustomers;
      Logger.success("the stored email is $email");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          List<dynamic> customers = jsonData['data'];

          for (var customer in customers) {
            if (customer['email'] == email) {
              _userTaReferenceNo = customer['ta_reference_no'];
              _userCustomerId = customer['ca_customer_id'];
              _customerRefrenceName =
                  '${customer['firstname']} ${customer['lastname']}';
              _userRegDate = customer['register_date'];
              _userTaRefrenceName = customer['ta_reference_name'];
              _userTaReferenceNo = customer['ta_reference_no'];
              _customerType = customer['customer_type'];
              await SharedPrefHelper().saveCustomerType(_customerType!);
              await SharedPrefHelper().saveCurrentUserCustId(_userCustomerId!);
              await SharedPrefHelper().saveCurrentUserRegDate(_userRegDate!);
              setUserCustomerId = _userCustomerId;

              Logger.success("Get customer count URL: $url");
              Logger.success(
                  "Found user with ca_customer_id: $_userCustomerId");
              Logger.success("User's ta_reference_no: $_userTaReferenceNo");
              Logger.success("Customer type: $_customerType");
              Logger.success("Registration date: $_userRegDate");
              break;
            }
          }

          if (_userCustomerId != null) {
            int count = 0;
            for (var customer in customers) {
              if (customer['reference_no'] == _userCustomerId) {
                count++;
              }
            }

            _regCustomerCount = count;

            Logger.success(
                "Total customers with ta_reference_no '$_userTaReferenceNo': $_regCustomerCount");
          } else {
            Logger.error("No customer found with email: $email");
            _regCustomerCount = 0;
            _error = "No customer found with email: $email";
          }
        } else {
          Logger.error("API returned error status: ${jsonData['status']}");
          _error = "API returned error status: ${jsonData['status']}";
        }
      } else {
        Logger.error("HTTP Error: ${response.statusCode} - ${response.body}");
        _error = "HTTP Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      Logger.error("Error in getRegCustomerCount: $e");
      _regCustomerCount = 0;
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDashboardStatCounts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final String fullUrl = AppUrls.dashboardCounts;
      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final Map<String, dynamic> body = {
        "userId": userId,
      };
      final encodeBody = json.encode(body);

      Logger.warning("Request body for dashboard counts: $body");
      final response = await http.post(Uri.parse(fullUrl),
          body: encodeBody, headers: {"Content-Type": "application/json"});
      Logger.success("Dashboard counts response: ${response.body}");
      Logger.success("Dashboard counts URL: $fullUrl");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          _registerCustomerTotal =
              data['registered_customers']['total'].toString();
          _registerCustomerThisMonth =
              data['registered_customers']['this_month'].toString();

          _completedTourTotal = data['completed_tours']['total'].toString();
          _completedTourThisMonth =
              data['completed_tours']['this_month'].toString();

          _upcomingTourTotal = data['upcoming_tours']['total'].toString();
          _upcomingTourThisMonth =
              data['upcoming_tours']['this_month'].toString();

          _commisionEarnedTotal =
              data['commission_earned']['confirmed'].toString();
          _pendingCommissionTotal =
              data['commission_earned']['pending'].toString();
        } else {
          _error = "No data found";
          Logger.error("API responded with no data ${responseData['message']}");
        }
      } else {
        _error = 'HTTP Error: ${response.statusCode}';
        Logger.error("HTTP Error: ${response.statusCode}");
      }
    } catch (e, s) {
      Logger.error("Error in getDashboardData: $e\n Stacktree: $s");
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetChartData(String selectedYear) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final String url = AppUrls.dashboardChartsData;
      _selectedYear = selectedYear;

      final Map<String, dynamic> body = {
        "year": selectedYear,
        "current_year": 2025,
        "current_month": 12,
        "user_id": userId,
        "user_type": "10",
      };

      Logger.warning("Request body: $body");
      final encodeBody = json.encode(body);
      Logger.warning("Encoded body: $encodeBody");

      final response = await http.post(
        Uri.parse(url),
        body: encodeBody,
        headers: {"Content-Type": "application/json"}, // Important!
      );
      Logger.success("Get chart data URL: $url");
      Logger.success("Raw response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is List) {
          // We got [[0,0,0,...]]
          List<dynamic> dataArray = jsonData[0];

          _chartData = dataArray
              .map<double>((item) => (item as num).toDouble())
              .toList();
          Logger.success(
              "Chart data fetched successfully for year $selectedYear");
          Logger.info("Chart data: $_chartData");
        } else {
          _error = "Unexpected response format";
          _chartData = List.filled(12, 0.0);
          Logger.error("Unexpected response format: $jsonData");
        }
      }
    } catch (e, s) {
      Logger.error("Exception in apiGetChartData: $e\n$s");
      _error = "Exception: $e";
      _chartData = List.filled(12, 0.0);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FlSpot> getChartSpots() {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int limit = selectedYear == currentYear.toString()
        ? currentMonth
        : _chartData.length;

    List<FlSpot> spots = [];

    for (int i = 0; i < limit && i < _chartData.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), _chartData[i]));
    }

    return spots;
  }

  Future<void> apiGetTopCustomerRefererals() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = await SharedPrefHelper().getCurrentUserCustId();

      final String url = AppUrls.topCustomerReferrals;

      final Map<String, dynamic> body = {"userId": _userCustomerId ?? userId};
      Logger.warning(
          "user id from setter : $_userCustomerId and userId from shared prefs: $userId");
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          _topCustomerRefererals.clear();

          List<dynamic> dataList = jsonData['data'];
          _topCustomerRefererals.addAll(
            dataList.map((e) => TopCustomerRefereralModel.fromJson(e)).toList(),
          );

          Logger.success("Top referral list updated: $_topCustomerRefererals");
        } else {
          _error = "No data found";
          Logger.error("API responded with no data");
        }
      } else {
        _error = "HTTP error: ${response.statusCode} - ${response.body}";
        Logger.error("HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      Logger.error("Error in apiGetTopCustomerRefererals: $e\n$s");
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCustomerData() async {
    await getRegCustomerCount();
  }

  Future<void> apiGetRegisteredCustomers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final String url = AppUrls.registeredCustomers;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          _registeredCustomers.clear();

          List<dynamic> dataList = jsonData['data'];
          List<RegisteredCustomer> allCustomers =
              dataList.map((e) => RegisteredCustomer.fromJson(e)).toList();
          List<RegisteredCustomer> filteredCustomers = allCustomers
              .where((customer) => customer.referenceNo == userId)
              .toList();

          _registeredCustomers.addAll(filteredCustomers);

          for (var x in _registeredCustomers) {
            Logger.success(
                "Customer: ${x.name}, Reference No: ${x.referenceNo}");
          }
          Logger.success("Registered customer URL: $url");
        } else {
          _error = "No data found";
          Logger.error("API responded with no data");
        }
      } else {
        _error = "HTTP error: ${response.statusCode} - ${response.body}";
        Logger.error("HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      Logger.error("Error in apiGetRegisteredCustomers: $e\n$s");
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiGetPendingCustomers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = await SharedPrefHelper().getCurrentUserCustId();
      final String url = AppUrls.pendingCustomers;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        Logger.success("Pending Customer Response data: $jsonData");

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          _pendingCustomers.clear();

          List<dynamic> dataList = jsonData['data'];
          List<PendingCustomer> allCustomers =
              dataList.map((e) => PendingCustomer.fromJson(e)).toList();
          List<PendingCustomer> filteredCustomers = allCustomers
              .where((customer) => customer.referenceNo == userId)
              .toList();

          _pendingCustomers.addAll(filteredCustomers);

          for (var x in _pendingCustomers) {
            Logger.success(
                "Pending Customer: ${x.name}, Reference No: ${x.referenceNo}");
          }
          Logger.success("Pending Customer URL: $url");
        } else {
          _error = "No data found";
          Logger.error("API responded with no data");
        }
      } else {
        _error = "HTTP error: ${response.statusCode} - ${response.body}";
        Logger.error("HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e, s) {
      Logger.error("Error in apiGetPendingCustomers: $e\n$s");
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImage(String folder, String savedImagePath) async {
    try {
      final fullUrl = AppUrls.uploadImage;
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', savedImagePath));
      request.fields['folder'] = folder;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      Logger.warning('Raw API response body: $responseBody');
      Logger.success("Upload Api FULL URL: $fullUrl");
      Logger.info('this is reuest $request');

      // if (responseBody == '1') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Upload Failed  $responseBody")));
      // } else if (responseBody == '2') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Invalid File Extension  $responseBody")));
      // } else if (responseBody == '3') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("No File Selected  $responseBody")));
      // } else if (responseBody == '4') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("File Size Exceeds 2MB  $responseBody")));
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Upload Successful: $responseBody")));
      // }
    } catch (e) {
      Logger.error("Error uploading image: $e");
    }
  }

  Future<void> apiAddCustomer(PendingCustomer customer) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newProfilePic =
          extractPathSegment(customer.profilePicture!, 'profile_pic/');
      final newAdharCard =
          extractPathSegment(customer.adharCard!, 'aadhar_card/');
      final newPanCard = extractPathSegment(customer.panCard!, 'pan_card/');
      final newBankPassbook =
          extractPathSegment(customer.bankPassbook!, 'passbook/');
      final newVotingCard =
          extractPathSegment(customer.votingCard!, 'voting_card/');
      final newPaymentProof =
          extractPathSegment(customer.paymentProof ?? "", 'payment_proof');

      final fullUrl = AppUrls.addCustomer;

      String oldDob = customer.dob ?? "";
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(oldDob);
      String newDob = DateFormat("yyyy-MM-dd").format(parsedDate);

      final Map<String, dynamic> body = {
        "ta_user_id_name": customer.taReferenceNo,
        "ta_reference_name": customer.taReferenceName,
        "cu_user_id_name": customer.cuRefId,
        "cu_reference_name": customer.cuRefName,
        "firstname": customer.firstname,
        "lastname": customer.lastname,
        "nominee_name": customer.nomineeName,
        "nominee_relation": customer.nomineeRelation,
        "email": customer.email,
        "dob": newDob,
        "gender": customer.gender,
        "country_code": customer.countryCd,
        "phone": customer.phoneNumber,
        "country": customer.country,
        "state": customer.state,
        "city": customer.city,
        "pincode": customer.pincode,
        "address": customer.address,
        "profile_pic": newProfilePic,
        "isComplementary": customer.compChek,
        "aadhar_card": newAdharCard,
        "pan_card": newPanCard,
        "passbook": newBankPassbook,
        "voting_card": newVotingCard,
        "payment_proof": newPaymentProof,
        "register_by": "10",
        "registrant_id": customer.registrant,
        "paymentMode": customer.paymentMode,
        "chequeNo": customer.chequeNo,
        "chequeDate": customer.chequeDate,
        "bankName": customer.bankName,
        "transactionNo": customer.transactionNo,
        "payment_fee": customer.paidAmount,
        "userId": "undefined",
        "userType": "10",
        "editfor": "",
        "payment_label": customer.customerType,
        "customer_type": customer.customerType,
      };

      Logger.warning("Request body: $body");
      Logger.warning("Encoded body: ${jsonEncode(body)}");

      final response = await http.post(Uri.parse(fullUrl),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"});
      Logger.success("fullUrl: $fullUrl");
      Logger.success("status code : ${response.statusCode}");
      Logger.success("API response: ${response.body}");
      if (response.statusCode == 200) {
        apiGetPendingCustomers();
      }
    } catch (e) {
      Logger.error("Error in apiAddCustomer: $e");
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiUpdateCustomer(PendingCustomer customer) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newProfilePic =
          customer.profilePicture?.contains('profile_pic/') == true
              ? extractPathSegment(customer.profilePicture!, 'profile_pic/')
              : customer.profilePicture;

      final newAdharCard = customer.adharCard?.contains('aadhar_card/') == true
          ? extractPathSegment(customer.adharCard!, 'aadhar_card/')
          : customer.adharCard;

      final newPanCard = customer.panCard?.contains('pan_card/') == true
          ? extractPathSegment(customer.panCard!, 'pan_card/')
          : customer.panCard;

      final newBankPassbook =
          customer.bankPassbook?.contains('passbook/') == true
              ? extractPathSegment(customer.bankPassbook!, 'passbook/')
              : customer.bankPassbook;

      final newVotingCard =
          customer.votingCard?.contains('voting_card/') == true
              ? extractPathSegment(customer.votingCard!, 'voting_card/')
              : customer.votingCard;

      final newPaymentProof =
          customer.paymentProof?.contains('payment_proof') == true
              ? extractPathSegment(customer.paymentProof ?? "", 'payment_proof')
              : customer.paymentProof;

      final fullUrl = AppUrls.editCustomers;

      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String oldDob = customer.dob ?? "";
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(oldDob);
      String newDob = DateFormat("yyyy-MM-dd").format(parsedDate);

      final Map<String, dynamic> body = {
        "id": customer.id, // Include customer ID for update
        "ta_user_id_name": customer.taReferenceNo,
        "ta_reference_name": customer.taReferenceName,
        "cu_user_id_name": customer.cuRefId,
        "cu_reference_name": customer.cuRefName,
        "firstname": customer.firstname,
        "lastname": customer.lastname,
        "nominee_name": customer.nomineeName,
        "nominee_relation": customer.nomineeRelation,
        "email": customer.email,
        "dob": newDob,
        "gender": customer.gender,
        "country_code": customer.countryCd,
        "phone": customer.phoneNumber,
        "country": customer.country,
        "state": customer.state,
        "city": customer.city,
        "pincode": customer.pincode,
        "address": customer.address,
        "profile_pic": newProfilePic,
        "isComplementary": customer.compChek,
        "aadhar_card": newAdharCard,
        "pan_card": newPanCard,
        "passbook": newBankPassbook,
        "voting_card": newVotingCard,
        "payment_proof": newPaymentProof,
        "register_by": "10",
        "registrant_id": customer.registrant,
        "paymentMode": customer.paymentMode,
        "chequeNo": customer.chequeNo,
        "chequeDate": customer.chequeDate,
        "bankName": customer.bankName,
        "transactionNo": customer.transactionNo,
        "payment_fee": customer.paidAmount,
        "userId": "undefined",
        "userType": "10",
        "editfor": "pending",
        "payment_label": customer.customerType,
        "customer_type": customer.customerType,
        "updated_at": formattedDate,
      };

      Logger.warning("Update request body: $body");
      Logger.warning("Encoded body: ${jsonEncode(body)}");

      final response = await http.post(Uri.parse(fullUrl),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"});

      Logger.success("Update URL: $fullUrl");
      Logger.success("Update status code: ${response.statusCode}");
      Logger.success("Update API response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Logger.success("Customer updated successfully");
        } else {
          Logger.error("Update failed: ${responseData['message']}");
          _error = "Update failed: ${responseData['message']}";
        }
      } else {
        Logger.error("Update failed with status code: ${response.statusCode}");
        _error = "Update failed with status code: ${response.statusCode}";
      }
    } catch (e) {
      Logger.error("Error in apiUpdateCustomer: $e");
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiUpdateRegisteredCustomer(RegisteredCustomer customer) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newProfilePic =
          customer.profilePicture?.contains('profile_pic/') == true
              ? extractPathSegment(customer.profilePicture!, 'profile_pic/')
              : customer.profilePicture;

      final newAdharCard = customer.adharCard?.contains('aadhar_card/') == true
          ? extractPathSegment(customer.adharCard!, 'aadhar_card/')
          : customer.adharCard;

      final newPanCard = customer.panCard?.contains('pan_card/') == true
          ? extractPathSegment(customer.panCard!, 'pan_card/')
          : customer.panCard;

      final newBankPassbook =
          customer.bankPassbook?.contains('passbook/') == true
              ? extractPathSegment(customer.bankPassbook!, 'passbook/')
              : customer.bankPassbook;

      final newVotingCard =
          customer.votingCard?.contains('voting_card/') == true
              ? extractPathSegment(customer.votingCard!, 'voting_card/')
              : customer.votingCard;

      final newPaymentProof =
          customer.paymentProof?.contains('payment_proof') == true
              ? extractPathSegment(customer.paymentProof ?? "", 'payment_proof')
              : customer.paymentProof;

      final fullUrl = AppUrls.editCustomers;

      String oldDob = customer.dob ?? "";
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(oldDob);
      String newDob = DateFormat("yyyy-MM-dd").format(parsedDate);

      final Map<String, dynamic> body = {
        "ref_id": customer.referenceNo,
        "id": customer.caCustomerId,
        "firstname": customer.firstName,
        "lastname": customer.lastName,
        "email": customer.email,
        "dob": newDob,
        "gender": customer.gender,
        "country_code": customer.countryCd,
        "phone": customer.phoneNumber,
        "country": customer.country,
        "state": customer.state,
        "city": customer.city,
        "pincode": customer.pincode,
        "address": customer.address,
        "profile_pic": newProfilePic,
        "aadhar_card": newAdharCard,
        "pan_card": newPanCard,
        "passbook": newBankPassbook,
        "voting_card": newVotingCard,
        "payment_proof": newPaymentProof,
        "register_by": "10",
        "registrant_id": customer.registrant,
        "paymentMode": customer.paymentMode,
        "chequeNo": customer.chequeNo,
        "chequeDate": customer.chequeDate,
        "bankName": customer.bankName,
        "transactionNo": customer.transactionNo,
        "payment_fee": customer.paidAmount,
        "userId": customer.referenceNo,
        "ta_reference_no": customer.taReferenceNo,
        "userType": "10",
        "editfor": "registered",
        "payment_label": customer.customerType,
        "customer_type": "undefined",
      };

      Logger.warning("Update request body: $body");
      Logger.warning("Encoded body: ${jsonEncode(body)}");

      final response = await http.post(Uri.parse(fullUrl),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"});

      Logger.success("Update URL: $fullUrl");
      Logger.success("Update status code: ${response.statusCode}");
      Logger.success("Update API response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Logger.success("Customer updated successfully");
        } else {
          Logger.error("Update failed: ${responseData['message']}");
          _error = "Update failed: ${responseData['message']}";
        }
      } else {
        Logger.error("Update failed with status code: ${response.statusCode}");
        _error = "Update failed with status code: ${response.statusCode}";
      }
    } catch (e) {
      Logger.error("Error in apiUpdateCustomer: $e");
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiDeleteCustomer(
      BuildContext context, RegisteredCustomer customer) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final fullUrl = AppUrls.deleteCustomers;

      final Map<String, dynamic> body = {
        "id": customer.id,
        "fid": customer.taReferenceNo,
        "refid": customer.caCustomerId,
        "action": "registered"
      };

      final response =
          await http.post(Uri.parse(fullUrl), body: jsonEncode(body));

      Logger.success("Delete URL: $fullUrl");
      Logger.success("Delete status code: ${response.statusCode}");
      Logger.success("Delete API response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          await apiGetRegisteredCustomers();
          Logger.success("Customer deleted successfully");

          ToastHelper.showSuccessToast(
            context: context,
            title: "Success",
            description: "Customer deleted successfully",
          );
        } else {
          final errorMessage =
              responseData['message'] ?? 'Unknown error occurred';
          Logger.error("Delete failed: $errorMessage");
          _error = "Delete failed: $errorMessage";

          ToastHelper.showErrorToast(
            context: context,
            title: "Delete Failed",
            description: errorMessage,
          );
        }
      } else {
        final errorMessage = "HTTP Error: ${response.statusCode}";
        Logger.error(errorMessage);
        _error = errorMessage;

        ToastHelper.showErrorToast(
          context: context,
          title: "Network Error",
          description: "Failed to delete customer. Please try again.",
        );
      }
    } catch (e, s) {
      Logger.error("Error in apiDeleteCustomer: $e\n$s");
      _error = "Error: $e";

      ToastHelper.showErrorToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred. Please try again.",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiRestoreCustomer(context, RegisteredCustomer customer) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final fullUrl =
          AppUrls.deleteCustomers; // restores based on action provided in body

      final Map<String, dynamic> body = {
        "id": customer.id,
        "fid": customer.taReferenceNo,
        "refid": customer.caCustomerId,
        "action": "deactivate"
      };

      final response =
          await http.post(Uri.parse(fullUrl), body: jsonEncode(body));

      Logger.success("Delete URL: $fullUrl");
      Logger.success("Delete status code: ${response.statusCode}");
      Logger.success("Delete API response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          await apiGetRegisteredCustomers();
          Logger.success("Customer Restored successfully");

          ToastHelper.showSuccessToast(
            context: context,
            title: "Success",
            description: "Customer Restored successfully",
          );
        } else {
          final errorMessage =
              responseData['message'] ?? 'Unknown error occurred';
          Logger.error("Restoring failed: $errorMessage");
          _error = "Restoring failed: $errorMessage";

          ToastHelper.showErrorToast(
            context: context,
            title: "Restoring Failed",
            description: errorMessage,
          );
        }
      } else {
        final errorMessage = "HTTP Error: ${response.statusCode}";
        Logger.error(errorMessage);
        _error = errorMessage;

        ToastHelper.showErrorToast(
          context: context,
          title: "Network Error",
          description: "Failed to restore customer. Please try again.",
        );
      }
    } catch (e, s) {
      Logger.error("Error in apiRestoreCustomer: $e\n$s");
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _regCustomerCount = 0;
    _isLoading = false;
    _error = null;
    _userCustomerId = null;
    _userTaReferenceNo = null;
    notifyListeners();
  }
}
