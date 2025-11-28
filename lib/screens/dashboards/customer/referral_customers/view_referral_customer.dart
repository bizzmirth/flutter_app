import 'package:bizzmirth_app/screens/dashboards/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/mobile_view_referral_customer.dart';
import 'package:bizzmirth_app/services/responsive_layout.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:flutter/material.dart';

class ViewReferralCustomersPage extends StatefulWidget {
  const ViewReferralCustomersPage({super.key});

  @override
  State<ViewReferralCustomersPage> createState() =>
      _ViewReferralCustomersPageState();
}

class _ViewReferralCustomersPageState extends State<ViewReferralCustomersPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CDashboardPage(),
          ),
        );
      },
      appBar: AppBar(
        title: Text(
          'View Referral Customers',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      mobile: const MobileViewReferralCustomer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddReferralCustomer()),
          );

          // await customerController.apiGetRegisteredCustomers();
          // await customerController.apiGetPendingCustomers();
          // // Refresh filtered customers after API calls
          // _initializeFilteredCustomers();
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add New Referral Customer',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
