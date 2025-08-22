import 'package:bizzmirth_app/controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/models/travel_plan_top_selling_packages.dart';
import 'package:bizzmirth_app/screens/more_top_selling_packages/more_top_selling_packages.dart';
import 'package:bizzmirth_app/screens/package_details_page/package_details_page.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopSellingPackages extends StatefulWidget {
  const TopSellingPackages({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TopSellingPackagesState createState() => _TopSellingPackagesState();
}

class _TopSellingPackagesState extends State<TopSellingPackages> {
  int visibleTripsCount = 2;

  final List<TravelPlanTopSellingPackages> myTrips = [
    TravelPlanTopSellingPackages(
      destination: "Paris, France",
      image: 'assets/paris.jpg',
      description:
          'Join us on an unforgettable trip to Paris! Experience the best of French culture, food, and history.',
      price: "40,000",
    ),
    TravelPlanTopSellingPackages(
      destination: "Bali, Indonesia",
      image: 'assets/bali.jpg',
      description:
          'Discover the serene beaches and rich culture of Bali, Indonesia.',
      price: "20,000",
    ),
    TravelPlanTopSellingPackages(
      destination: "New York, USA",
      image: 'assets/newyork.jpg',
      description:
          'Explore the vibrant city of New York, from Times Square to Central Park.',
      price: "1,00,000",
    ),
    TravelPlanTopSellingPackages(
      destination: "Tokyo, Japan",
      image: 'assets/tokyo.jpg',
      description:
          'Experience the perfect blend of traditional and modern culture in Tokyo.',
      price: "2,00,000",
    ),
    TravelPlanTopSellingPackages(
      destination: "Santorini, Greece",
      image: 'assets/santorini.jpg',
      description:
          'Enjoy the beautiful sunset views and whitewashed buildings of Santorini.',
      price: "1,50,000",
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBestDealsPackages();
    });
  }

  void getBestDealsPackages() async {
    final controller =
        Provider.of<TourPackagesController>(context, listen: false);
    controller.apiGetBestDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TourPackagesController>(
        builder: (context, controller, child) {
      final bestDeals = controller.bestDealPackages;

      // Logger.success("My top trips are $bestDeals");
      // Logger.info("Trip count: ${bestDeals.length}");
      // Logger.info("Controller loading state: ${controller.isLoading}");

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best Deals On The Top Selling Packages',
              style: GoogleFonts.poppins(
                fontSize: 26, // Increased font size for better readability
                fontWeight: FontWeight.w700, // Bold weight for prominence
                color: const Color.fromARGB(
                    255, 0, 0, 0), // White font color for contrast
              ),
            ),
            ...bestDeals.map((trip) {
              final imageUrl = "https://ca.uniqbizz.com/${trip.image}";
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 180,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        trip.destination!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        trip.name!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${trip.totalPackagePricePerAdult}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PackageDetailsPage(
                                          id: trip.id!,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Text('View Tour Details'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TopPackagesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 81, 131, 246),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5, // Slight shadow for better UI feel
                ),
                child: Text('View More'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
