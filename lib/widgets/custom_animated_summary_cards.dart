import 'dart:async';
import 'dart:ui';

import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:flutter/material.dart';

class CustomAnimatedSummaryCards extends StatefulWidget {
  final List<SummaryCardData> cardData;

  const CustomAnimatedSummaryCards({super.key, required this.cardData});

  @override
  _AnimatedSummaryCardsState createState() => _AnimatedSummaryCardsState();
}

class _AnimatedSummaryCardsState extends State<CustomAnimatedSummaryCards> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.cardData
          .map((data) => Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: _buildCard(data),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCard(SummaryCardData data) {
    bool isWalletCard = data.title.contains('WALLET');

    return GestureDetector(
      onTap: isWalletCard
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletDetailsPage(),
                ),
              );
            }
          : null,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: 120,
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colors[_currentColorIndex].withOpacity(0.8),
              colors[(_currentColorIndex + 1) % colors.length].withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isWalletCard
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(data.icon, size: 35, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isWalletCard)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                ],
              ),
              Spacer(),
              Text(
                data.value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
