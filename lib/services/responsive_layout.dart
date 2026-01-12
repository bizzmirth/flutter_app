// responsive_layout.dart

import 'package:flutter/material.dart';

/// A utility class to handle responsive layouts across different screen sizes
class ResponsiveLayout extends StatelessWidget {
  final Widget? appBar;
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final bool canPop;
  final Function(bool, dynamic)? onPopInvokedWithResult;

  const ResponsiveLayout({
    super.key,
    this.appBar,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: appBar as PreferredSizeWidget?,
        drawer: drawer,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1200 && desktop != null) {
              return desktop!;
            } else if (constraints.maxWidth >= 600 && tablet != null) {
              return tablet!;
            } else {
              return mobile;
            }
          },
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
