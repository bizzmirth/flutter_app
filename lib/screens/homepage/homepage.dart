import 'dart:convert';
import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/carousel_section.dart';
import 'package:bizzmirth_app/screens/homepage/drawer/sidenav_drawer.dart';
import 'package:bizzmirth_app/widgets/footer_section.dart';
import 'package:bizzmirth_app/widgets/header_section.dart';
import 'package:bizzmirth_app/widgets/top_selling_destinations.dart';
import 'package:bizzmirth_app/widgets/top_selling_packages.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
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
    loadUserTypes();
  }

  Future<void> loadUserTypes() async {
    try {
      final String? storedData =
          await _sharedPrefHelper.getUserDataType('user_data_type');

      if (storedData != null && storedData.isNotEmpty) {
        Logger.info("Loading user types from SharedPreferences");
        final jsonData = json.decode(storedData);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        setState(() {
          userTypes = userTypeResponse.data;
          isLoading = false;
        });

        Logger.success(
            "User types loaded from cache: ${userTypes.length} items");
      } else {
        Logger.info("No cached data found, fetching from API");
        await fetchEmployeeTypeFromAPI();
      }
    } catch (e) {
      Logger.error("Error loading user types: $e");
      await fetchEmployeeTypeFromAPI();
    }
  }

  Future<void> fetchEmployeeTypeFromAPI() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final response = await http
          .get(Uri.parse('https://testca.uniqbizz.com/api/user_type'));

      if (response.statusCode == 200) {
        Logger.info("Response from user type API: ${response.body}");
        final jsonData = json.decode(response.body);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        await _sharedPrefHelper.saveUserDataType(response.body);
        Logger.success("User types saved to SharedPreferences");

        setState(() {
          userTypes = userTypeResponse.data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load user types. Status: ${response.statusCode}';
          isLoading = false;
        });
        Logger.error("API Error: Status ${response.statusCode}");
      }
    } catch (e) {
      Logger.error("Error fetching user types from API: $e");
      setState(() {
        error = 'Error fetching user types: $e';
        isLoading = false;
      });
    }
  }

  Future<void> refreshUserTypes() async {
    Logger.info("Force refreshing user types from API");
    await fetchEmployeeTypeFromAPI();
  }

  Future<void> clearCachedUserTypes() async {
    try {
      await _sharedPrefHelper.clearUserDataType();
      setState(() {
        userTypes = [];
        isLoading = true;
      });
      Logger.info("Cached user types cleared");
    } catch (e) {
      Logger.error("Error clearing cached user types: $e");
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
    // double deviceWidth = MediaQuery.of(context).size.width;
    // Logger.info("Device Width: $deviceWidth pixels");
    return Scaffold(
      drawer: SideNavDrawer(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 81, 131, 246),
        title: Text(
          'Bizzmirth Holidays Pvt. Ltd.',
          style: Appwidget.poppinsAppBarTitle(),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh, color: Colors.white),
          //   onPressed: refreshUserTypes,
          //   tooltip: 'Refresh Data',
          // ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $error',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: refreshUserTypes,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: refreshUserTypes,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        HeaderSection(),
                        SizedBox(
                          height: 5,
                        ),
                        CarouselSection(),
                        TopSellingDestinations(),
                        TopSellingPackages(),
                        FooterSection(),
                      ],
                    ),
                  ),
                ),
    );
  }
}
