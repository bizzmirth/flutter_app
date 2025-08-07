import 'package:flutter/material.dart';

class PremiumSelectCard extends StatelessWidget {
  const PremiumSelectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 40),

            SizedBox(width: 12),

            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Congratulations! You're a Premium Select Member",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Use points and vouchers to unlock premium & standard travel experiences.",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 12),

                  // Buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text("Premium Select Deals"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text("View Your Packages"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Optional: Image on the right
            SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/premium_user.png',
                width: 180,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
