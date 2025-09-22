import 'dart:convert';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/models/travel_counsaltant_userId_name.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminCustomerController extends ChangeNotifier {
  final String baseUrl = 'https://testca.uniqbizz.com/api/customers';

  bool _isLoading = false; // ✅ Private variable
  bool get isLoading => _isLoading; // ✅ Getter

  List<PendingCustomer> _pendingCustomer = [];
  List<PendingCustomer> get pendingCustomer => _pendingCustomer;

  List<RegisteredCustomer> _registeredCustomer = [];
  List<RegisteredCustomer> get registeredCustomer => _registeredCustomer;

  List<TravelConsultant> _consultants = [];

  List<TravelConsultant> get consultants => _consultants;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<List<PendingCustomer>> apifetchPendingEmployee() async {
    List<PendingCustomer> customers = [];

    try {
      setLoading(true);

      final fullUrl = '$baseUrl/customers.php?action=pending_cust';
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );

      Logger.success('Fetched Pending customer ${response.body}');

      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        customers = (jsonData['data'] as List)
            .map((item) => PendingCustomer.fromJson(item))
            .toList();
        _pendingCustomer = customers;
        notifyListeners();
      } else {
        Logger.error('Unexpected response format or empty data.');
      }
    } catch (e, s) {
      Logger.error(
          'Error fetching pending customer, Error: $e, Stacktrace: $s');
    } finally {
      setLoading(false);
    }

    return customers;
  }

  Future<List<RegisteredCustomer>> apiFetchRegisteredCustomer() async {
    List<RegisteredCustomer> customers = [];

    try {
      setLoading(true);
      final fullUrl = '$baseUrl/customers.php?action=registered_cust';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );
      Logger.success('Fetched Registered Customer: ${response.body}');

      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        customers = (jsonData['data'] as List)
            .map((item) => RegisteredCustomer.fromJson(item))
            .toList();
        _registeredCustomer = customers;
        notifyListeners();
      } else {
        Logger.error(
            'Unexpected response format or empty data ${response.body}');
      }
    } catch (e, s) {
      Logger.error(
          'Error fetching registered customer, Error $e, Stacktrace $s');
    } finally {
      setLoading(false);
    }

    return customers;
  }

  Future<void> refreshData() async {
    await apifetchPendingEmployee();
    await apiFetchRegisteredCustomer();
  }

  Future<void> fetchTravelConsultants() async {
    final url = Uri.parse(
        'https://testca.uniqbizz.com/api/travel_consultant/travel_consultant.php?action=registered_tc');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        _consultants = (data['data'] as List)
            .map((json) => TravelConsultant.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      Logger.error('Error fetching consultants: $e');
    }
  }

  Future<List<dynamic>> apiGetCountry() async {
    try {
      final fullUrl = 'https://testca.uniqbizz.com/api/country.php';

      final response = await http.get(Uri.parse(fullUrl));
      Logger.success('message');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error('API returned error code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Logger.error('Error getting countries: $e');
      return [];
    }
  }

  Future<List<dynamic>> apiGetStates(String countryId) async {
    try {
      final fullUrl = 'http://testca.uniqbizz.com/api/state_city.php';
      final requestBody = {'country_id': countryId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('State Response ${response.body}');
      Logger.success('State request body $encodeBody');
      Logger.success('State response code ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error('API returned error code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Logger.error('Error fetching States $e');
      return [];
    }
  }

  Future<List<dynamic>> apiGetCity(String stateId) async {
    try {
      final fullUrl = 'http://testca.uniqbizz.com/api/state_city.php';
      final requestBody = {'state_id': stateId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('City Response : ${response.body}');
      Logger.success('City Request Body : $encodeBody');
      Logger.success('City Full Url : $fullUrl');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return jsonData['data'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      } else {
        Logger.error('API returned error code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Logger.error('Error fethcing cities : $e');
      return [];
    }
  }

  Future<List<dynamic>> apiGetZone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullUrl =
          'https://testca.uniqbizz.com/api/employees/all_employees/add_employees_zone.php';
      final response = await http.get(Uri.parse(fullUrl));
      Logger.success(
          'Response Code: ${response.statusCode} Api Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final zonesList = jsonData['zones'];

          final zonesData = json.encode(zonesList);
          await prefs.setString('zones', zonesData);
          Logger.success('Zones data saved to SharedPreferences');

          // Return the zones list directly
          return zonesList;
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      }
      return [];
    } catch (e) {
      Logger.error('Error getting zones: $e');
      return [];
    }
  }

  Future<String> apiGetPincode(String cityId) async {
    try {
      final fullUrl = 'https://testca.uniqbizz.com/api/pincode.php';
      final requestBody = {'city_id': cityId};
      final encodedBody = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodedBody,
      );

      Logger.success(
          'Response Code: ${response.statusCode} Api Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          return jsonData['data']['pincode'] ?? '';
        } else {
          Logger.error('API returned success code but invalid data structure');
          return '';
        }
      } else {
        Logger.error('API returned error code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      Logger.success('Error fetching Pincode: $e');
      return '';
    }
  }

  Future<List<dynamic>> apiGetBranchs(String zoneId) async {
    try {
      final fullUrl =
          'https://testca.uniqbizz.com/api/employees/all_employees/add_employees_branch.php';
      final requestBody = {'zone_id': zoneId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success(
          'Response Code: ${response.statusCode} Api Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          // Return the branches list directly
          return jsonData['branches'];
        } else {
          Logger.error(
              "API returned success code but status was not 'success'");
          return [];
        }
      }
      return [];
    } catch (e) {
      Logger.error('Error getting branches: $e');
      return [];
    }
  }

  Future<void> uploadImage(
      context, String folder, String savedImagePath) async {
    try {
      final fullUrl = 'http://testca.uniqbizz.com/api/upload_mobile.php';
      final request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', savedImagePath));
      request.fields['folder'] = folder;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Logger.warning('Raw API response body: $responseBody');
      Logger.success('Upload Api FULL URL: $fullUrl');
      Logger.info('this is reuest $request');

      if (responseBody == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload Failed  $responseBody')));
      } else if (responseBody == '2') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid File Extension  $responseBody')));
      } else if (responseBody == '3') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No File Selected  $responseBody')));
      } else if (responseBody == '4') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File Size Exceeds 2MB  $responseBody')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload Successful: $responseBody')));
      }
    } catch (e) {
      Logger.error('Error uploading image: $e');
    }
  }

  Future<void> apiAddCustomer(PendingCustomer customer) async {
    try {
      setLoading(true);
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
          extractPathSegment(customer.paymentProof ?? '', 'payment_proof');

      final fullUrl = '$baseUrl/add_customers_data.php';
      final now = DateTime.now();
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final Map<String, dynamic> requestBody = {
        'ca_customer_id': null,
        'ta_reference_name': customer.taReferenceName,
        'ta_reference_no': customer.taReferenceNo,
        'comp_chek': customer.compChek,
        'firstname': customer.firstname,
        'lastname': customer.lastname,
        'nominee_name': customer.nomineeName,
        'nominee_relation': customer.nomineeRelation,
        'email': customer.email,
        'country_code': customer.countryCd,
        'contact_no': customer.phoneNumber,
        'date_of_birth': customer.dob,
        'age': calculateAge(customer.dob!),
        'gender': customer.gender,
        'country': customer.country,
        'state': customer.state,
        'city': customer.city,
        'pincode': customer.pincode,
        'address': customer.address,
        'profile_pic': newProfilePic,
        'pan_card': newPanCard,
        'aadhar_card': newAdharCard,
        'voting_card': newVotingCard,
        'passbook': newBankPassbook,
        'payment_proof': newPaymentProof,
        'payment_mode': customer.paymentMode,
        'paid_amount': customer.paidAmount,
        'cheque_no': customer.chequeNo,
        'cheque_date': customer.chequeDate,
        'bank_name': customer.bankName,
        'transaction_no': customer.transactionNo,
        'note': customer.note,
        'status': customer.status,
        'user_type': '10',
        'customer_type': customer.customerType,
        'added_on': formattedDateTime,
        'deleted_date': null,
        'register_date': 'N/A',
        'reference_no': null,
        'register_by': ''
      };
      final encodeBody = json.encode(requestBody);

      Logger.warning('The request body is $encodeBody');

      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success('fullUrl: $fullUrl');
      Logger.success('RequestBody: $encodeBody');
      Logger.success('status code : ${response.statusCode}');
      Logger.success('API response: ${response.body}');
    } catch (e, s) {
      Logger.error('Error adding customer: Error: $e, Stacktrace: $s');
    } finally {
      setLoading(false);
    }
  }
}
