import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedWalletCard extends StatefulWidget {
  final String formattedBalance;

  const AnimatedWalletCard({super.key, required this.formattedBalance});

  @override
  State<AnimatedWalletCard> createState() => _AnimatedWalletCardState();
}

class _AnimatedWalletCardState extends State<AnimatedWalletCard> {
  final List<Color> colors = [Colors.blueAccent, Colors.purpleAccent];
  int currentColorIndex = 0;
  double _balance = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Change gradient color every 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted) {
        setState(() {
          currentColorIndex = (currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ stop timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double newBalance =
        double.tryParse(widget.formattedBalance.replaceAll(',', '')) ?? 0.0;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: _balance, end: newBalance),
      onEnd: () {
        _balance = newBalance;
      },
      builder: (context, animatedValue, child) {
        return Container(
          width: 240,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                colors[currentColorIndex].withOpacity(0.8),
                colors[(currentColorIndex + 1) % colors.length]
                    .withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[currentColorIndex].withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      size: 35, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'MY WALLET',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '₹${animatedValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
