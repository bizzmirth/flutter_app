import 'package:bizzmirth_app/screens/contact_us/contact_us.dart';
import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),

          const Row(
            children: [
              Icon(Icons.email, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text('support@uniqbizz.com',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),

          const Row(
            children: [
              Icon(Icons.phone, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text('+91 8010892265 / 0832-2438989',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),

          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  '304 - 306, Dempo Towers, Patto Plaza Panaji - Goa - 403001',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Get in Touch Button (Navigates to ContactUsPage)
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 81, 131, 246),
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Get in Touch'),
            ),
          ),
        ],
      ),
    );
  }
}
