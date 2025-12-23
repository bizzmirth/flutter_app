import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bizzmirth_app/controllers/tc_controller/tc_order_history_controller.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/invoice_pdf.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _saving = false;

  final GlobalKey previewContainer = GlobalKey(); // <– Only this needed

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) return true;

      final result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderHistoryData();
    });
  }

  Future<void> getOrderHistoryData() async {
    final controller =
        Provider.of<TcOrderHistoryController>(context, listen: false);
    await controller.apiGetOrderHistoryData();
  }

  // Hardcoded Sample Data
  final Map<String, dynamic> order = {
    'invoiceNo': 'BH20250920170912',
    'bookingNo': '2025900008',
    'paymentStatus': 'Successful',
    'transactionId': 'Paid_1758368354967CWCtpMvkqs4h2nAJg5HUlekCJ',
    'invoiceDate': '20-Sep-2025',
    'customer': {
      'orderId': '2025900008',
      'customerId': 'CU250013',
      'name': 'Teja Hadkonkar',
      'email': 'tejahadkonkar@gmail.com',
      'phone': '+919923666641',
      'package': 'Varanasi A Spiritual Journey',
      'departure': '26-Sep-2025',
      'members': 3
    },
    'tourMembers': [
      {'sr': 1, 'name': 'Teja Hadkonkar', 'gender': 'Female', 'age': 47},
      {'sr': 2, 'name': 'Tanvi Hadkonkar', 'gender': 'Female', 'age': 20},
      {'sr': 3, 'name': 'Sathyan Anthikad', 'gender': 'Male', 'age': 60},
    ],
    'amount': {
      'price': 44262,
      'coupon': '2025D651468C352',
      'couponAmount': 3000,
      'total': 41262
    }
  };

  // Capture full card as image
  Future<Uint8List> captureScreen() async {
    final boundary = previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _onDownload() async {
    setState(() => _saving = true);

    try {
      final granted = await requestStoragePermission();

      if (!granted) {
        ToastHelper.showInfoToast(title: 'Storage permission required');
        setState(() => _saving = false);
        return;
      }

      // TAKE SCREENSHOT
      final Uint8List screenBytes = await captureScreen();

      // PASS TO PDF MAKER
      final pdfBytes = await InvoicePdf.fromImage(screenBytes);

      // SAVE FILE
      final file =
          await _saveFile(pdfBytes, "invoice_${order['bookingNo']}.pdf");

      if (file != null) {
        await OpenFilex.open(file.path);
      }
    } catch (e) {
      ToastHelper.showErrorToast(title: 'Error: $e');
      Logger.error('Error: $e');
    }

    setState(() => _saving = false);
  }

  Future<File?> _saveFile(Uint8List bytes, String filename) async {
    try {
      Directory dir;

      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');

        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      Logger.error('Save file error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = order['customer'];
    final amount = order['amount'];
    final members = order['tourMembers'] as List;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          'Order Details',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _saving ? null : _onDownload,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.download),
            label: const Text(
              'Download Invoice',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Consumer<TcOrderHistoryController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RepaintBoundary(
              key: previewContainer,
              child: _buildInvoiceScreen(customer, amount, members, controller),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceScreen(Map<String, dynamic> customer, amount, members,
      TcOrderHistoryController controller) {
    return Column(
      children: [
        _buildMainInvoiceCard(order, customer, amount, members, controller),
        const SizedBox(height: 12),
        Text('304 - 306, Dempo Towers, Patto Plaza Panjim - Goa - 403001',
            style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  // --------------------------
  //  YOUR EXISTING UI METHODS
  // --------------------------

  Widget _buildMainInvoiceCard(Map order, Map customer, Map amount,
      List members, TcOrderHistoryController controller) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade400)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/Bizzmirth.png', width: 110, height: 70),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Invoice No: BH20250920170912',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Date: 20-Sep-2025',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Invoice To:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("${order['invoiceNo']}"),
                      Text('${order['customer']['email']}'),
                      Text("${order['customer']['phone']}"),
                      const Text('H.no. 100 Vodelim Bhati, Near Grand Hyat,'),
                      const Text('Ponda, Goa'),
                      Text("Customer ID: ${order['customer']['customerId']}"),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Bizzmirth Holidays Pvt Ltd:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('H.no. 100 Vodelim Bhati, Near Grand Hyat.'),
                    Text('403401'),
                    Text('support@bizzmirth.com'),
                    Text('0987654321'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            _buildBookingSection(order),
            const SizedBox(height: 14),
            _customerDetailsCard(order, controller),
            const SizedBox(height: 20),
            _buildTourMembersCard(members, controller),
            const SizedBox(height: 20),
            // _buildAmountCard(amount, controller),
            _buildInvoiceFooter(amount),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceFooter(Map amount) {
    return Column(
      children: [
        // const Divider(),
        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE — THANK YOU
            const Expanded(
              child: Text(
                'Thank You For Your Business',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // RIGHT SIDE — AMOUNT DETAILS
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _amountRow(
                  'Sub Total:',
                  '₹${amount['price']}',
                ),
                const SizedBox(height: 6),
                _amountRow(
                  'Coupon Applied:',
                  '- ₹${amount['couponAmount']}',
                ),
                Text(
                  '(${amount['coupon']})',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(thickness: 1),
                _amountRow(
                  'Total:',
                  '₹${amount['total']}',
                  isBold: true,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // FOOTER TEXT
        Column(
          children: [
            const Text(
              'This invoice is computer-generated.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'www.bizzmirth.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                Text(
                  'support@bizzmirth.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                Text(
                  '8080785714 / 8010892265',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _amountRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const SizedBox(width: 30),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSection(Map order) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Booking No:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              ' ${order['bookingNo']}',
            ),
          ],
        ),
        Row(
          children: [
            const Text('Payment:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            Text(' ${order['paymentStatus']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                )),
          ],
        ),
        Row(
          children: [
            const Text('Transaction ID:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              ' ${order['transactionId']}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _customerDetailsCard(Map order, TcOrderHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/Bizzmirth.png',
              width: 200,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text('Package: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text('Destination: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text('Departure Date: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text('Member count: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['customer']['orderId']),
                      Text(order['customer']['customerId']),
                      Text(order['customer']['name']),
                      Text(order['customer']['email']),
                      Text(order['customer']['phone']),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTourMembersCard(
      List members, TcOrderHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade400)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            'Tour Members',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // Header Row
          const Row(
            children: [
              SizedBox(width: 24, child: Text('#')),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Text('Name'),
              ),
              Expanded(
                flex: 2,
                child: Text('Gender'),
              ),
              Expanded(
                child: Text('Age'),
              ),
            ],
          ),
          const Divider(),

          // Data Rows
          ...members.map(
            (m) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text("${m['sr']}"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Text(m['name']),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(m['gender']),
                  ),
                  Expanded(
                    child: Text("${m['age']}"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
