import 'package:bizzmirth_app/controllers/all_packages_controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/screens/more_top_selling_packages/more_top_selling_packages.dart';
import 'package:bizzmirth_app/screens/package_details_page/package_details_page.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopSellingPackages extends StatefulWidget {
  const TopSellingPackages({super.key});

  @override
  State<TopSellingPackages> createState() => _TopSellingPackagesState();
}

class _TopSellingPackagesState extends State<TopSellingPackages> {
  int visibleTripsCount = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBestDealsPackages();
    });
  }

  Future<void> getBestDealsPackages() async {
    final controller =
        Provider.of<TourPackagesController>(context, listen: false);
    await controller.apiGetBestDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TourPackagesController>(
        builder: (context, controller, child) {
      final bestDeals = controller.bestDealPackages;

      // Precache images when they become available
      if (bestDeals.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          for (final trip in bestDeals) {
            final imageUrl = '${AppUrls.getImageBaseUrl}${trip.image}';
            precacheImage(NetworkImage(imageUrl), context);
          }
        });
      }

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
            const SizedBox(height: 16),
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (bestDeals.isEmpty)
              const Center(
                child: Text(
                  'No best deals available at the moment',
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              ...bestDeals.map((trip) {
                final imageUrl = '${AppUrls.getImageBaseUrl}${trip.image}';
                // Logger.success('Top selling package image URL: $imageUrl');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackageDetailsPage(
                          id: trip.id ?? '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            memCacheWidth:
                                (MediaQuery.of(context).size.width * 2).toInt(),
                            placeholder: (context, url) => Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image failed to load',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.destination ?? 'Destination',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trip.name ?? 'Package',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Starts From ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '₹${trip.totalPackagePricePerAdult}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PackageDetailsPage(
                                                  id: trip.id!,
                                                )),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                    ),
                                    child: const Text('View Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TopPackagesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 81, 131, 246),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: const Text('View More'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
