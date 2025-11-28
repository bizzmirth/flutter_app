import 'package:bizzmirth_app/controllers/common_controllers/home_page_controller.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/carousel_section.dart';
import 'package:bizzmirth_app/screens/homepage/drawer/sidenav_drawer.dart';
import 'package:bizzmirth_app/widgets/footer_section.dart';
import 'package:bizzmirth_app/widgets/header_section.dart';
import 'package:bizzmirth_app/widgets/membership_promotion_card.dart';
import 'package:bizzmirth_app/widgets/top_selling_destinations.dart';
import 'package:bizzmirth_app/widgets/top_selling_packages.dart';
import 'package:bizzmirth_app/widgets/video_carousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildAboutUsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: const BoxDecoration(
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
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Best Travel Experience With Bizzmirth Holidays',
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
                  offset: const Offset(0, 5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Decorative icon
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          size: 40,
                          color: Color(0xFF0A3D62),
                        ),
                      ),

                      // Company description
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C3E50),
                            height: 1.6,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: 'Bizzmirth Holidays Pvt. Ltd.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A3D62),
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' is a premier travel industry enabler, offering entrepreneurs a comprehensive business platform designed for success.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Our integrated solutions encompass enterprise systems, inventory management, regulatory compliance, professional training, customer portfolio management, and revenue optimization. ',
                            ),
                            TextSpan(
                              text:
                                  'We deliver technology-driven strategies and expert guidance, ensuring seamless operations, sustainable growth, and enhanced profitability for our partners across the holiday and business travel sectors.',
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
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        height: 2,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF0A3D62).withValues(alpha: 0.5),
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

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    // Logger.info("Device Width: $deviceWidth pixels");
    return Consumer<HomePageController>(
      builder: (context, controller, child) {
        return Scaffold(
          drawer: const SideNavDrawer(),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 81, 131, 246),
            title: Text(
              'Bizzmirth Holidays Pvt. Ltd.',
              style: Appwidget.poppinsAppBarTitle(),
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            actions: const [
              // IconButton(
              //   icon: Icon(Icons.refresh, color: Colors.white),
              //   onPressed: refreshUserTypes,
              //   tooltip: 'Refresh Data',
              // ),
            ],
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${controller.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.refreshUserTypes,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refreshUserTypes,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const HeaderSection(),
                            const SizedBox(height: 5),
                            const CarouselSection(),
                            const SizedBox(height: 15),
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
                            const SizedBox(height: 15),
                            _buildAboutUsSection(),
                            const SizedBox(height: 15),
                            const FancyVideoSlider(),
                            const TopSellingDestinations(),
                            const TopSellingPackages(),
                            const FooterSection(),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
