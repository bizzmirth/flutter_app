import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingTrackerCard extends StatelessWidget {
  final String title;
  final int bookingCount;
  final Color accentColor;
  final Duration animationDuration;

  const BookingTrackerCard({
    super.key,
    required this.title,
    required this.bookingCount,
    this.accentColor = Colors.blue,
    this.animationDuration = const Duration(milliseconds: 1800),
  });

  String getMessage() {
    if (bookingCount == 0) {
      return 'Start your booking journey today!';
    } else if (bookingCount < 5) {
      return "You're on your way! 🚀";
    } else if (bookingCount < 15) {
      return 'Building momentum! ⭐';
    } else if (bookingCount < 30) {
      return "You're crushing it! 🔥";
    } else if (bookingCount < 50) {
      return 'Elite status unlocked! 💎';
    } else {
      return 'Legendary booker! 👑';
    }
  }

  int _getNextMilestone(int count) {
    final milestones = [5, 15, 30, 50, 100, 200, 500];
    for (final m in milestones) {
      if (count < m) return m;
    }
    return ((count / 100).ceil() + 1) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final nextMilestone = _getNextMilestone(bookingCount);
    final progress = bookingCount / nextMilestone;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.08),
            // Colors.white,
            accentColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      padding: EdgeInsets.all(isTablet ? 28 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.confirmation_number_rounded,
                  color: Colors.white,
                  size: isTablet ? 28 : 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 22 : 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your booking progress',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 14 : 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Main Stats Row
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: bookingCount.toDouble()),
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              value.toInt().toString(),
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 52 : 44,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                                height: 1,
                                letterSpacing: -2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 4),
                              child: Text(
                                'bookings',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            'Next: $nextMilestone',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13 : 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Circular Progress Indicator
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return SizedBox(
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 120 : 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        SizedBox(
                          width: isTablet ? 120 : 100,
                          height: isTablet ? 120 : 100,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: isTablet ? 10 : 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(
                              accentColor.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: isTablet ? 120 : 100,
                          height: isTablet ? 120 : 100,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: isTablet ? 10 : 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(accentColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Percentage text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(value * 100).toInt()}%',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            Text(
                              'complete',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 11 : 10,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          height: isTablet ? 14 : 12,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Container(
                          height: isTablet ? 14 : 12,
                          width:
                              MediaQuery.of(context).size.width * value * 0.9,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor,
                                accentColor.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$bookingCount',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13 : 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$nextMilestone',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13 : 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Motivational Message
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 18 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: accentColor,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    getMessage(),
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 15 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.3,
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
