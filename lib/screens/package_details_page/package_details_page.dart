import 'dart:ui';

import 'package:bizzmirth_app/controllers/package_details_controller.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/info_row.dart';
import 'package:bizzmirth_app/widgets/price_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailsPage extends StatefulWidget {
  final String id;
  const PackageDetailsPage({required this.id, super.key});

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  int currentIndex = 0;
  String? customerType;

  void getShredPrefData() async {
    customerType = await SharedPrefHelper().getUserType();
    setState(() {});
  }

  Future<void> _launchWhatsApp() async {
    const String phoneNumber = "+919112017081";
    const String message = "Hi, I'm interested in the tour package details.";

    final String whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        final String fallbackUrl = "https://wa.me/$phoneNumber";
        if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
          await launchUrl(
            Uri.parse(fallbackUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          ToastHelper.showErrorToast(
              context: context,
              title: "WhatsApp not found",
              description: "WhatsApp is not installed in this device");
        }
      }
    } catch (e) {
      ToastHelper.showErrorToast(
          context: context, title: "Error opening WhatsApp: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPackageDetails();
      getShredPrefData();
    });
  }

  void getPackageDetails() async {
    final controller =
        Provider.of<PackageDetailsController>(context, listen: false);
    controller.getPackageDetails(packageId: widget.id);

    // Precache images after data is loaded
    if (controller.packageResponse != null) {
      final pictures = controller.packageResponse!.packagePictures;
      for (var picture in pictures) {
        final url = picture.getFullImageUrl();
        precacheImage(NetworkImage(url), context);
      }
    }
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageDetailsController>(
        builder: (context, controller, child) {
      if (controller.isLoading || controller.packageResponse == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Package Details"),
            backgroundColor: const Color.fromARGB(255, 81, 131, 246),
            centerTitle: true,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final pictures = controller.packageResponse!.packagePictures;
      final itemCount = pictures.length;
      final itinerarys = controller.packageResponse?.packageItinerary.first;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Package Details',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 81, 131, 246),
          centerTitle: true,
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                color: const Color.fromARGB(255, 236, 236, 236),
                child: Stack(
                  children: [
                    carousel_slider.CarouselSlider.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index, realIndex) {
                        bool isActive = index == currentIndex;
                        final picture = pictures[index];
                        final imageUrl = picture.getFullImageUrl();

                        return ClipRRect(
                          borderRadius:
                              BorderRadius.circular(itemCount > 1 ? 12 : 0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                memCacheWidth:
                                    (MediaQuery.of(context).size.width * 2)
                                        .toInt(),
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                              if (!isActive && itemCount > 1)
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      options: carousel_slider.CarouselOptions(
                        autoPlay: itemCount > 1,
                        autoPlayInterval: const Duration(seconds: 5),
                        enlargeCenterPage: itemCount > 1,
                        aspectRatio: 16 / 9,
                        viewportFraction: itemCount > 1 ? 0.7 : 1.0,
                        enableInfiniteScroll: itemCount > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Tour Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  controller.packageDetails?.name ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Location and Duration
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side (Info Items)
                    Expanded(
                      child: Wrap(
                        alignment:
                            WrapAlignment.start, // ✅ keeps items left aligned
                        spacing: 16, // horizontal space between items
                        runSpacing: 8, // vertical space when wrapped
                        children: [
                          InfoRow(
                            icon: Icons.location_on,
                            iconColor: Colors.teal,
                            text: controller.packageDetails!.name,
                          ),
                          InfoRow(
                            icon: Icons.timer,
                            iconColor: Colors.teal,
                            text: formatTourDuration(
                                controller.packageDetails!.tourDays),
                          ),
                          InfoRow(
                            icon: Icons.landscape,
                            iconColor: Colors.teal,
                            text: controller.packageDetails!.sightseeingType,
                          ),
                          InfoRow(
                            icon: Icons.directions_car,
                            iconColor: Colors.teal,
                            text:
                                (controller.packageResponse?.packageVehicles ??
                                        [])
                                    .join(", "),
                          ),
                          InfoRow(
                            icon: Icons.hotel,
                            iconColor: Colors.teal,
                            text: (controller.packageResponse
                                        ?.packageOccupancyType ??
                                    [])
                                .join(", "),
                          ),
                          InfoRow(
                            icon: Icons.restaurant,
                            iconColor: Colors.teal,
                            text:
                                (controller.packageResponse?.packageMeals ?? [])
                                    .where((meal) => !meal.contains(
                                        '+')) // Filter out items containing '+'
                                    .join(", "),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const Divider(thickness: 1, height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PriceRow(
                    label: 'Starting From:',
                    price: '',
                  ),
                  PriceRow(
                      label: 'Per Adult Price:',
                      price:
                          '₹${controller.packagePrice!.totalPackagePricePerAdult}/-',
                      icon: Icons.person),
                  PriceRow(
                      label: 'Per Child Price:',
                      price:
                          '₹${controller.packagePrice!.totalPackagePricePerChild}/-',
                      icon: Icons.child_care),
                ],
              ),
              const Divider(thickness: 1, height: 32),
              // About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tour Description',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.packageDetails!.description,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmallScreen =
                        constraints.maxWidth < 600; // breakpoint

                    if (isSmallScreen) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _buildInfoCard(
                              title: 'Included',
                              content:
                                  formatItineraryText(itinerarys?.inclusion)
                                      .join("\n"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: _buildInfoCard(
                              title: 'Excluded',
                              content:
                                  formatItineraryText(itinerarys?.exclusion)
                                      .join("\n"),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Included',
                              content:
                                  formatItineraryText(itinerarys?.inclusion)
                                      .join("\n"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Excluded',
                              content:
                                  formatItineraryText(itinerarys?.exclusion)
                                      .join("\n"),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),

              const Divider(thickness: 1, height: 32),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'Tour Plan',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.packageResponse!.packageTourPlan.length,
                itemBuilder: (context, index) {
                  final item =
                      controller.packageResponse!.packageTourPlan[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            "${item.day} : ${item.title}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                item.dayDetails,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      children: [
                                        const TextSpan(
                                          text: "Meal: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: item.mealPlan),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      children: [
                                        const TextSpan(
                                          text: "Transport: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: item.dayTransport),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, height: 32),

              // Remarks Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remarks',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatItineraryText(itinerarys?.remark).join("\n"),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 32),
              const SizedBox(height: 100),
            ]),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  tooltip: "Whatsapp",
                  onPressed: _launchWhatsApp,
                  backgroundColor: Colors.green,
                  heroTag: "whatsapp",
                  child: const FaIcon(FontAwesomeIcons.whatsapp,
                      color: Colors.white),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  tooltip: "Share",
                  onPressed: () {
                    // Add share functionality
                  },
                  backgroundColor: Colors.blue,
                  heroTag: "share",
                  child: const Icon(Icons.share, color: Colors.white),
                ),
              ],
            ),
          ),
          if (customerType != 'Customer')
            Positioned(
              bottom: 20, // Adjust as needed
              left: MediaQuery.of(context).size.width * 0.25,
              right: MediaQuery.of(context).size.width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  ToastHelper.showContactToast(
                    context: context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(
                      255, 46, 122, 244), // Orange color for customer
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Inquire Now For Best Deals",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          if (customerType == 'Customer')
            Positioned(
              bottom: 20, // Adjust as needed
              left: MediaQuery.of(context).size.width * 0.25,
              right: MediaQuery.of(context).size.width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  ToastHelper.showInfoToast(
                      context: context,
                      title:
                          "Kindly Contact Your Travel Consultant to request Quotation Details");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(
                      255, 46, 122, 244), // Orange color for customer
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Request Quotation",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
        ]),
      );
    });
  }
}
