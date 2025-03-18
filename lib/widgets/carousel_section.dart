import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:google_fonts/google_fonts.dart';

class CarouselSection extends StatefulWidget {
  const CarouselSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselSectionState createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
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

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          carousel_slider.CarouselSlider.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom:
                          30, // Adjusted the position slightly for better visual appeal
                      left: 20,
                      child: Text(
                        imageTitles[index],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize:
                              28, // Increased font size for title prominence
                          fontWeight: FontWeight
                              .w700, // Bold weight for strong title emphasis
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.7), // Slightly darker shadow
                              offset: Offset(4.0, 4.0),
                            ),
                          ],
                        ),
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
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
