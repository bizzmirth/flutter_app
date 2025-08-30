import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MembershipPromotionCard extends StatelessWidget {
  final Function(String planName)? onPlanSelected;
  final bool isForFreeUser;

  const MembershipPromotionCard({
    super.key,
    this.onPlanSelected,
    this.isForFreeUser = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.blueGrey.shade900, Colors.blueGrey.shade800]
                : [Colors.blue.shade900, Colors.blueAccent.shade200],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.workspace_premium_rounded,
                      size: 42, color: Colors.amber.shade600),
                  const SizedBox(height: 16),
                  Text(
                    isForFreeUser
                        ? 'Upgrade Your Membership'
                        : 'Start Your Journey With Us',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isForFreeUser
                        ? 'Choose a plan that fits your goals and unlock exclusive benefits.'
                        : 'Select a membership plan and begin your adventure with exclusive travel benefits.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Plan Cards (Equal Height)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final isTablet = constraints.maxWidth > 500;
                final crossAxisCount = isWide ? 2 : (isTablet ? 2 : 1);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWide
                      ? 0.65 // desktops / very wide screens
                      : (isTablet ? 0.7 : 1.1), // tablets vs phones
                  children: const [
                    _PlanCard(plan: _neoSelectPlan, isPopular: true),
                    _PlanCard(plan: _premiumLitePlan),
                    _PlanCard(plan: _premiumSelectPlan),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefit {
  final String text;
  final bool available;

  const _Benefit(this.text, {this.available = true});
}

// Plan Data Model
class _MembershipPlan {
  final String name;
  final String price;
  final String validity;
  final List<_Benefit> benefits;
  final Color accentColor;
  final Color gradientStart;
  final Color gradientEnd;

  const _MembershipPlan({
    required this.name,
    required this.price,
    required this.validity,
    required this.benefits,
    required this.accentColor,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

// Plans
const _neoSelectPlan = _MembershipPlan(
  name: 'Neo Select',
  price: '₹11,000',
  validity: '10 Years',
  benefits: [
    _Benefit('5 Travel Coupons'),
    _Benefit('₹3,000 value per coupon'),
    _Benefit('Basic + Mid + Premium Holiday Package Access'),
    _Benefit('Highly Affordable'),
    _Benefit('Highest Value for Money\nPay Less,\nEnjoy More'),
    _Benefit('No Customizations Available', available: false),
    _Benefit(
        'Referral Benefits:\n\t\t\t\tDirect: ₹1000\n\t\t\t\tSecondary: ₹500'),
    _Benefit(
        'Best for Smart Buyers who want Flexibility + Savings at a Low Cost')
  ],
  accentColor: Colors.blue,
  gradientStart: Color(0xFFE3F2FD),
  gradientEnd: Color(0xFFBBDEFB),
);

const _premiumLitePlan = _MembershipPlan(
  name: 'Premium Select Lite',
  price: '₹21,000',
  validity: '10 Years',
  benefits: [
    _Benefit('5 Travel Coupons'),
    _Benefit('₹5,000 value per coupon'),
    _Benefit('Only Premium Holiday Package Access'),
    _Benefit('Moderate Affordability', available: false),
    _Benefit('Good Value for Money'),
    _Benefit('No Customizations Available', available: false),
    _Benefit(
        'Referral Benefits:\n\t\t\t\tDirect: ₹1000\n\t\t\t\tSecondary: ₹500\n\t\t\t\tSub-Secondary: ₹250'),
    _Benefit(
        'Best for Customers who want Larger Coupons but Limited Package Choices')
  ],
  accentColor: Colors.purple,
  gradientStart: Color(0xFFF3E5F5),
  gradientEnd: Color(0xFFE1BEE7),
);

const _premiumSelectPlan = _MembershipPlan(
  name: 'Premium Select',
  price: '₹35,000',
  validity: '10 Years',
  benefits: [
    _Benefit('10 Travel Coupons'),
    _Benefit('₹3,000 value per coupon'),
    _Benefit('Only Premium Holiday Package Access'),
    _Benefit('Higher Affordability', available: false),
    _Benefit('Moderate Value for Money'),
    _Benefit('No Customizations Available', available: false),
    _Benefit(
        'Referral Benefits:\n\t\t\t\tDirect: ₹1500\n\t\t\t\tSecondary: ₹500\n\t\t\t\tSub-Secondary: ₹250'),
    _Benefit('Best for Customers who Spend More for Long-Term Coupon Benefits')
  ],
  accentColor: Colors.pink,
  gradientStart: Color.fromARGB(255, 232, 219, 224), // light pink
  gradientEnd: Color.fromARGB(255, 227, 121, 156), // medium pink
);

// Plan Card
class _PlanCard extends StatelessWidget {
  final _MembershipPlan plan;
  final bool isPopular;

  const _PlanCard({required this.plan, this.isPopular = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey.shade800, Colors.grey.shade700]
                : [plan.gradientStart, plan.gradientEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 35, left: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          plan.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : plan.accentColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6), // smaller
                        decoration: BoxDecoration(
                          color: plan.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.price,
                          style: TextStyle(
                            fontSize: 13, // smaller
                            fontWeight: FontWeight.w600,
                            color: plan.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    plan.validity,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 5), // extra breathing space
                  Divider(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.4) // brighter in dark mode
                        : Colors.grey.shade500, // darker in light mode
                    thickness: 0.5, // bolder line
                    height: 24, // ensures spacing above/below
                  ),
                  const SizedBox(height: 5),

                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: plan.benefits.length,
                      itemBuilder: (context, index) {
                        final benefit = plan.benefits[index];
                        final icon = benefit.available
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded;
                        final color = benefit.available
                            ? Colors.green.shade600
                            : Colors.red.shade600;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(icon, size: 20, color: color),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  benefit.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showContactDialog(context, plan.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Select Plan'),
                    ),
                  ),
                ],
              ),
            ),

            // Badge
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, String planName) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      // barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Icon(
                    Icons.contact_phone_rounded,
                    color: plan.accentColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Interested in $planName?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Content
              Text(
                'Our team will contact you shortly with more details and to complete your membership registration.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // Additional contact options
              _buildContactOption(
                context,
                icon: Icons.phone_rounded,
                title: 'Call Now',
                subtitle: '+91 8010892265',
                onTap: () => _handleCall(context),
              ),

              const SizedBox(height: 12),

              _buildContactOption(
                context,
                icon: Icons.email_rounded,
                title: 'Send Email',
                subtitle: 'support@uniqbizz.com',
                onTap: () => _handleEmail(context, plan.name),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Later'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: plan.accentColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCall(BuildContext context) {
    Navigator.pop(context);
    _launchUrl('tel:+918010892265');
  }

  void _handleEmail(BuildContext context, String planName) async {
    Navigator.pop(context);

    final String subject =
        Uri.encodeComponent("Inquiry about $planName Membership");
    final String body = Uri.encodeComponent(
        "Hello,\n\nI would like to know more about the $planName Membership.\n\nThanks,");

    // ✅ First try native mailto
    final Uri emailUri =
        Uri.parse("mailto:support@uniqbizz.com?subject=$subject&body=$body");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      return;
    }

    final Uri gmailUri = Uri.parse(
        "googlegmail://co?to=support@uniqbizz.com&subject=$subject&body=$body");

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
      return;
    }

    // ✅ Fallback Gmail web
    final Uri webGmailUri = Uri.parse(
        "https://mail.google.com/mail/?view=cm&fs=1&to=support@uniqbizz.com&su=$subject&body=$body");

    if (await canLaunchUrl(webGmailUri)) {
      await launchUrl(webGmailUri, mode: LaunchMode.externalApplication);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("No email app or Gmail available on this device")),
    );
  }

  void _launchUrl(String url) async {
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        // Handle the case where the URL can't be launched
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
