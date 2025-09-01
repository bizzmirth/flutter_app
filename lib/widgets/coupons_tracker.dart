import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CouponProgressBar extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final ConfettiController confettiController;
  final double scaleFactor; // Add a scale factor parameter

  const CouponProgressBar({
    super.key,
    required this.currentStep,
    required this.confettiController,
    this.totalSteps = 4,
    this.scaleFactor = 1.0, // Default to normal size
  });

  @override
  State<CouponProgressBar> createState() => _CouponProgressBarState();
}

class _CouponProgressBarState extends State<CouponProgressBar>
    with TickerProviderStateMixin {
  int displayedStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateProgress();
    });
  }

  @override
  void didUpdateWidget(covariant CouponProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _animateProgress();
    }
  }

  void _animateProgress() async {
    for (int i = displayedStep; i < widget.currentStep; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => displayedStep = i + 1);
      if (displayedStep == widget.totalSteps) {
        widget.confettiController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = displayedStep / (widget.totalSteps - 1);
    int totalSteps = 0;
    if (displayedStep == 4) {
      totalSteps = 3;
    } else {
      totalSteps = displayedStep;
    }

    // Apply scale factor to various dimensions
    final double scaledPadding = 16.0 * widget.scaleFactor;
    final double progressBarHeight = 12.0 * widget.scaleFactor;
    final double indicatorSize = 22.0 * widget.scaleFactor;
    final double cardHeight = 200.0 * widget.scaleFactor;
    final double cardWidth = 220.0 * widget.scaleFactor;
    final double iconSize = 50.0 * widget.scaleFactor;
    final double fontSize = 18.0 * widget.scaleFactor;
    final double smallFontSize = 14.0 * widget.scaleFactor;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: scaledPadding),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: scaledPadding,
              vertical: 6 * widget.scaleFactor,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
              ),
              borderRadius: BorderRadius.circular(20 * widget.scaleFactor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4 * widget.scaleFactor,
                  offset: Offset(0, 2 * widget.scaleFactor),
                ),
              ],
            ),
            child: Text(
              "Coupons Unlocked: $totalSteps / ${widget.totalSteps - 1}",
              style: TextStyle(
                fontSize: smallFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Progress bar with moving indicator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20 * widget.scaleFactor),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(20 * widget.scaleFactor),
                    ),
                  ),
                  Container(
                    height: progressBarHeight,
                    width: (MediaQuery.of(context).size.width -
                            40 * widget.scaleFactor) *
                        value,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                      ),
                      borderRadius:
                          BorderRadius.circular(20 * widget.scaleFactor),
                    ),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width -
                                40 * widget.scaleFactor) *
                            value -
                        (indicatorSize / 2),
                    child: Container(
                      height: indicatorSize,
                      width: indicatorSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.purpleAccent,
                          width: 3 * widget.scaleFactor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.4),
                            blurRadius: 6 * widget.scaleFactor,
                            spreadRadius: 1 * widget.scaleFactor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 30 * widget.scaleFactor),

        // Cards
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: scaledPadding),
            itemCount: widget.totalSteps,
            itemBuilder: (context, index) {
              bool isUnlocked = index < displayedStep;
              bool isCurrent = index == displayedStep - 1;
              bool isFinal = index == widget.totalSteps - 1;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(anim);
                  return AnimatedBuilder(
                    animation: rotate,
                    child: child,
                    builder: (context, child) {
                      final angle = rotate.value;
                      return Transform(
                        transform: Matrix4.rotationY(angle),
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                child: isUnlocked || isCurrent
                    ? _unlockedCard(
                        index, isFinal, cardWidth, iconSize, fontSize)
                    : _lockedCard(isFinal, cardWidth, iconSize),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _lockedCard(bool isFinal, double cardWidth, double iconSize) {
    return Container(
      key: const ValueKey("locked"),
      margin: EdgeInsets.symmetric(horizontal: 8 * widget.scaleFactor),
      width: cardWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20 * widget.scaleFactor),
        gradient: isFinal
            ? const LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Colors.grey, Colors.blueGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 * widget.scaleFactor),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4 * widget.scaleFactor,
                sigmaY: 4 * widget.scaleFactor,
              ),
              child: Container(color: Colors.white.withOpacity(0.05)),
            ),
            Center(
              child: Icon(
                Icons.lock_outline,
                size: iconSize,
                color: isFinal ? Colors.amber[700] : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unlockedCard(int index, bool isFinal, double cardWidth,
      double iconSize, double fontSize) {
    List<List<Color>> gradients = [
      [const Color(0xFF6A8DFF), const Color(0xFF8AB4FF)], // Calm blue
      [const Color(0xFF9B6BFF), const Color(0xFFC29DFF)], // Soft purple
      [const Color(0xFF5ABF8A), const Color(0xFF89E3B6)], // Fresh green
    ];

    List<Color> gradient = gradients[index % 3];

    return Container(
      key: const ValueKey("unlocked"),
      margin: EdgeInsets.symmetric(horizontal: 8 * widget.scaleFactor),
      width: cardWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFinal
              ? [const Color(0xFFF5C76D), const Color(0xFFFFE29D)] // Rich gold
              : gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20 * widget.scaleFactor),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12 * widget.scaleFactor,
            spreadRadius: 1 * widget.scaleFactor,
            offset: Offset(0, 4 * widget.scaleFactor),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with circular background
          Container(
            padding: EdgeInsets.all(16 * widget.scaleFactor),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFinal
                  ? Icons.flight_takeoff
                  : (index == 0
                      ? Icons.local_offer
                      : index == 1
                          ? Icons.card_giftcard
                          : Icons.discount),
              size: iconSize,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10 * widget.scaleFactor),
          Text(
            isFinal ? "Unlock your Europe trip" : "Coupon ${index + 1}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (!isFinal)
            Padding(
              padding: EdgeInsets.only(top: 8.0 * widget.scaleFactor),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12 * widget.scaleFactor,
                  vertical: 4 * widget.scaleFactor,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12 * widget.scaleFactor),
                ),
                child: Text(
                  "Used",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 0.7,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
