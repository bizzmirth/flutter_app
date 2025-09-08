import 'package:bizzmirth_app/controllers/customer_controller/cust_order_history_controller.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/widgets/invoice.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustOrderHistoryController>(
        builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Details',
            style: Appwidget.poppinsAppBarTitle(),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InvoiceWidget(
                    invoiceNumber: "BH20250407145238",
                    bookingNumber: "2025400001",
                    paymentStatus: "Successful",
                    transactionId: "Peid_17440175822015aq2Feipc101Tq3R HYNBPH",
                    customerId: "C12B0013",
                    customerName: "Somon M. G.",
                    customerEmail: "Somon@gmail.com",
                    customerPhone: "+98937584554",
                    package: "260 ANSD",
                    departureDate: "TS-Apr-2025",
                    memberCount: "Audit:1",
                    tourMembers: [
                      {'name': 'Charulata Shat', 'gender': 'Male', 'age': '60'},
                      {
                        'name': 'Murdeedharan Pillai',
                        'gender': 'Male',
                        'age': '60'
                      },
                      {'name': 'Soman M. G.', 'gender': 'Male', 'age': '27'},
                    ],
                    price: 9780.3)
              ],
            ),
          ),
        ),
      );
    });
  }
}
