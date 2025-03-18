import 'dart:async';

import 'package:bizzmirth_app/screens/dashboards/admin/approve_tc_payments_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/pending_transactions_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/transactions_history_page.dart';
import 'package:flutter/material.dart';

class TopUpWalletPage extends StatefulWidget {
  @override
  _TopUpWalletPageState createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends State<TopUpWalletPage>
    with SingleTickerProviderStateMixin {
  double _balance = 0;
  List<Map<String, String>> _transactions = [];
  List<Map<String, String>> _pendingTransactions = [];
  late AnimationController _controller;

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
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
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
        title: Text('Topup Wallet', style: TextStyle(color: Colors.white)),
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
            _buildTopUpFields(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPendingTransaction,
              child: Text(
                "Add Balance",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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

  Widget _buildTopUpFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyField("TA Reference ID", "TA12345"),
        SizedBox(height: 10),
        _buildReadOnlyField("TA Reference Name", "John Doe"),
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
              width: 240, // Match Summary Card Width
              height: 120, // Match Summary Card Height
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
        ElevatedButton(
          onPressed: () {
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
          child: Text(
            "Approve Payments",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionHistoryPage(transactions: _transactions),
              ),
            );
          },
          child: Text(
            "View Transaction History",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingTransactionsPage(
                  pendingTransactions:
                      _pendingTransactions, // Pass actual pending transactions
                ),
              ),
            );
          },
          child: Text(
            "View Pending History",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
