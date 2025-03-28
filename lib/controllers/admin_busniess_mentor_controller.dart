import 'dart:convert';

import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminBusniessMentorController extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  final String baseUrl = 'https://testca.uniqbizz.com/api/business_mentor';

  bool isLoading = false;
  List<PendingBusinessMentorModel> _pendingBusinessMentorList = [];
  List<PendingBusinessMentorModel> get pendingBusmiessMentor =>
      _pendingBusinessMentorList;

  Future<void> fetchAndSavePendingBusinessMentor() async {
    try {
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
            // return dataList
            //     .map((json) => _pendingBusinessMentor(json))
            //     .toList();
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

  // PendingBusinessMentorModel _pendingBusinessMentorFromJson(Map<String, dynamic> json) {
  //   try {
  //     final businessMentor = PendingBusinessMentorModel()
  //       ..id = _parseIntSafely(json['id'])
  //       ..designation = ''
  //       ..name = '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim()
  //       ..nomineeName = json['nominee_name'] ?? ''
  //       ..nomineeRelation = json['nominee_relation'] ?? ''
  //       ..email = json['email'] ?? ''
  //       ..countryCd = json['country_code'] ?? ''
  //       ..phoneNumber = json['contact_no'] ?? ''
  //       ..dob = json['date_of_birth'] ?? ''
  //       ..gender = json['gender'] ?? ''
  //       ..country = json['country'] ?? ''
  //       ..state = json['state'] ?? ''
  //       ..city = json['city'] ?? ''
  //       ..pincode = json['pincode'] ?? ''
  //       ..address = json['address'] ?? ''
  //       ..profilePicture = json['profile_pic'] ?? ''
  //       ..panCard = json['pan_card'] ?? ''
  //       ..adharCard = json['aadhar_card'] ?? ''
  //       ..votingCard = json['voting_card'] ?? ''
  //       ..bankPassbook = json['bank_passbook'] ?? ''
  //       ..registrant = json['registrant'] ?? ''
  //       ..referenceNo = json['reference_no'] ?? ''
  //       ..registerBy = json['register_by'] ?? ''
  //       ..userType = json['user_type'] ?? ''
  //       ..addedOn = json['added_on'] ?? ''
  //       ..registerDate = json['register_date'] ?? ''
  //       ..deletedDate = json['deleted_date'] ?? ''
  //       ..status = json['status'] ?? '';

  //     return businessMentor;
  //   } catch (e) {
  //     Logger.error("Error parsing business mentor: $e for data: $json");
  //     throw Exception("Error parsing business mentor: $e");
  //   }
  // }
}
