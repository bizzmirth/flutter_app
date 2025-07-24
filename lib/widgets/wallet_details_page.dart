import 'dart:async';

import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/topup_wallet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletDetailsPage extends StatefulWidget {
  const WalletDetailsPage({super.key});

  @override
  _WalletDetailsPageState createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends State<WalletDetailsPage> {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  int _currentColorIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % colors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance Card
            // AnimatedContainer(
            //   duration: Duration(seconds: 1),
            //   curve: Curves.easeInOut,
            //   width: double.infinity,
            //   padding: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     gradient: LinearGradient(
            //       colors: [
            //         colors[_currentColorIndex].withOpacity(0.9),
            //         colors[(_currentColorIndex + 1) % colors.length]
            //             .withOpacity(0.9),
            //       ],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         blurRadius: 12,
            //         offset: Offset(0, 6),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Row(
            //       //   children: [
            //       //     Icon(
            //       //       Icons.account_balance_wallet,
            //       //       size: 30,
            //       //       color: Colors.white,
            //       //     ),
            //       //     SizedBox(width: 10),
            //       //     Text(
            //       //       'Total Balance',
            //       //       style: TextStyle(
            //       //         fontSize: 18,
            //       //         fontWeight: FontWeight.w600,
            //       //         color: Colors.white,
            //       //       ),
            //       //     ),
            //       //   ],
            //       // ),
            //       // SizedBox(height: 15),
            //       // Text(
            //       //   '₹ 2,000',
            //       //   style: TextStyle(
            //       //     fontSize: 32,
            //       //     fontWeight: FontWeight.bold,
            //       //     color: Colors.white,
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),

            // SizedBox(height: 24),

            Text(
              'Wallet Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 16),

            // Wallet Options
            Row(
              children: [
                Expanded(
                  child: _buildWalletOptionCard(
                    title: 'TOP UP\nWALLET',
                    amount: '₹ 1,200',
                    icon: Icons.add_circle_outline,
                    onTap: () {
                      // Navigate to top up wallet page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpWalletPage(
                                  title: "Top Up Wallet",
                                )),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildWalletOptionCard(
                    title: 'REFERRAL\nWALLET',
                    amount: '₹ 800',
                    icon: Icons.people_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpWalletPage(
                                  title: "Referral Wallet",
                                )),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Quick Actions
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 8,
            //         offset: Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Quick Actions',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.grey[800],
            //         ),
            //       ),
            //       SizedBox(height: 16),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           _buildQuickActionButton(
            //             icon: Icons.add,
            //             label: 'Add Money',
            //             onTap: () {},
            //           ),
            //           _buildQuickActionButton(
            //             icon: Icons.send,
            //             label: 'Transfer',
            //             onTap: () {},
            //           ),
            //           _buildQuickActionButton(
            //             icon: Icons.history,
            //             label: 'History',
            //             onTap: () {},
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletOptionCard({
    required String title,
    required String amount,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: 140,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 28, color: Colors.white),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Spacer(),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18,
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

  // Widget _buildQuickActionButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: colors[_currentColorIndex].withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(
  //             icon,
  //             size: 24,
  //             color: colors[_currentColorIndex],
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
