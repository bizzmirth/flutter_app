import 'dart:async';
import 'dart:io';
import 'package:bizzmirth_app/controllers/tc_controller/tc_customer_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_topup_wallet_controller.dart';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_list_model.dart';
import 'package:bizzmirth_app/models/tc_models/tc_topup_wallets/tc_topup_request_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/approve_tc_payments_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/pending_transactions_page.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/wallet_topup/transactions_history_page.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/widgets/animated_wallet_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final List<Color> colors = [Colors.blueAccent, Colors.purpleAccent];
  int currentColorIndex = 0;

  final List<Map<String, String>> _transactions = [];
  final List<Map<String, String>> _pendingTransactions = [];
  late AnimationController _controller;
  String? customerType;
  String? walletBalance;
  final TextEditingController _taRefNoController = TextEditingController();
  final TextEditingController _taRefNameCOntroller = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  String? _selectedPaymentMode;
  final List<String> _paymentModes = [
    'Cash',
    'Cheque',
    'UPI/NEFT',
  ];
  Map<String, File?> selectedFiles = {'Payment Proof': null};
  var savedImagePath = '';

  final TextEditingController _chequeNumberController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  void _clearFormFields() {
    setState(() {
      _amountController.clear();
      _selectedPaymentMode = null;

      _chequeNumberController.clear();
      _chequeDateController.clear();
      _bankNameController.clear();

      _transactionIdController.clear();

      selectedFiles.updateAll((key, value) => null);
    });

    Logger.info('Form fields cleared after successful submission');
  }

  Future<void> _submitForm() async {
    try {
      final controller =
          Provider.of<TcTopupWalletController>(context, listen: false);
      final uploadImage =
          Provider.of<TcCustomerController>(context, listen: false);
      if (!_formKey.currentState!.validate()) {
        Logger.error('Form validation failed');
        return;
      }

      if (_selectedPaymentMode == null) {
        Logger.error('Please select a payment mode');
        ToastHelper.showErrorToast(title: 'Please select a payment mode');
        return;
      }

      if (selectedFiles['Payment Proof'] == null) {
        Logger.error('Please upload payment proof');
        ToastHelper.showErrorToast(title: 'Please upload payment proof');
        return;
      }
      if (selectedFiles['Payment Proof'] != null) {
        await uploadImage.uploadImage(
            'payment_proof', selectedFiles['Payment Proof']!.path);
      }

      final cleanedPath = extractPathSegment(
          selectedFiles['Payment Proof']?.path ?? '', 'payment_proof/');
      final paymentRequest = TopUpRequest(
        taId: _taRefNoController.text,
        taFname: _taRefNameCOntroller.text.split(' ').first,
        taLname: _taRefNameCOntroller.text.split(' ').length > 1
            ? _taRefNameCOntroller.text.split(' ').last
            : '',
        taTopupAmt: _amountController.text,
        taPayMode: _selectedPaymentMode!,
        taChequeNo: _selectedPaymentMode == 'Cheque'
            ? _chequeNumberController.text
            : null,
        taChequeDate: _selectedPaymentMode == 'Cheque'
            ? _chequeDateController.text
            : null,
        taBankName:
            _selectedPaymentMode == 'Cheque' ? _bankNameController.text : null,
        taTransactionId: _selectedPaymentMode == 'UPI/NEFT'
            ? _transactionIdController.text
            : null,
        taRefImg: cleanedPath,
      );
      Logger.warning('TopUp Request: ${paymentRequest.toJson()}');
      final success =
          await controller.apiAddTcTopupWalletBalance(paymentRequest);
      if (success) {
        ToastHelper.showSuccessToast(
            title: 'Top-up request submitted successfully');
        _clearFormFields();
      } else {
        ToastHelper.showErrorToast(
            title: 'Failed to submit top-up request. Please try again.');
      }
    } catch (e) {
      Logger.error('Error submitting form: $e');
    }
  }

  Future<void> getData() async {
    final controller =
        Provider.of<TcTopupWalletController>(context, listen: false);
    final userDetails = await SharedPrefHelper().getLoginResponse();
    _taRefNoController.text = userDetails!.userId!;
    _taRefNameCOntroller.text =
        '${userDetails.userFname ?? ''} ${userDetails.userLname ?? ''}';
    walletBalance = controller.walletBalanceModel?.formattedBalance;
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
    Logger.success('$_balance');
  }

  void _rejectTransaction(int index) {
    setState(() {
      _pendingTransactions.removeAt(index);
    });
  }

  Future<void> _pickFile(String fileType) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result == null) return;

      final String originalPath = result.files.single.path!;

      final appDir = await getApplicationDocumentsDirectory();
      final bizmirthDir = Directory('${appDir.path}/bizmirth');

      if (!await bizmirthDir.exists()) {
        await bizmirthDir.create();
      }
      setState(() {
        selectedFiles[fileType] = File(savedImagePath);
      });

      String subFolderName;
      switch (fileType) {
        case 'Payment Proof':
          subFolderName = 'payment_proof';
          break;
        default:
          subFolderName = 'other_documents';
      }

      final typeDir = Directory('${bizmirthDir.path}/$subFolderName');
      if (!await typeDir.exists()) {
        await typeDir.create();
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      savedImagePath = '${typeDir.path}/$fileName';

      await File(originalPath).copy(savedImagePath);

      Logger.success('File saved to: $savedImagePath');

      setState(() {
        selectedFiles[fileType] = File(savedImagePath);
      });
    } catch (e) {
      Logger.error('Error picking file: $e');
    }
  }

  void _removeFile(String fileType) {
    setState(() => selectedFiles[fileType] = null);
  }

  @override
  void dispose() {
    // _taRefNoController.dispose();
    // _taRefNameCOntroller.dispose();
    _amountController.dispose();
    _chequeNumberController.dispose();
    _chequeDateController.dispose();
    _bankNameController.dispose();
    _transactionIdController.dispose();
    _controller.dispose();
    super.dispose();
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
      body: Consumer<TcTopupWalletController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AnimatedWalletCard(
                      formattedBalance:
                          controller.walletBalanceModel?.formattedBalance ??
                              '0.00'),
                  const SizedBox(height: 20),
                  _buildTopUpFields(context),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  const SizedBox(height: 10),
                  _buildNavigationButtons(controller.topUpRequests),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopUpFields(context) {
    // final controller = Provider.of<CustomerController>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyField('TA Reference ID', _taRefNoController.text),
        const SizedBox(height: 10),
        _buildReadOnlyField('TA Reference Name', _taRefNameCOntroller.text),
        const SizedBox(height: 10),
        _buildAmountField(),
        const SizedBox(height: 10),
        _buildPaymentModeDropdown(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
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
          onTap: _submitForm,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
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
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter Amount',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter an amount' : null,
    );
  }

  Widget _buildPaymentModeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedPaymentMode,
          hint: const Text('Select Payment Mode'),
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
        ),

        const SizedBox(height: 20),

        /// Conditionally Render Fields
        if (_selectedPaymentMode == 'Cash') _buildCashSection(),
        if (_selectedPaymentMode == 'Cheque') _buildChequeSection(),
        if (_selectedPaymentMode == 'UPI/NEFT') _buildUpiSection(),
      ],
    );
  }

  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadButton('Payment Proof'),
      ],
    );
  }

  Widget _buildChequeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadButton('Payment Proof'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _chequeNumberController,
          decoration: InputDecoration(
            labelText: 'Cheque Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter cheque number'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _chequeDateController,
          decoration: InputDecoration(
            labelText: 'Cheque Date',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter cheque date'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _bankNameController,
          decoration: InputDecoration(
            labelText: 'Bank Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter bank name' : null,
        ),
      ],
    );
  }

  Widget _buildUpiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadButton('Payment Proof'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _transactionIdController,
          decoration: InputDecoration(
            labelText: 'Transaction ID',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter transaction ID'
              : null,
        ),
      ],
    );
  }

  Widget _buildUploadButton(String fileType) {
    final file = selectedFiles[fileType];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pickFile(fileType),
          icon: const Icon(Icons.upload_file),
          label: Text(file == null ? 'Upload $fileType' : 'Replace $fileType'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        if (file != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(file,
                    height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () => _removeFile(fileType),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: Text('No $fileType selected',
                style: const TextStyle(color: Colors.black54)),
          ),
      ],
    );
  }

  Widget _buildNavigationButtons(List<TcTopupRequestList> topUpRequests) {
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
                        TransactionHistoryPage(transactions: topUpRequests),
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
                      pendingTransactions: topUpRequests,
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
