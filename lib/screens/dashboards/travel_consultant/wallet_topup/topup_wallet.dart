import 'dart:async';

import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/approve_tc_payments_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/pending_transactions_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/transactions_history_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopUpWalletPage extends StatefulWidget {
  final String title;
  const TopUpWalletPage({super.key, required this.title});

  @override
  _TopUpWalletPageState createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends State<TopUpWalletPage>
    with SingleTickerProviderStateMixin {
  double _balance = 0;
  List<Map<String, String>> _transactions = [];
  List<Map<String, String>> _pendingTransactions = [];
  late AnimationController _controller;
  String? customerType;

  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMode = "Credit Card";
  final List<String> _paymentModes = [
    "Credit Card",
    "Debit Card",
    "UPI",
    "Net Banking"
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().getRegCustomerCount();
    });
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }

  void getSharedPrefData() async {
    customerType = await SharedPrefHelper().getUserType();
  }

  void _addPendingTransaction() {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      _pendingTransactions.insert(0, {
        "id": "TA12345",
        "name": "John Doe",
        "amount": "₹${amount.toStringAsFixed(2)}",
        "mode": _selectedPaymentMode,
      });
    });

    _amountController.clear();
  }

  void _approveTransaction(int index) {
    setState(() {
      var transaction = _pendingTransactions.removeAt(index);
      _transactions.insert(0, transaction);
      double amount = double.parse(transaction["amount"]!.replaceAll("₹", ""));
      _balance += amount;
      _controller.forward(from: 0);
    });
  }

  void _rejectTransaction(int index) {
    setState(() {
      _pendingTransactions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAnimatedWallet(),
            SizedBox(height: 20),
            _buildTopUpFields(context),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _addPendingTransaction,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Add Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpFields(context) {
    final controller = Provider.of<CustomerController>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyField("TA Reference ID", controller.userTaReferenceNo!),
        SizedBox(height: 10),
        _buildReadOnlyField(
            "TA Reference Name", controller.userTaRefrenceName!),
        SizedBox(height: 10),
        _buildAmountField(),
        SizedBox(height: 10),
        _buildPaymentModeDropdown(),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Enter Amount",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPaymentModeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMode,
      onChanged: (newValue) {
        setState(() {
          _selectedPaymentMode = newValue!;
        });
      },
      items: _paymentModes.map((mode) {
        return DropdownMenuItem(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: "Payment Mode",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAnimatedWallet() {
    List<Color> colors = [Colors.blueAccent, Colors.purpleAccent];
    int _currentColorIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        Timer.periodic(Duration(seconds: 60000), (timer) {
          if (mounted) {
            setState(() {
              _currentColorIndex = (_currentColorIndex + 1) % colors.length;
            });
          }
        });

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800),
          tween: Tween<double>(begin: _balance - 50, end: _balance),
          builder: (context, value, child) {
            return Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colors[_currentColorIndex].withOpacity(0.8),
                    colors[(_currentColorIndex + 1) % colors.length]
                        .withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet,
                          size: 35, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "MY WALLET",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "₹${value.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        customerType == "Admin"
            ? Container(
                // width: 300,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.8),
                      Colors.purpleAccent.withOpacity(0.8)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApprovePaymentsPage(
                            pendingTransactions: _pendingTransactions,
                            approveTransaction: _approveTransaction,
                            rejectTransaction: _rejectTransaction,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Approve Payments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(height: 12),
        Container(
          width: 300,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionHistoryPage(transactions: _transactions),
                  ),
                );
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, color: Colors.blueAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "View Transaction History",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: 300,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingTransactionsPage(
                      pendingTransactions: _pendingTransactions,
                    ),
                  ),
                );
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pending_actions,
                        color: Colors.blueAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "View Pending History",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
