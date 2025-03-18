import 'package:bizzmirth_app/models/travel_plan_top_selling_packages.dart';
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopPackagesPage extends StatefulWidget {
  const TopPackagesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TopPackagesPageState createState() => _TopPackagesPageState();
}

class _TopPackagesPageState extends State<TopPackagesPage> {
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

  String? selectedHotelStar; // Tracks selected hotel star
  String? selectedTripDuration; // Tracks selected trip duration
  final double _minPrice = 0;
  final double _maxPrice = 50000;
  RangeValues _currentRange = const RangeValues(0, 50000);
  double currentValue = 5000;
  List<String> selectedHotelStars = [];

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color.fromARGB(255, 81, 131, 246),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Filter Section
          Expanded(
            flex: 3,
            child: Container(
              height: double.infinity,
              color: Color.fromARGB(255, 205, 222, 248),
              padding: const EdgeInsets.all(13.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    Text(
                      'Filters',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0,
                            0), // Optional text color to match the box
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Hotel Stars Filter
                    Text(
                      'Hotel Category',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      children: [
                        for (var star in [
                          '3 Star',
                          '4 Star',
                          '5 Star',
                          'Villa'
                        ])
                          CheckboxListTile(
                            title: Text(
                              star,
                              style: GoogleFonts.poppins(
                                fontSize: 14, // Adjust the font size here
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            value: selectedHotelStars.contains(
                                star), // Check if this star is selected
                            onChanged: (isChecked) {
                              setState(() {
                                if (isChecked == true) {
                                  selectedHotelStars
                                      .add(star); // Add the star if checked
                                } else {
                                  selectedHotelStars.remove(
                                      star); // Remove the star if unchecked
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                      ],
                    ),

                    const SizedBox(height: 1),

                    Divider(),
                    // Budget
                    Text(
                      'Budget',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // FlutterSlider
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     FlutterSlider(
                    //       values: [currentValue],
                    //       max: 50000,
                    //       min: 0,
                    //       onDragging: (handlerIndex, lowerValue, upperValue) {
                    //         setState(() {
                    //           currentValue =
                    //               lowerValue; // Update the value dynamically
                    //         });
                    //       },
                    //       tooltip: FlutterSliderTooltip(
                    //         disabled: true, // Disable the tooltip
                    //       ),
                    //       handler: FlutterSliderHandler(
                    //         decoration: BoxDecoration(),
                    //         child: Material(
                    //           type: MaterialType.circle,
                    //           color: Colors.teal,
                    //           elevation: 5,
                    //           child: Container(
                    //             padding: EdgeInsets.all(5),
                    //             child: Icon(Icons.drag_handle,
                    //                 color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //       trackBar: FlutterSliderTrackBar(
                    //         activeTrackBarHeight: 6,
                    //         activeTrackBar: BoxDecoration(
                    //           color: Colors.teal,
                    //         ),
                    //         inactiveTrackBar: BoxDecoration(
                    //           color: const Color.fromARGB(255, 81, 131, 246),
                    //         ),
                    //       ),
                    //     ),
                    //     // Remove or reduce the spacing between the slider and the text
                    //     SizedBox(height: 0), // Adjust height to reduce spacing
                    //     Text(
                    //       'Selected Price: ₹${currentValue.toInt()}',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.teal,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 1),
                    // Divider(),

                    // Price Range Slider
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
                          // Min and Max Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${_currentRange.start.toInt()}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '₹${_currentRange.end.toInt()}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 1),

                          // Range Slider
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
                    Divider(),

                    // Trip Duration Filter
                    Text(
                      'Trip Duration',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    for (var duration in [
                      'Upto 3N',
                      '4N - 7N',
                      '7N - 11N',
                      '11N - 15N',
                      'Above 15N'
                    ])
                      RadioListTile<String>(
                        title: Text(duration),
                        value: duration,
                        groupValue: selectedTripDuration,
                        onChanged: (value) {
                          setState(() {
                            selectedTripDuration = value;
                          });
                        },
                      ),
                    Divider()
                  ],
                ),
              ),
            ),
          ),

          // Top Selling Packages Section
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: myTrips.length,
                itemBuilder: (context, index) {
                  final trip = myTrips[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            trip.image,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            trip.destination,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            trip.description,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${trip.price}',
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
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255)),
                                child: Text('View Tour Details'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
