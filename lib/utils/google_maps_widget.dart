import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
          <head>
            <style>
              body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
              iframe { height: 100%; width: 100%; border: 0; }
            </style>
          </head>
          <body>
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3844.783149457031!2d73.83217327595125!3d15.496092154524623!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bbfc09ca8f00001%3A0x6279e04cb8cc3fc8!2sBizzmirth!5e0!3m2!1sen!2sin!4v1741670946830!5m2!1sen!2sin" 
                    width="600" height="450" 
                    style="border:0;" 
                    allowfullscreen="" 
                    loading="lazy" 
                    referrerpolicy="no-referrer-when-downgrade">
            </iframe>
          </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust height as needed
      child: WebViewWidget(controller: controller),
    );
  }
}
