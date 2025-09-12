import 'package:bizzmirth_app/controllers/all_packages_controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/screens/more_top_selling_packages/more_top_selling_packages.dart';
import 'package:bizzmirth_app/screens/package_details_page/package_details_page.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/urls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopSellingDestinations extends StatefulWidget {
  const TopSellingDestinations({super.key});

  @override
  State<TopSellingDestinations> createState() => _TopSellingDestinationsState();
}

class _TopSellingDestinationsState extends State<TopSellingDestinations>
    with RouteAware {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowVisibility);
    _focusNode.addListener(_handleFocusChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTopTourPackages();
      _updateArrowVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register route observer if needed
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

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      // We've returned to this widget, reset scroll position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetScrollPosition();
      });
    }
  }

  // Reset scroll position when returning to this page
  void _resetScrollPosition() {
    if (_scrollController.hasClients && _scrollController.offset != 0) {
      _scrollController.jumpTo(0);
      // Force update arrow visibility after resetting scroll position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateArrowVisibility();
        }
      });
    } else {
      // Even if scroll position is already at 0, ensure arrows are updated
      _updateArrowVisibility();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Focus(
      focusNode: _focusNode,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          // Reset scroll when we return to this widget
          _resetScrollPosition();
        }
      },
      child: Consumer<TourPackagesController>(
        builder: (context, controller, child) {
          final myTrips = controller.topTourPackages;

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Our Best Selling Destinations',
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                if (controller.isLoading)
                  SizedBox(
                    height: isSmallScreen ? 130 : 150,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: isSmallScreen ? 130 : 150,
                    child: Stack(
                      children: [
                        // Main content
                        myTrips.isEmpty
                            ? _buildEmptyState(isSmallScreen)
                            : ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    myTrips.length + 1, // +1 for "View More"
                                itemBuilder: (context, index) {
                                  if (index < myTrips.length) {
                                    final trip = myTrips[index];
                                    return _buildTripCard(trip, isSmallScreen);
                                  } else {
                                    return _buildViewMoreCard(isSmallScreen);
                                  }
                                },
                              ),

                        // Left Arrow
                        if (_showLeftArrow && myTrips.isNotEmpty)
                          Positioned(
                            left: 10,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Container(
                                width: isSmallScreen ? 30 : 50,
                                height: isSmallScreen ? 30 : 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 18,
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController.offset - 200,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ),

                        // Right Arrow
                        if (_showRightArrow && myTrips.isNotEmpty)
                          Positioned(
                            right: 10,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Container(
                                width: isSmallScreen ? 30 : 50,
                                height: isSmallScreen ? 30 : 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 18,
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController.offset + 200,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: _buildViewMoreCard(isSmallScreen),
    );
  }

  Widget _buildTripCard(dynamic trip, bool isSmallScreen) {
    if (trip == null) {
      return Container(
        width: isSmallScreen ? 150 : 170,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: const Center(
          child: Text("Invalid trip data"),
        ),
      );
    }

    final imageUrl =
        trip.image != null ? "${AppUrls.getImageBaseUrl}${trip.image}" : null;

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
      child: Container(
        width: isSmallScreen ? 150 : 200,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          height: isSmallScreen ? 85 : 100,
                          width: double.infinity,
                          errorWidget: (context, error, stackTrace) {
                            Logger.error(
                                "Image load error for $imageUrl: $error");
                            return Container(
                              height: isSmallScreen ? 85 : 100,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          height: isSmallScreen ? 85 : 100,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                  // Gradient overlay for better text visibility
                  Container(
                    height: isSmallScreen ? 85 : 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Destination text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Text(
                  trip.destination ?? "Unknown Destination",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Separate method for "View More" card
  Widget _buildViewMoreCard(bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TopPackagesPage(),
          ),
        ).then((_) {
          // This callback runs when we return from the TopPackagesPage
          // Reset the scroll position and update arrow visibility
          if (mounted) {
            _resetScrollPosition();
          }
        });
      },
      child: Container(
        width: isSmallScreen ? 150 : 170,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade300, width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline,
                  color: Colors.blue.shade700, size: isSmallScreen ? 24 : 28),
              const SizedBox(height: 6),
              Text(
                "View More",
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
