import 'package:bizzmirth_app/utils/google_maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/constants.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView
    _controller = WebViewController();
    _controller.loadRequest(Uri.parse(
        "https://www.openstreetmap.org/export/embed.html?bbox=144.95000000000002%2C-37.82000000000001%2C144.96000000000004%2C-37.81000000000001&layer=mapnik"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Let's Connect!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Contact Details (Glassmorphism Effect)
              Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      contactInfo(Icons.phone, "+123 456 7890"),
                      divider(),
                      contactInfo(Icons.email, "support@bizzmirth.com"),
                      divider(),
                      contactInfo(Icons.location_on,
                          "123 Bizzmirth Lane, City, Country"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Contact Form
              Text(
                "Send Us a Message",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),

              customInputField(Icons.person, "Your Name"),
              const SizedBox(height: 15),
              customInputField(Icons.email, "Your Email"),
              const SizedBox(height: 15),
              customInputField(Icons.message, "Your Message", maxLines: 5),
              const SizedBox(height: 20),

              // Animated Send Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Message Sent!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    "Send Message",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Embedded Map (Uncomment if needed)
              // SizedBox(
              //   height: 300,
              //   child: WebViewWidget(controller: _controller),
              // ),
              const GoogleMapsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
