import 'dart:convert';
import 'package:bizzmirth_app/models/user_type_mode.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:bizzmirth_app/widgets/carousel_section.dart';
import 'package:bizzmirth_app/screens/homepage/drawer/sidenav_drawer.dart';
import 'package:bizzmirth_app/widgets/footer_section.dart';
import 'package:bizzmirth_app/widgets/header_section.dart';
import 'package:bizzmirth_app/widgets/membership_promotion_card.dart';
import 'package:bizzmirth_app/widgets/top_selling_destinations.dart';
import 'package:bizzmirth_app/widgets/top_selling_packages.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/video_carousel.dart';
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

  Widget _buildAboutUsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 81, 131, 246), // Your specified color
            Color.fromARGB(
                255, 59, 109, 224), // Slightly darker variant for gradient
          ],
          stops: [0.1, 0.9],
        ),
      ),
      child: Column(
        children: [
          // Main Heading with improved design
          Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Best Travel Experience With Bizzmirth Holidays",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 0.5,
                fontFamily:
                    'Poppins', // You'll need to add this font to your project
              ),
            ),
          ),

          // Main Content Container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Color(0xFFE6F2FF),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decorative icon
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Icon(
                          Icons.flight_takeoff_rounded,
                          size: 40,
                          color: Color(0xFF0A3D62),
                        ),
                      ),

                      // Company description
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C3E50),
                            height: 1.6,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: "Bizzmirth Holidays Pvt. Ltd.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A3D62),
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " is a premier travel industry enabler, offering entrepreneurs a comprehensive business platform designed for success.\n\n",
                            ),
                            TextSpan(
                              text:
                                  "Our integrated solutions encompass enterprise systems, inventory management, regulatory compliance, professional training, customer portfolio management, and revenue optimization. ",
                            ),
                            TextSpan(
                              text:
                                  "We deliver technology-driven strategies and expert guidance, ensuring seamless operations, sustainable growth, and enhanced profitability for our partners across the holiday and business travel sectors.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF1A5276),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Decorative divider
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25),
                        height: 2,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFF0A3D62).withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      final String url = AppUrls.getAllUserTypes;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Logger.info("Response from user type API: ${response.body}");
        final jsonData = json.decode(response.body);
        final userTypeResponse = UserTypeResponse.fromJson(jsonData);

        await _sharedPrefHelper.saveUserDataType(response.body);
        Logger.success("Get all usertype URL: $url ");
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
                        SizedBox(
                          height: 15,
                        ),
                        MembershipPromotionCard(
                          isForFreeUser:
                              false, // This shows "Start Your Journey With Us"
                          onPlanSelected: (planName) {
                            // Navigate to a signup page or show a dialog for visitors
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             SignUpPage(selectedPlan: planName)));
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildAboutUsSection(),
                        SizedBox(
                          height: 15,
                        ),
                        FancyVideoSlider(),
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
