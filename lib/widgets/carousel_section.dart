import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

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
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.80, // Adjust viewport fraction as needed
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
