import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Bizzmirth Holidays Pvt. Ltd.',
            style: GoogleFonts.lora(
              fontSize: 26, // Increased font size
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'The world\'s best travel spots',
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Bizzmirth Holidays Pvt. Ltd. specializes in selling tailored holiday packages, offering unforgettable travel experiences designed to suit diverse preferences and budgets.',
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
