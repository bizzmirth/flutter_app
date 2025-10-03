import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingTrackerCard extends StatelessWidget {
  final String title;
  final int bookingCount; // Total bookings done by user
  final Color accentColor;
  final int? visualGoal; // optional override for the "full" value
  final Duration animationDuration;

  const BookingTrackerCard({
    super.key,
    required this.title,
    required this.bookingCount,
    this.accentColor = Colors.orange,
    this.visualGoal,
    this.animationDuration = const Duration(seconds: 2),
  });

  String getMessage() {
    if (bookingCount == 0) {
      return 'No bookings yet, start your journey today!';
    } else if (bookingCount < 5) {
      return "Great! You're getting started with bookings 🎉";
    } else if (bookingCount < 15) {
      return "Awesome! You're becoming a regular ⭐";
    } else if (bookingCount < 30) {
      return "Wow! You're a loyal customer ❤️";
    } else {
      return "Legendary! You're one of our top bookers 👑";
    }
  }

  /// Choose a sensible display max (visual goal) for the progress circle.
  /// If [visualGoal] is provided by the caller, use it. Otherwise pick the
  /// next milestone from the list or scale for very large counts.
  double _computeDisplayMax(int count) {
    if (visualGoal != null && visualGoal! > 0) return visualGoal!.toDouble();

    final tiers = [5, 15, 30, 50, 100];
    for (final t in tiers) {
      if (count < t) return t.toDouble();
    }
    // For very large counts, use 1.5x as the 'next milestone'
    return max((count * 1.5).ceilToDouble(), count + 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final displayMax = _computeDisplayMax(bookingCount);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.10), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Animated booking number + circular progress (now relative to displayMax)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: bookingCount.toDouble()),
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final progress = (displayMax <= 0)
                  ? 0.0
                  : (value / displayMax).clamp(0.0, 1.0);

              // subtle scale effect for the number as it animates
              final scale = 0.95 + 0.05 * (value / max(1, bookingCount));

              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: isTablet ? 140 : 110,
                    height: isTablet ? 140 : 110,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: isTablet ? 10 : 8,
                      backgroundColor: accentColor.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation(accentColor),
                    ),
                  ),
                  Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toInt().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 30 : 24,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          'Bookings',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Motivational Message
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 16 : 12,
              horizontal: isTablet ? 20 : 14,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: accentColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: accentColor, size: isTablet ? 22 : 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getMessage(),
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
