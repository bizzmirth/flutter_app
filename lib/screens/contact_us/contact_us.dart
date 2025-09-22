import 'package:bizzmirth_app/controllers/common_controllers/contact_us_controller.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/google_maps_widget.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bizzmirth_app/utils/constants.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late final WebViewController _controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.loadRequest(Uri.parse(
        'https://www.openstreetmap.org/export/embed.html?bbox=144.95000000000002%2C-37.82000000000001%2C144.96000000000004%2C-37.81000000000001&layer=mapnik'));
  }

  Future<void> submitMessageForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // ✅ Only runs if all validations pass
      final controller =
          Provider.of<ContactUsController>(context, listen: false);
      final String name = nameController.text;
      final String email = emailController.text;
      final String message = messageController.text;

      Logger.success('Send message $name, $email and $message');
      await controller.contactUs(context, name, email, message);
      clearInputFields();
    }
  }

  void clearInputFields() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactUsController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Contact Us', style: Appwidget.poppinsAppBarTitle()),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Let's Connect!", style: Appwidget.poppinsHeadline()),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          contactInfo(
                              Icons.phone, '+91 8010892265 / 0832-2438989'),
                          divider(),
                          contactInfo(Icons.email, 'support@uniqbizz.com'),
                          divider(),
                          contactInfo(Icons.location_on,
                              '304 - 306, Dempo Towers, Patto Plaza Panaji - Goa - 403001'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Send Us a Message',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  controller.isLoading
                      ? const SizedBox(
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            customInputField(
                                Icons.person, 'Your Name', nameController,
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            }),
                            const SizedBox(height: 15),
                            customInputField(
                                Icons.email, 'Your Email', emailController,
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            }),
                            const SizedBox(height: 15),
                            customInputField(Icons.message, 'Your Message',
                                messageController, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            }, maxLines: 5),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  submitMessageForm(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Send Message',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                  const GoogleMapsWidget(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
