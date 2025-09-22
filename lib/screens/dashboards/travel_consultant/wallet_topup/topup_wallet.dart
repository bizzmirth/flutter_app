import 'dart:async';

import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
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
  State<TopUpWalletPage> createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends State<TopUpWalletPage>
    with SingleTickerProviderStateMixin {
  double _balance = 0;
  final List<Map<String, String>> _transactions = [];
  final List<Map<String, String>> _pendingTransactions = [];
  late AnimationController _controller;
  String? customerType;

  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMode = 'Credit Card';
  final List<String> _paymentModes = [
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking'
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().getRegCustomerCount();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  Future<void> getSharedPrefData() async {
    customerType = await SharedPrefHelper().getUserType();
  }

  void _addPendingTransaction() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      _pendingTransactions.insert(0, {
        'id': 'TA12345',
        'name': 'John Doe',
        'amount': '₹${amount.toStringAsFixed(2)}',
        'mode': _selectedPaymentMode,
      });
    });

    _amountController.clear();
  }

  void _approveTransaction(int index) {
    setState(() {
      final transaction = _pendingTransactions.removeAt(index);
      _transactions.insert(0, transaction);
      final double amount =
          double.parse(transaction['amount']!.replaceAll('₹', ''));
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
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAnimatedWallet(),
            const SizedBox(height: 20),
            _buildTopUpFields(context),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _addPendingTransaction,
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Add Balance',
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
            const SizedBox(height: 10),
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
        _buildReadOnlyField(
            'TA Reference ID', controller.userTaReferenceNo ?? ''),
        const SizedBox(height: 10),
        _buildReadOnlyField(
            'TA Reference Name', controller.userTaRefrenceName ?? ''),
        const SizedBox(height: 10),
        _buildAmountField(),
        const SizedBox(height: 10),
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
        labelText: 'Enter Amount',
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
        labelText: 'Payment Mode',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAnimatedWallet() {
    final List<Color> colors = [Colors.blueAccent, Colors.purpleAccent];
    int currentColorIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        Timer.periodic(const Duration(seconds: 60000), (timer) {
          if (mounted) {
            setState(() {
              currentColorIndex = (currentColorIndex + 1) % colors.length;
            });
          }
        });

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: _balance - 50, end: _balance),
          builder: (context, value, child) {
            return Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colors[currentColorIndex].withValues(alpha: 0.8),
                    colors[(currentColorIndex + 1) % colors.length]
                        .withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet,
                          size: 35, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'MY WALLET',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '₹${value.toStringAsFixed(2)}',
                    style: const TextStyle(
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
        customerType == 'Admin'
            ? Container(
                width: 300,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withValues(alpha: 0.8),
                      Colors.purpleAccent.withValues(alpha: 0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
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
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Approve Payments',
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
            : const SizedBox(),
        const SizedBox(height: 12),
        Container(
          width: 300,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, color: Colors.blueAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'View Transaction History',
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
        const SizedBox(height: 12),
        Container(
          width: 300,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pending_actions,
                        color: Colors.blueAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'View Pending History',
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
