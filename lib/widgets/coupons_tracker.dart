import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CouponProgressBar extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final ConfettiController confettiController; // <-- Passed from parent

  const CouponProgressBar({
    super.key,
    required this.currentStep,
    required this.confettiController,
    this.totalSteps = 4,
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
        widget.confettiController.play(); // <-- Use widget.confettiController
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Coupons Unlocked: $totalSteps / ${widget.totalSteps - 1}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Progress bar with moving indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container(
                    height: 12,
                    width: (MediaQuery.of(context).size.width - 40) * value,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width - 40) * value - 8,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.purpleAccent, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.4),
                            blurRadius: 6,
                            spreadRadius: 1,
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
        const SizedBox(height: 30),

        // Cards
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.totalSteps,
            itemBuilder: (context, index) {
              bool isUnlocked = index <
                  displayedStep; // correct: if displayedStep = 1 → only index 0 is unlocked

              bool isCurrent =
                  index == displayedStep - 1; // the one currently unlocking

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
                    ? _unlockedCard(index, isFinal)
                    : _lockedCard(isFinal),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _lockedCard(bool isFinal) {
    return Container(
      key: const ValueKey("locked"),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.white.withOpacity(0.05)),
            ),
            Center(
              child: Icon(
                Icons.lock_outline,
                size: 55,
                color: isFinal ? Colors.amber[700] : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Unlocked card with content & gradient
  Widget _unlockedCard(int index, bool isFinal) {
    List<List<Color>> gradients = [
      [Color(0xFF6A8DFF), Color(0xFF8AB4FF)], // Calm blue
      [Color(0xFF9B6BFF), Color(0xFFC29DFF)], // Soft purple
      [Color(0xFF5ABF8A), Color(0xFF89E3B6)], // Fresh green
    ];

    List<Color> gradient = gradients[index % 3];

    return Container(
      key: const ValueKey("unlocked"),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFinal
              ? [Color(0xFFF5C76D), Color(0xFFFFE29D)] // Rich gold
              : gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with circular background
          Container(
            padding: const EdgeInsets.all(16),
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
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isFinal ? "Unlock your Europe trip" : "Coupon ${index + 1}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (!isFinal)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Used",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
