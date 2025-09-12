import 'package:bizzmirth_app/widgets/enhanced_progress_tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferralTrackerCard extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color progressColor;
  final IconData? goalIcon;

  const ReferralTrackerCard({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.progressColor = Colors.blueAccent,
    this.goalIcon,
  });

  String getMessage() {
    if (currentStep >= 1 && currentStep <= 3) {
      return "You're off to a great start! Keep referring friends.";
    } else if (currentStep >= 4 && currentStep <= 6) {
      return "Awesome! You're halfway there, keep going!";
    } else if (currentStep >= 7 && currentStep <= 9) {
      return "Almost there! Just a few more to go.";
    } else if (currentStep == 10) {
      return "Congratulations! You've completed your referral journey and unlocked the Europe Trip!";
    }
    return "";
  }

  String getGoals() {
    if (currentStep == 10) {
      return "Europe Trip Unlocked 🎉";
    } else {
      return "Refer and Earn";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            progressColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: progressColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
        child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with progress percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '$currentStep/$totalSteps Referrals Unlocked!',
                  style: GoogleFonts.poppins(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${((currentStep / totalSteps) * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Enhanced Progress Tracker
        EnhancedProgressTracker(
          totalSteps: totalSteps,
          currentStep: currentStep,
          goal: getGoals(),
          progressColor: progressColor,
          goalIcon: goalIcon,
        ),

        const SizedBox(height: 20),

        // Message with better styling
        _buildMessageWidget(true),
      ],
    );
  }

  Widget _buildPhoneLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with progress percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$currentStep/$totalSteps Referrals Unlocked!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${((currentStep / totalSteps) * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Enhanced Progress Tracker with horizontal scrolling
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: EnhancedProgressTracker(
            totalSteps: totalSteps,
            currentStep: currentStep,
            goal: getGoals(),
            progressColor: progressColor,
            goalIcon: goalIcon,
          ),
        ),

        const SizedBox(height: 16),

        // Message with better styling
        _buildMessageWidget(false),
      ],
    );
  }

  Widget _buildMessageWidget(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 14, horizontal: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: currentStep >= totalSteps
            ? Colors.green.withValues(alpha: 0.1)
            : progressColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: currentStep >= totalSteps
              ? Colors.green.withValues(alpha: 0.3)
              : progressColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            currentStep >= totalSteps ? Icons.celebration : Icons.trending_up,
            color: currentStep >= totalSteps ? Colors.green : progressColor,
            size: isTablet ? 20 : 18,
          ),
          SizedBox(width: isTablet ? 12 : 10),
          Expanded(
            child: Text(
              getMessage(),
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: currentStep >= totalSteps
                    ? Colors.green.shade700
                    : Colors.grey[700],
                letterSpacing: isTablet ? 0.3 : 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
