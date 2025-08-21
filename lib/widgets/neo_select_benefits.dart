import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class NeoSelectBenefits extends StatefulWidget {
  const NeoSelectBenefits({super.key});

  @override
  State<NeoSelectBenefits> createState() => _NeoSelectBenefitsState();
}

class _NeoSelectBenefitsState extends State<NeoSelectBenefits>
    with TickerProviderStateMixin {
  // final ConfettiController _confettiController =
  //     ConfettiController(duration: const Duration(seconds: 3));

  late AnimationController _feeController;
  late AnimationController _couponController;
  late AnimationController _savingsController;
  late AnimationController _titleController;
  late AnimationController _backgroundController;

  int _fee = 0, _coupons = 0, _savings = 0;
  bool _showFinalMessage = false;

  @override
  void initState() {
    super.initState();

    _feeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _couponController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _savingsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _titleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _backgroundController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    WidgetsBinding.instance.addPostFrameCallback((_) => _playSequence());
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _titleController.forward();
    _backgroundController.forward();

    // Step 1: Animate Fee
    await Future.delayed(const Duration(milliseconds: 500));
    _feeController.forward();
    for (int i = 0; i <= 11000; i += 550) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() => _fee = i);
    }

    // Step 2: Animate Coupons
    await Future.delayed(const Duration(milliseconds: 300));
    _couponController.forward();
    for (int i = 0; i <= 15000; i += 750) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() => _coupons = i);
    }

    // Step 3: Animate Savings
    await Future.delayed(const Duration(milliseconds: 400));
    _savingsController.forward();
    for (int i = 0; i <= 4000; i += 200) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() => _savings = i);
    }

    // Show final message
    setState(() => _showFinalMessage = true);

    // Fire confetti 🎉
    // _confettiController.play();
  }

  @override
  void dispose() {
    _feeController.dispose();
    _couponController.dispose();
    _savingsController.dispose();
    _titleController.dispose();
    _backgroundController.dispose();
    // _confettiController.dispose();
    super.dispose();
  }

  Widget _buildCouponCard(int index) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _couponController,
        curve: Interval(0.1 + index * 0.15, 1.0, curve: Curves.elasticOut),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced margin
        padding: const EdgeInsets.all(8), // Reduced padding
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(8), // Smaller border radius
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 6, // Reduced blur
              offset: const Offset(0, 3), // Smaller offset
            )
          ],
        ),
        child: const Icon(Icons.card_giftcard,
            color: Colors.white, size: 20), // Smaller icon
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _backgroundController,
        child: Container(
          margin: const EdgeInsets.all(16), // Reduced margin
          padding: const EdgeInsets.all(16), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Smaller radius
            gradient: const LinearGradient(
              colors: [
                Color(0xFF9C27B0),
                Color(0xFF7B1FA2),
                Color(0xFF6A1B9A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.7),
                blurRadius: 20, // Reduced blur
                spreadRadius: 3, // Reduced spread
                offset: const Offset(0, 5), // Smaller offset
              ),
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.7),
                blurRadius: 30, // Reduced blur
                spreadRadius: 5, // Reduced spread
                offset: const Offset(0, 10), // Smaller offset
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Background glow effect
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Smaller radius
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.5,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with animation
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _titleController,
                      curve: Curves.elasticOut,
                    ),
                    child: Text(
                        "🎉 Congratulations on becoming a Neo Select Customer 🎉",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18, // Smaller font size
                                shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4, // Reduced blur
                                offset: const Offset(0, 1), // Smaller offset
                              )
                            ])),
                  ),
                  const SizedBox(height: 20), // Reduced spacing

                  // Step 1 - Fee
                  FadeTransition(
                    opacity: _feeController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-0.5, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _feeController,
                        curve: Curves.easeOutBack,
                      )),
                      child: Container(
                        padding: const EdgeInsets.all(12), // Reduced padding
                        decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.circular(12), // Smaller radius
                            // border: Border.all(
                            //     color: Colors.white,
                            //     width: 1.0), // Thinner border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrange.withOpacity(0.2),
                                blurRadius: 8, // Reduced blur
                                spreadRadius: 1, // Reduced spread
                                offset: const Offset(0, 2), // Smaller offset
                              )
                            ]),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.payment,
                                color: Colors.white, size: 20), // Smaller icon
                            const SizedBox(width: 8), // Reduced spacing
                            Text("Paid ₹${_fee.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontSize: 18, // Smaller font
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Reduced spacing

                  // Step 2 - Coupons
                  FadeTransition(
                    opacity: _couponController,
                    child: Column(
                      children: [
                        const Text("Now Get Rewarded With:",
                            style: TextStyle(
                                fontSize: 16, // Smaller font
                                fontWeight: FontWeight.w500,
                                color: Colors.white70)),
                        const SizedBox(height: 10), // Reduced spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              5, (index) => _buildCouponCard(index)),
                        ),
                        const SizedBox(height: 12), // Reduced spacing
                        Text(
                            "Total Coupons Value: ₹${_coupons.toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontSize: 18, // Smaller font
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), // Reduced spacing

                  // Step 3 - Savings Highlight
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _savingsController,
                      curve: Curves.elasticOut,
                    ),
                    child: FadeTransition(
                      opacity: _savingsController,
                      child: Container(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFA000),
                                Color(0xFFFF8F00),
                                Color(0xFFFF6F00),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.orange.withOpacity(0.5),
                                  blurRadius: 15, // Reduced blur
                                  spreadRadius: 3, // Reduced spread
                                  offset: const Offset(0, 3)) // Smaller offset
                            ],
                            borderRadius:
                                BorderRadius.circular(16)), // Smaller radius
                        child: Column(
                          children: [
                            Text("You Save ₹${_savings.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontSize: 22, // Smaller font
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            if (_showFinalMessage)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8), // Reduced padding
                                child: Text("That's ₹4000 in benefits!",
                                    style: TextStyle(
                                        fontSize: 14, // Smaller font
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.9))),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Confetti Celebration 🎉
              // ConfettiWidget(
              //   confettiController: _confettiController,
              //   blastDirection: -pi / 2,
              //   emissionFrequency: 0.05,
              //   numberOfParticles: 20,
              //   maxBlastForce: 20,
              //   minBlastForce: 5,
              //   gravity: 0.2,
              //   colors: const [
              //     Colors.green,
              //     Colors.blue,
              //     Colors.pink,
              //     Colors.orange,
              //     Colors.purple
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
