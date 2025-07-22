import 'dart:convert';
import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/widgets/carousel_section.dart';
import 'package:bizzmirth_app/screens/homepage/drawer/sidenav_drawer.dart';
import 'package:bizzmirth_app/widgets/footer_section.dart';
import 'package:bizzmirth_app/widgets/header_section.dart';
import 'package:bizzmirth_app/widgets/top_selling_destinations.dart';
import 'package:bizzmirth_app/widgets/top_selling_packages.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserType> userTypes = [];
  bool isLoading = true;
  String error = '';
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  @override
  void initState() {
    super.initState();
    fetchEmployeeType();
  }

  Future<void> fetchEmployeeType() async {
    try {
      final response = await http
          .get(Uri.parse('https://testca.uniqbizz.com/api/user_type'));

      if (response.statusCode == 200) {
        Logger.info("response from user type api: ${response.body}");
        final jsonData = json.decode(response.body);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        await _sharedPrefHelper.saveUserDataType(response.body);

        setState(() {
          userTypes = userTypeResponse.data;
        });
      } else {
        error = 'Failed to load user types. Status: ${response.statusCode}';
        Logger.error("Else Condition::error fetching users");
      }
    } catch (e) {
      Logger.error("error fetching users $e");
      setState(() {
        error = 'Error fetching user types: $e';
        isLoading = false;
      });
    }
  }

  Future<void> printSavedUserTypes() async {
    try {
      final String? storedData =
          await _sharedPrefHelper.getUserDataType('user_data_type');

      if (storedData != null) {
        final jsonData = json.decode(storedData);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        Logger.success('Saved User Types:');
        for (var userType in userTypeResponse.data) {
          Logger.info(
              'ID: ${userType.id}, Name: ${userType.name}, Ref Name: ${userType.refName}');
        }
      } else {
        Logger.warning('No saved user types found in SharedPreferences');
      }
    } catch (e) {
      Logger.error('Error retrieving saved user types: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNavDrawer(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 81, 131, 246),
        title: Text(
          'Bizzmirth Holidays Pvt. Ltd.',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            CarouselSection(),
            TopSellingDestinations(),
            TopSellingPackages(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
