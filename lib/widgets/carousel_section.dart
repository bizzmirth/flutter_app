import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

class CarouselSection extends StatefulWidget {
  const CarouselSection({super.key});

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  final List<String> imageUrls = [
    'https://testca.uniqbizz.com/api/assets/app_images/paris.jpg',
    'https://testca.uniqbizz.com/api/assets/app_images/bali.jpg',
    'https://testca.uniqbizz.com/api/assets/app_images/newyork.jpg',
    'https://testca.uniqbizz.com/api/assets/app_images/tokyo.jpg',
    'https://testca.uniqbizz.com/api/assets/app_images/santorini.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Warm up cache for all images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var url in imageUrls) {
        precacheImage(NetworkImage(url), context);
      }
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.red)),
                  ),
                  if (!isActive)
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                ],
              ),
            );
          },
          options: carousel_slider.CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.80,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
