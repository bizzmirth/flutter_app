import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/add_packages/package_attachments.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/add_packages/package_itenary.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/add_packages/package_pricing.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/add_packages/package_selection_screen.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/packages/package_page/packages.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:flutter/material.dart';

class AddpackagesPage extends StatefulWidget {
  const AddpackagesPage({super.key});

  @override
  State<AddpackagesPage> createState() => _AddpackagesState();
}

class _AddpackagesState extends State<AddpackagesPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(_currentStep,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(_currentStep,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Package Details',
          style: Appwidget.poppinsAppBarTitle(),
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
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildProgressBar(),
            SizedBox(height: 30),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PackageSelectionScreen(),
                  PackageItenaryDetails(),
                  PackagePricingScreen(),
                  PackageAttachmentScreen()
                ],
              ),
            ),
            _buildNavigationButtons(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          bool isActive = index == _currentStep;
          bool isCompleted = index < _currentStep;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width / 5,
            height: 20,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(colors: [Colors.blue, Colors.cyan])
                  : isCompleted
                      ? LinearGradient(colors: [Colors.blue[200]!, Colors.cyan])
                      : LinearGradient(
                          colors: [Colors.grey, Colors.grey[700]!]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.7),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _currentStep > 0 ? _prevStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text("Back"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentStep < 3) {
                  _nextStep();
                } else {
                  // Navigate back to a specific page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PackagePage()), // Change this to your desired page
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                  _currentStep == 3 ? "Submit" : "Next"), // Change button text
            ),
          ],
        ),
      ],
    );
  }
}
