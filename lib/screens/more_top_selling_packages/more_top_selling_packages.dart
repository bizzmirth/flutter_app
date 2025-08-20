import 'package:bizzmirth_app/controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/screens/package_details_page/package_details_page.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TopPackagesPage extends StatefulWidget {
  const TopPackagesPage({super.key});

  @override
  _TopPackagesPageState createState() => _TopPackagesPageState();
}

class _TopPackagesPageState extends State<TopPackagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedTripDuration = "Upto 3N";
  final double _minPrice = 1000;
  final double _maxPrice = 150000;
  RangeValues _currentRange = const RangeValues(1000, 150000);
  List<String> availableHotelStars = ['3 Star', '4 Star', "5 Star"];
  List<String> selectedHotelStars = [];
// For mobile filter drawer

  @override
  void initState() {
    super.initState();
    selectedHotelStars = List.from(availableHotelStars);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTourPackageData();
    });
  }

  void getTourPackageData() async {
    final controller =
        Provider.of<TourPackagesController>(context, listen: false);
    // controller.apiGetTourPackages();
    controller.apiGetFilteredPackages([], "1000", "150000", "0", "3", "");
  }

  void getFilteredPackages() async {
    final controller =
        Provider.of<TourPackagesController>(context, listen: false);

    final numericStars = convertStarsToNumbers(selectedHotelStars);

    final durationValues = getTripDurationValues(selectedTripDuration);

    final minBudget = _currentRange.start.toString();
    final maxBudget = _currentRange.end.toString();

    // Extract duration values
    final minDuration = durationValues['minDuration']!;
    final maxDuration = durationValues['maxDuration']!;
    final tripDuration = durationValues['tripDuration']!;

    Logger.warning(
        "filters selected $numericStars, $minBudget, $maxBudget, $minDuration, $maxDuration, $tripDuration ");

    // Make API call
    controller.apiGetFilteredPackages(numericStars, minBudget, maxBudget,
        minDuration, maxDuration, tripDuration);
  }

  // Build filter section (reusable for both layouts)
  Widget _buildFilterSection(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 205, 222, 248),
      padding: const EdgeInsets.all(13.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Search field at the top
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),

          // Filters header
          Text(
            'Filters',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Hotel Stars Filter ----------
                  Text(
                    'Hotel Category',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      for (var star in availableHotelStars)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            star,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: selectedHotelStars.contains(star),
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked == true) {
                                selectedHotelStars.add(star);
                              } else {
                                selectedHotelStars.remove(star);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(),

                  // ---------- Budget Range ----------
                  Text(
                    'Budget',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 159, 197, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${_currentRange.start.toInt()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '₹${_currentRange.end.toInt()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _currentRange,
                          min: _minPrice,
                          max: _maxPrice,
                          labels: RangeLabels(
                            '₹${_currentRange.start.toInt()}',
                            '₹${_currentRange.end.toInt()}',
                          ),
                          activeColor: Colors.teal,
                          inactiveColor: Colors.teal.withOpacity(0.3),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRange = values;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(),

                  // ---------- Trip Duration ----------
                  Text(
                    'Trip Duration',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      for (var duration in [
                        'Upto 3N',
                        '4N - 7N',
                        '7N - 11N',
                        '11N - 15N',
                        'Above 15N'
                      ])
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(duration),
                          value: duration,
                          groupValue: selectedTripDuration,
                          onChanged: (value) {
                            setState(() {
                              selectedTripDuration = value;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ---------- Apply Button ----------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              onPressed: () {
                getFilteredPackages();

                // On mobile, close the filter drawer after applying
                if (MediaQuery.of(context).size.width < 600) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Apply Filters",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build packages list (reusable for both layouts)
  Widget _buildPackagesList(TourPackagesController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.error != null) {
      return Center(
        child: Text(
          controller.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (controller.tourPackages.isEmpty) {
      return const Center(
        child: Text("No packages available"),
      );
    }

    return ListView.builder(
      itemCount: controller.tourPackages.length,
      itemBuilder: (context, index) {
        final pkg = controller.tourPackages[index];
        final imageUrl = "https://ca.uniqbizz.com/${pkg.image}";

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    // ✅ Show loader while image is loading
                    if (loadingProgress == null) {
                      // Image has loaded successfully
                      return child;
                    }

                    // Show loading indicator with progress
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
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
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pkg.destination ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  pkg.name ?? "",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Default color for "From"
                        ),
                        children: [
                          const TextSpan(
                            text: "From ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: "₹${pkg.price}",
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
                            builder: (context) => PackageDetailsPage(
                              id: pkg.id!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: const Text('View Tour Details'),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use tablet layout for screens wider than 600 pixels
    if (screenWidth > 600) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  // Tablet layout (side-by-side)
  Widget _buildTabletLayout(BuildContext context) {
    return Consumer<TourPackagesController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Tour Packages',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 81, 131, 246),
            centerTitle: true,
          ),
          body: Row(
            children: [
              // ================== FILTER SECTION ==================
              Expanded(
                flex: 3,
                child: _buildFilterSection(context),
              ),

              // ================== PACKAGES SECTION ==================
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildPackagesList(controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Mobile layout (with filter drawer)
  Widget _buildMobileLayout(BuildContext context) {
    return Consumer<TourPackagesController>(
      builder: (context, controller, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Tour Packages',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 81, 131, 246),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // Use a GlobalKey to access the Scaffold
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.8,
            child: _buildFilterSection(context),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: _buildPackagesList(controller),
          ),
        );
      },
    );
  }
}
