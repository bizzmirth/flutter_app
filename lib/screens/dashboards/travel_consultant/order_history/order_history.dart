import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String selectedView = 'Month';
  DateTime currentDate = DateTime.now();
  int selectedDay = 28;
  final Map<DateTime, List<Map<String, Object>>> _tasks = {};

  String selectedFilter = 'All';
  int _rowsPerPage = 5;
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  DateTime? fromDate;
  DateTime? toDate;

  final List<String> filterOptions = AppData.orderHistoryFilterOptions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}
// TODO: complete the ui of the tc order history
