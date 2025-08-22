import 'package:bizzmirth_app/controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/screens/more_top_selling_packages/more_top_selling_packages.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopSellingDestinations extends StatefulWidget {
  const TopSellingDestinations({super.key});

  @override
  _TopSellingDestinationsState createState() => _TopSellingDestinationsState();
}

class _TopSellingDestinationsState extends State<TopSellingDestinations> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTopTourPackages();
    });
  }

  void getTopTourPackages() async {
    final controller =
        Provider.of<TourPackagesController>(context, listen: false);
    controller.apiGetTourPackages();
  }

  void _updateArrowVisibility() {
    if (!_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;

    setState(() {
      _showLeftArrow = currentOffset > 0;
      _showRightArrow = currentOffset < maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TourPackagesController>(
      builder: (context, controller, child) {
        final myTrips = controller.topTourPackages;

        // Logger.success("My top trips are $myTrips");
        // Logger.info("Trip count: ${myTrips.length}");
        // Logger.info("Controller loading state: ${controller.isLoading}");

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Our Best Selling Destinations',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 16),
              if (controller.isLoading)
                SizedBox(
                  height: 150,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      // Left Arrow
                      if (_showLeftArrow)
                        IconButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset - 200,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back,
                              size: 24, color: Colors.black),
                        ),

                      Expanded(
                        child: myTrips.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    myTrips.length + 1, // +1 for "View More"
                                itemBuilder: (context, index) {
                                  if (index < myTrips.length) {
                                    final trip = myTrips[index];
                                    return _buildTripCard(trip);
                                  } else {
                                    return _buildViewMoreCard();
                                  }
                                },
                              ),
                      ),

                      // Right Arrow
                      if (_showRightArrow && myTrips.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset + 200,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward,
                              size: 24, color: Colors.black),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: _buildViewMoreCard(),
    );
  }

  Widget _buildTripCard(dynamic trip) {
    if (trip == null) {
      return Container(
        width: 190,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: const Center(
          child: Text("Invalid trip data"),
        ),
      );
    }

    final imageUrl =
        trip.image != null ? "https://ca.uniqbizz.com/${trip.image}" : null;

    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                    errorWidget: (context, error, stackTrace) {
                      Logger.error("Image load error for $imageUrl: $error");
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                    // pla
                  )
                : Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),

            // Destination text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                trip.destination ?? "Unknown Destination",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Separate method for "View More" card
  Widget _buildViewMoreCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TopPackagesPage(),
          ),
        );
      },
      child: Container(
        width: 190,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blueAccent),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.blueAccent, size: 30),
              SizedBox(height: 8),
              Text(
                "View More",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
