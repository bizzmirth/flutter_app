import 'package:bizzmirth_app/models/travel_plan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopSellingDestinations extends StatefulWidget {
  const TopSellingDestinations({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TopSellingDestinationsState createState() => _TopSellingDestinationsState();
}

class _TopSellingDestinationsState extends State<TopSellingDestinations> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  final List<TravelPlanTopSellingDestinations> myTrips = [
    TravelPlanTopSellingDestinations(
      destination: "Thailand 3D 4N",
      image: 'assets/thailand.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Goa 4N",
      image: 'assets/goa.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Kerala 4N",
      image: 'assets/kerla.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Bali 6N",
      image: 'assets/bali.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Dubai 4N",
      image: 'assets/dubai.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Kashmir 5N",
      image: 'assets/kashmir.jpg',
    ),
    TravelPlanTopSellingDestinations(
      destination: "Vietnam 6N",
      image: 'assets/vietnam.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowVisibility);
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

                // Trip List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: myTrips.length,
                    itemBuilder: (context, index) {
                      final trip = myTrips[index];
                      return Container(
                        width: 190,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                              Image.asset(
                                trip.image,
                                fit: BoxFit.cover,
                                height: 100,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  trip.destination,
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
                    },
                  ),
                ),

                // Right Arrow
                if (_showRightArrow)
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
  }
}
