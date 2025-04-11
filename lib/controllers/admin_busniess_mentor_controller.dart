import 'dart:convert';

import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminBusniessMentorController extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  final String baseUrl = 'https://testca.uniqbizz.com/api/business_mentor';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PendingBusinessMentorModel> _pendingBusinessMentorList = [];
  List<PendingBusinessMentorModel> get pendingBusmiessMentor =>
      _pendingBusinessMentorList;

  Future<void> fetchAndSavePendingBusinessMentor() async {
    try {
      _isLoading = true;
      notifyListeners();

      _pendingBusinessMentorList =
          await _isarService.getAll<PendingBusinessMentorModel>();

      final List<PendingBusinessMentorModel> apiBusinessMentor =
          await _fetchAndSavePendingBusinessMentorFromServer();
      await _isarService.clearAll<PendingBusinessMentorModel>();

      for (var businessMentor in apiBusinessMentor) {
        await _isarService.save<PendingBusinessMentorModel>(businessMentor);
      }

      _pendingBusinessMentorList = apiBusinessMentor;
    } catch (e) {
      Logger.error("Error while fetching pending business mentor : $e");
      throw Exception('Failed to fetch and save employees');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiAddBusinessMentor(
      PendingBusinessMentorModel businessMentor) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newProfilePic =
          extractPathSegment(businessMentor.profilePicture!, 'profile_pic/');
      final newAdharCard =
          extractPathSegment(businessMentor.adharCard!, 'aadhar_card/');
      final newPanCard =
          extractPathSegment(businessMentor.panCard!, 'pan_card/');
      final newBankPassbook =
          extractPathSegment(businessMentor.bankName!, 'passbook/');
      final newVotingCard =
          extractPathSegment(businessMentor.votingCard!, 'voting_card/');
      final newPaymentProof =
          extractPathSegment(businessMentor.paymentProof!, 'payment_proof');

      final fullUrl = '$baseUrl/add_business_mentor_data.php';
      formatDate(businessMentor.dob);
      final Map<String, dynamic> requestBody = {
        'user_id_name': extractUserId(businessMentor.userId!),
        'reference_name': businessMentor.refName,
        "firstname": businessMentor.firstName,
        "lastname": businessMentor.lastName,
        "nominee_name": businessMentor.nomineeName,
        "nominee_relation": businessMentor.nomineeRelation,
        "email": businessMentor.email,
        "gender": businessMentor.gender,
        "country_code": businessMentor.countryCd,
        "phone": businessMentor.phoneNumber,
        "dob": businessMentor.dob,
        "profile_pic": newProfilePic,
        "pan_card": newPanCard,
        "aadhar_card": newAdharCard,
        "voting_card": newVotingCard,
        "passbook": newBankPassbook,
        "payment_proof": newPaymentProof,
        "address": businessMentor.address,
        "pincode": businessMentor.pincode,
        "country": businessMentor.country,
        "state": businessMentor.state,
        "city": businessMentor.city,
        "zone": businessMentor.zone,
        "branch": businessMentor.branch,
        "paymentMode": businessMentor.paymentMode,
        "payment_fee": 12000
      };
      final encodeBody = json.encode(requestBody);
      _isLoading = true;
      notifyListeners();

      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("fullUrl: $fullUrl");
      Logger.success("RequestBody: $encodeBody");
      Logger.success("status code : ${response.statusCode}");
      Logger.success("API response: ${response.body}");
    } catch (e) {
      Logger.error("Error adding business Mentor : $e");
    } finally {
      _isLoading = true;
      notifyListeners();
    }
  }

  Future<void> uploadImage(
      context, String folder, String savedImagePath) async {
    try {
      final fullUrl = 'http://testca.uniqbizz.com/api/upload_mobile.php';
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', savedImagePath));
      request.fields['folder'] = folder;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      Logger.warning('Raw API response body: $responseBody');
      Logger.success("Upload Api FULL URL: $fullUrl");
      Logger.info('this is reuest $request');

      if (responseBody == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload Failed  $responseBody")));
      } else if (responseBody == '2') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid File Extension  $responseBody")));
      } else if (responseBody == '3') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No File Selected  $responseBody")));
      } else if (responseBody == '4') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File Size Exceeds 2MB  $responseBody")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload Successful: $responseBody")));
      }
    } catch (e) {
      Logger.error("Error uploading image: $e");
    }
  }

  Future<void> apiRegisterEmployee(BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // Make sure to call this to notify listeners of state change

    try {
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<PendingBusinessMentorModel>>
      _fetchAndSavePendingBusinessMentorFromServer() async {
    try {
      final fullUrl = '$baseUrl/business_mentor.php?action=pending_bm';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        Logger.info("Api Response : $jsonResponse");
        Logger.success("Full Url : $fullUrl");
        if (jsonResponse.containsKey('status') &&
            jsonResponse.containsKey('data')) {
          if (jsonResponse['status'] == 'success' &&
              jsonResponse['data'] is List) {
            final List<dynamic> dataList = jsonResponse['data'];
            Logger.success("API response -> Data list: $dataList");
            // The return statement seems to be missing here
            Logger.success("response in json encode ${jsonEncode(dataList)}");

            return dataList
                .map((json) => _pendingBusinessMentorFromJson(json))
                .toList();
          }
        }
        Logger.error('Unexpected API response format');
        return [];
      } else {
        Logger.error('Failed to load employees: ${response.statusCode}');
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error("Error while fetching pending business mentor : $e");
      throw Exception('Error fetching employee: $e');
    }
  }

  Future<List<dynamic>> apiGetZone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullUrl =
          'https://testca.uniqbizz.com/api/employees/all_employees/add_employees_zone.php';
      final response = await http.get(Uri.parse(fullUrl));
      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final zonesList = jsonData['zones'];

          final zonesData = json.encode(zonesList);
          await prefs.setString('zones', zonesData);
          Logger.success("Zones data saved to SharedPreferences");

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
      Logger.error("Error getting zones: $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetBranchs(String zoneId) async {
    try {
      final fullUrl =
          "https://testca.uniqbizz.com/api/employees/all_employees/add_employees_branch.php";
      final requestBody = {'zone_id': zoneId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

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
      Logger.error("Error getting branches: $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetCountry() async {
    try {
      final fullUrl = "https://testca.uniqbizz.com/api/country.php";

      final response = await http.get(Uri.parse(fullUrl));
      Logger.success("message");

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
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error getting countries: $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetStates(String countryId) async {
    try {
      final fullUrl = "http://testca.uniqbizz.com/api/state_city.php";
      final requestBody = {"country_id": countryId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("State Response ${response.body}");
      Logger.success("State request body $encodeBody");
      Logger.success("State response code ${response.statusCode}");

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
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error fetching States $e");
      return [];
    }
  }

  Future<List<dynamic>> apiGetCity(String stateId) async {
    try {
      final fullUrl = "http://testca.uniqbizz.com/api/state_city.php";
      final requestBody = {"state_id": stateId};
      final encodeBody = json.encode(requestBody);
      final response = await http.post(Uri.parse(fullUrl), body: encodeBody);
      Logger.success("City Response : ${response.body}");
      Logger.success("City Request Body : $encodeBody");
      Logger.success("City Full Url : $fullUrl");
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
        Logger.error("API returned error code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      Logger.error("Error fethcing cities : $e");
      return [];
    }
  }

  Future<String> apiGetPincode(String cityId) async {
    try {
      final fullUrl = "https://testca.uniqbizz.com/api/pincode.php";
      final requestBody = {'city_id': cityId};
      final encodedBody = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(fullUrl),
        body: encodedBody,
      );

      Logger.success(
          "Response Code: ${response.statusCode} Api Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          return jsonData['data']['pincode'] ?? "";
        } else {
          Logger.error("API returned success code but invalid data structure");
          return "";
        }
      } else {
        Logger.error("API returned error code: ${response.statusCode}");
        return "";
      }
    } catch (e) {
      Logger.success("Error fetching Pincode: $e");
      return "";
    }
  }

  PendingBusinessMentorModel _pendingBusinessMentorFromJson(
      Map<String, dynamic> json) {
    try {
      final businessMentor = PendingBusinessMentorModel()
        ..id = parseIntSafely(json['id'])
        ..designation = json['designation']
        ..name = '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim()
        ..firstName = json['firstname']
        ..lastName = json['lastname']
        ..nomineeName = json['nominee_name'] ?? ''
        ..nomineeRelation = json['nominee_relation'] ?? ''
        ..email = json['email'] ?? ''
        ..countryCd = json['country_code'] ?? ''
        ..phoneNumber = json['contact_no'] ?? ''
        ..dob = json['date_of_birth'] ?? ''
        ..gender = capitalize(json['gender'])
        ..country = json['country'] ?? ''
        ..state = json['state'] ?? ''
        ..city = json['city'] ?? ''
        ..pincode = json['pincode'] ?? ''
        ..address = json['address'] ?? ''
        ..paymentMode = json['payment_mode'] ?? ''
        ..chequeNo = json['cheque_no'] ?? ''
        ..chequeDate = json['cheque_date'] ?? ''
        ..bankName = json['bank_name'] ?? ''
        ..transactionNo = json['transaction_no'] ?? ''
        ..profilePicture = json['profile_pic'] ?? ''
        ..panCard = json['pan_card'] ?? ''
        ..adharCard = json['aadhar_card'] ?? ''
        ..votingCard = json['voting_card'] ?? ''
        ..bankPassbook = json['bank_passbook'] ?? ''
        ..registrant = json['registrant'] ?? ''
        ..referenceNo = json['reference_no'] ?? ''
        ..registerBy = parseIntSafely(json['register_by'])
        ..userType = parseIntSafely(json['user_type'])
        ..addedOn = json['added_on'] ?? ''
        ..registerDate = json['register_date'] ?? ''
        ..deletedDate = json['deleted_date'] ?? ''
        ..status = parseIntSafely(json['status']);
      Logger.success(
          "Saving the gender fromm server ${capitalize(json['gender'])}");

      return businessMentor;
    } catch (e) {
      Logger.error("Error parsing business mentor: $e for data: $json");
      throw Exception("Error parsing business mentor: $e");
    }
  }
}
