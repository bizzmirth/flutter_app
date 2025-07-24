import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appwidget {
  static TextStyle poppinsAppBarTitle() {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  static TextStyle poppinsHeadline() {
    return GoogleFonts.poppins(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
  }
}
