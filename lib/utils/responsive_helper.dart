import 'package:flutter/material.dart';

class AppDimens {
  static double padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600 ? 8.0 : 16.0;
  }

  static double buttonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600 ? 40.0 : 56.0;
  }
}
