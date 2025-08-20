import 'dart:ui';

import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/info_row.dart';
import 'package:bizzmirth_app/widgets/price_row.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PackageDetailsPage extends StatefulWidget {
  final String id;
  const PackageDetailsPage({required this.id, super.key});

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  final List<String> imageUrls = [
    'assets/paris.jpg',
    'assets/bali.jpg',
    'assets/newyork.jpg',
    'assets/tokyo.jpg',
    'assets/santorini.jpg',
  ];

  final List<String> imageTitles = [
    'Paris, France',
    'Bali, Indonesia',
    'New York, USA',
    'Tokyo, Japan',
    'Santorini, Greece',
  ];

  final List<Map<String, String>> itinerary = [
    {
      "day": "Day 1",
      "title": "Arrival & Welcome",
      "details":
          "Arrive at the picturesque starting destination and be greeted with a warm welcome. Transfer to your hotel and enjoy a relaxing evening. Get a brief overview of the itinerary and enjoy a delicious welcome dinner.",
      "meal": "sadd",
      "transport": "private"
    },
    {
      "day": "Day 2",
      "title": "Scenic Exploration & Local Culture",
      "details":
          "Kick off your journey with a visit to iconic cultural sites and scenic viewpoints. Explore vibrant local markets and interact with locals to get a taste of the region's culture.",
      "meal": "sadd",
      "transport": "private"
    },
    {
      "day": "Day 3",
      "title": "Adventure Day – Trekking & Outdoor Fun",
      "details":
          "Embrace adventure with a guided trek through lush trails, leading to mesmerizing viewpoints. Soak in the beauty of waterfalls and rivers along the way.",
      "meal": "sadd",
      "transport": "private"
    },
    {
      "day": "Day 4",
      "title": "Relaxation & Spa",
      "details":
          "Unwind with a full day of relaxation. Enjoy spa treatments or yoga sessions at the resort, followed by an evening cruise on a serene lake.",
      "meal": "sadd",
      "transport": "private"
    },
    {
      "day": "Day 5",
      "title": "Local Villages & Culinary Delights",
      "details":
          "Experience rural charm by visiting local villages. Learn about traditional crafts, farming, and cuisine. Engage in a fun cooking class to make regional delicacies.",
      "meal": "sadd",
      "transport": "private"
    },
    {
      "day": "Day 6",
      "title": "Farewell & Departure",
      "details":
          "Enjoy a leisurely breakfast before checking out. Take a scenic route back to the departure point and bid farewell with beautiful memories to cherish.",
      "meal": "sadd",
      "transport": "private"
    },
  ];

  int currentIndex = 0;
  String? customerType;

  void getShredPrefData() async {
    customerType = await SharedPrefHelper().getUserType();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getShredPrefData();
  }

  /// Reusable Card widget
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
        backgroundColor: Color.fromARGB(255, 81, 131, 246),
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
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index, realIndex) {
                      bool isActive = index == currentIndex;

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                            if (!isActive) // Apply blur only for non-active items
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    options: carousel_slider.CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction:
                          0.7, // Adjust viewport fraction as needed
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
            SizedBox(height: 30),
            // Tour Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Travello Tour – Best Of Samyan Bangkok',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(height: 8),
            // Location and Duration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
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
                      children: const [
                        InfoRow(
                          icon: Icons.location_on,
                          iconColor: Colors.teal,
                          text: 'Bangkok, Thailand',
                        ),
                        InfoRow(
                          icon: Icons.timer,
                          iconColor: Colors.teal,
                          text: '3 Days 2 Nights',
                        ),
                        InfoRow(
                          icon: Icons.landscape,
                          iconColor: Colors.teal,
                          text: 'Private',
                        ),
                        InfoRow(
                          icon: Icons.directions_car,
                          iconColor: Colors.teal,
                          text: 'Car, Volvo Bus',
                        ),
                        InfoRow(
                          icon: Icons.hotel,
                          iconColor: Colors.teal,
                          text: "Double",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Divider(thickness: 1, height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PriceRow(
                  label: 'Starting From:',
                  price: '',
                ),
                PriceRow(
                    label: 'Per Adult Price:',
                    price: '₹8,107.5/-',
                    icon: Icons.person),
                PriceRow(
                    label: 'Per Child Price:',
                    price: '₹6,127.5/-',
                    icon: Icons.child_care),
              ],
            ),
            Divider(thickness: 1, height: 32),
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
                  SizedBox(height: 8),
                  Text(
                    'Embark on an unforgettable journey to some of the most breathtaking destinations. From serene lakes to majestic mountains, this package is designed to immerse you in nature’s beauty. Perfect for adventure enthusiasts, photographers, and anyone looking to rejuvenate their soul.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Discover the rich cultural heritage of the region as you explore ancient temples, bustling local markets, and vibrant festivals. Savor authentic local cuisines and interact with friendly locals to truly experience the heart of the destination.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, height: 32),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isSmallScreen = constraints.maxWidth < 600; // breakpoint

                  if (isSmallScreen) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: _buildInfoCard(
                            title: 'Included',
                            content: '- Welcome Breakfast\n'
                                '- All Entry Tickets of Hopping Destinations\n'
                                '- Lunch Platter\n'
                                '- Evening Snacks\n'
                                '- First Aid Kit (In case of emergency)',
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: _buildInfoCard(
                            title: 'Excluded',
                            content: '- Personal expenses\n'
                                '- Anything else that isn\'t mentioned on Inclusions\n'
                                '- Additional Service',
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
                            content: '- Welcome Breakfast\n'
                                '- All Entry Tickets of Hopping Destinations\n'
                                '- Lunch Platter\n'
                                '- Evening Snacks\n'
                                '- First Aid Kit (In case of emergency)',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            title: 'Excluded',
                            content: '- Personal expenses\n'
                                '- Anything else that isn\'t mentioned on Inclusions\n'
                                '- Additional Service',
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            Divider(thickness: 1, height: 32),

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
            SizedBox(height: 8),

            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itinerary.length,
              itemBuilder: (context, index) {
                final item = itinerary[index];
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
                        dividerColor:
                            Colors.transparent, // ✅ removes extra lines
                      ),
                      child: ExpansionTile(
                        tilePadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          "${item['day']} : ${item['title']}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            item['day']!.split(' ')[1],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              item['details']!,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: "Meal: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: item['meal'] ?? "N/A"),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: "Transport: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: item['transport'] ?? "N/A"),
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
            SizedBox(height: 8),
            Divider(thickness: 1, height: 32),

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
                  SizedBox(height: 8),
                  Text(
                    ' 1> Early Bird Discount \n 2> Limited Slots Available \n 3> Customizable Options \n 4> Perfect for Families and Friends \n 5> Exclusive Perks \n 6> Recommended Season to Visit \n 7> Customer Reviews \n 8> Safety First \n 9> Eco-Friendly Travel \n 10> Flexible Cancellation Policy',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, height: 32),

            // // Policies Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Policies',
            //         style: GoogleFonts.poppins(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.teal.shade900,
            //         ),
            //       ),
            //       SizedBox(height: 8),
            //       Text(
            //         ' Cancellation & Refund Policy \n Payment Policy \n Rescheduling Policy \n Health & Safety Policy \n Inclusion & Exclusion Policy \n Child & Senior Policy \n Code of Conduct Policy',
            //         style: GoogleFonts.poppins(fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(thickness: 1, height: 32),
            SizedBox(height: 100),
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
                onPressed: () {
                  // Open WhatsApp chat
                },
                backgroundColor: Colors.green,
                heroTag: "whatsapp",
                child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
              ),
              SizedBox(height: 12),
              FloatingActionButton(
                tooltip: "Share",
                onPressed: () {
                  // Add share functionality
                },
                backgroundColor: Colors.blue,
                heroTag: "share",
                child: Icon(Icons.share, color: Colors.white),
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
                showBookingPopup(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color.fromARGB(255, 46, 122, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Enquire or Book Now",
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
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color.fromARGB(
                    255, 46, 122, 244), // Orange color for customer
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Request Quotation",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
      ]),
    );
  }
}
