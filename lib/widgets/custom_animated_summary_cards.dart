import 'dart:async';
import 'package:bizzmirth_app/models/summarycard.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:bizzmirth_app/widgets/wallet_details_page.dart';
import 'package:flutter/material.dart';

class CustomAnimatedSummaryCards extends StatefulWidget {
  final List<SummaryCardData> cardData;

  const CustomAnimatedSummaryCards({super.key, required this.cardData});

  @override
  State<CustomAnimatedSummaryCards> createState() =>
      _AnimatedSummaryCardsState();
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

  List<List<SummaryCardData>> _chunkCards(
      List<SummaryCardData> cards, int size) {
    List<List<SummaryCardData>> chunks = [];
    for (var i = 0; i < cards.length; i += size) {
      int end = (i + size < cards.length) ? i + size : cards.length;
      chunks.add(cards.sublist(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    List<List<SummaryCardData>> rows = _chunkCards(widget.cardData, 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map(
            (row) => Row(
              children: row
                  .map(
                    (data) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(data),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCard(SummaryCardData data) {
    bool isWalletCard = data.title.contains('WALLET');
    bool isTopupWallet = data.title.contains('Topup Wallet');
    bool isCommissionCard = data.title.contains('Commision Earned');

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
          : isTopupWallet
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopUpWalletPage(
                        title: "Top Up Wallet",
                      ),
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
              colors[_currentColorIndex].withValues(alpha: 0.8),
              colors[(_currentColorIndex + 1) % colors.length]
                  .withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isWalletCard
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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
                  // Icon(data.icon, size: 35, color: Colors.white),
                  // SizedBox(width: 8),
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
                  if (isWalletCard || isTopupWallet)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    data.icon,
                    color: Colors.white,
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
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    isCommissionCard ? "Pending" : "This Month",
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Text(data.thisMonthValue ?? "",
                      style: TextStyle(color: Colors.white))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
