import 'dart:io';

import 'package:bizzmirth_app/controllers/admin_customer_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddReferralCustomer extends StatefulWidget {
  final PendingCustomer? pendingCustomer;
  final bool isViewMode;
  final bool isEditMode;
  const AddReferralCustomer(
      {super.key,
      this.pendingCustomer,
      this.isViewMode = false,
      this.isEditMode = false});

  @override
  _AddAddReferralCustomerState createState() => _AddAddReferralCustomerState();
}

class _AddAddReferralCustomerState extends State<AddReferralCustomer> {
  Map<String, dynamic> selectedFiles = {
    "Profile Picture": null,
    "Aadhar Card": null,
    "Pan Card": null,
    "Bank Passbook": null,
    "Voting Card": null,
    "Payment Proof": null,
  };
  String _selectedPayment = "Free";

  String _selectedPaymentMode = "Cash";
  var savedImagePath = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerRefNameController =
      TextEditingController();
  final TextEditingController _customerRefIdController =
      TextEditingController();
  final TextEditingController _taRefrenceIdController = TextEditingController();
  final TextEditingController _taRefrenceNameController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nomineeNameController = TextEditingController();
  final TextEditingController _nomineeRelationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _chequeNoController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _transactionIDController =
      TextEditingController();

  String _selectedGender = "---- Select Gender ----";
  String _selectedCountry = "---- Select Country ----";
  String _selectedState = "---- Select State ----";
  String _selectedCity = "---- Select City ----";

  String chequeNo = "";
  String chequeDate = "";
  String bankName = "";
  String transactionId = "";

  final GlobalKey<FormFieldState> _customerRefrenceIdKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _customerRefrenceNameKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _taRefrenceIdKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _taRefrenceNameKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState<String>> _paymentFeeKey = GlobalKey();

  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pincodeKey = GlobalKey<FormFieldState>();
  final _countryKey = GlobalKey<FormFieldState>();
  final _stateKey = GlobalKey<FormFieldState>();
  final _cityKey = GlobalKey<FormFieldState>();

  String _selectedCountryCode = '+91';

  String? _selectedCountryId;
  List<dynamic> _countries = [];
  List<String> _countryNames = [];

  String? _selectedStateId;
  List<dynamic> _states = [];
  List<String> _stateNames = [];

  String? _selectedCityId;
  List<dynamic> _cities = [];
  List<String> _cityNames = [];

  Future<void> _loadCountry() async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      List<dynamic> countries = await controller.apiGetCountry();

      _countries = countries;

      List<String> countryNames = countries
          .map<String>(
              (country) => country['country_name'] ?? "No Country Available")
          .toList();
      setState(() {
        _countryNames = countryNames;
        Logger.success("Countries: $_countryNames");
      });
    } catch (e, s) {
      Logger.error("Error fetching countries, Error: $e, Stacktrace: $s");
    }
  }

  Future<void> _loadStates(selectedCountryId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);

      List<dynamic> states = await controller.apiGetStates(selectedCountryId);
      _states = states;

      List<String> stateNames = states
          .map<String>((state) => state['state_name'] ?? "No State Available")
          .toList();

      setState(() {
        _stateNames = stateNames;
      });
      Logger.success("Fetched states from the api $states");
    } catch (e, s) {
      Logger.success("Error fetching states, Error: $e, Stacktrace $s");
    }
  }

  Future<void> _loadCities(selectedStateId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      List<dynamic> cities = await controller.apiGetCity(selectedStateId);
      _cities = cities;

      List<String> citiesNames = cities
          .map<String>((city) => city['city_name'] ?? "No cities available")
          .toList();

      setState(() {
        _cityNames = citiesNames;
      });
      Logger.success("Fetched cities from the api $cities");
    } catch (e, s) {
      Logger.error("Error fetching cities, Error: $e, StackTrace: $s");
    }
  }

  Future<void> getPincode(selectedCity) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final pincode = await controller.apiGetPincode(selectedCity);
      setState(() {
        _pincodeController.text = pincode;
      });
      Logger.success("Pincode fetched from the $pincode");
    } catch (e, s) {
      Logger.error("Error fetching pincode, Error: $e, Stacktrace: $s");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.pendingCustomer != null) {
      populatePendingReferralCustomer(widget.pendingCustomer!);
    }
    _loadCountry();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerController = context.read<CustomerController>();
      await customerController.getRegCustomerCount();

      _customerRefIdController.text = customerController.userCustomerId ?? "";
      _customerRefNameController.text =
          customerController.customerRefrenceName ?? "";

      _taRefrenceIdController.text = customerController.userTaReferenceNo ?? "";
      _taRefrenceNameController.text =
          customerController.userTaRefrenceName ?? "";
    });
  }

  Future<void> _submitForm() async {
    try {
      final controller =
          Provider.of<CustomerController>(context, listen: false);
      Map<String, String> documentPaths = {};
      final String customerType;
      final String paidAmount;
      selectedFiles.forEach((key, value) {
        if (value != null) {
          String filePath = value.path;

          switch (key) {
            case "Profile Picture":
              documentPaths['profilePicture'] = filePath;
              break;
            case "Aadhar Card":
              documentPaths['adharCard'] = filePath;
              break;
            case "Pan Card":
              documentPaths['panCard'] = filePath;
              break;
            case "Bank Passbook":
              documentPaths['bankPassbook'] = filePath;
              break;
            case "Voting Card":
              documentPaths['votingCard'] = filePath;
              break;
            case "Payment Proof":
              documentPaths['paymentProof'] = filePath;
          }
        }
      });
      if (selectedFiles["Profile Picture"] != null) {
        await controller.uploadImage(
            context, 'profile_pic', selectedFiles["Profile Picture"]!.path);
      }
      if (selectedFiles["Aadhar Card"] != null) {
        await controller.uploadImage(
            context, 'aadhar_card', selectedFiles["Aadhar Card"]!.path);
      }
      if (selectedFiles["Pan Card"] != null) {
        await controller.uploadImage(
            context, 'pan_card', selectedFiles["Pan Card"]!.path);
      }
      if (selectedFiles["Voting Card"] != null) {
        await controller.uploadImage(
            context, 'voting_card', selectedFiles["Voting Card"]!.path);
      }
      if (selectedFiles["Bank Passbook"] != null) {
        await controller.uploadImage(
            context, 'passbook', selectedFiles["Bank Passbook"]!.path);
      }
      if (selectedFiles["Payment Proof"] != null) {
        await controller.uploadImage(
            context, 'payment_proof', selectedFiles["Payment Proof"]!.path);
      }

      if (_selectedPaymentMode == "Cheque") {
        chequeNo = _chequeNoController.text;
        chequeDate = _chequeDateController.text;
        bankName = _bankNameController.text;
      } else if (_selectedPaymentMode == "UPI/NEFT") {
        transactionId = _transactionIDController.text;
      }

      if (_selectedPayment == "Free") {
        customerType = "Free";
        paidAmount = "Free";
      } else if (_selectedPayment == "Prime: ₹ 10,000") {
        customerType = "Prime";
        paidAmount = "10,000";
      } else if (_selectedPayment == "Premium: ₹ 30,000") {
        customerType = "Premium";
        paidAmount = "30,000";
      } else {
        customerType = "Premium Plus";
        paidAmount = "35,000";
      }

      final newCustomer = PendingCustomer()
        ..taReferenceNo = _taRefrenceIdController.text
        ..taReferenceName = _taRefrenceNameController.text
        ..cuRefId = _customerRefIdController.text
        ..cuRefName = _customerRefNameController.text
        ..firstname = _firstNameController.text
        ..lastname = _lastNameController.text
        ..nomineeName = _nomineeNameController.text
        ..nomineeRelation = _nomineeRelationController.text
        ..email = _emailController.text
        ..dob = _dateController.text
        ..gender = _selectedGender
        ..countryCd = _selectedCountryCode
        ..phoneNumber = _phoneController.text
        ..country = _selectedCountryId
        ..state = _selectedStateId
        ..city = _selectedCityId
        ..pincode = _pincodeController.text
        ..address = _addressController.text
        ..profilePicture = documentPaths['profilePicture']
        ..compChek = "2"
        ..adharCard = documentPaths['adharCard']
        ..panCard = documentPaths['panCard']
        ..bankPassbook = documentPaths['bankPassbook']
        ..votingCard = documentPaths['votingCard']
        ..paymentProof = documentPaths['paymentProof']
        ..registerBy = "10"
        ..registrant = _customerRefIdController.text
        ..paymentMode = _selectedPaymentMode
        ..chequeNo = chequeNo
        ..chequeDate = chequeDate
        ..bankName = bankName
        ..transactionNo = transactionId
        ..paidAmount = paidAmount // payment fee
        ..customerType = customerType;

      await controller.apiAddCustomer(newCustomer);
      // clearFormFields();
      Navigator.pop(context);

      // userId = "undefined";
    } catch (e, s) {
      Logger.error("Error submitting form: $e, Stacktrace: $s");
    }
  }

  Future<void> _updatePendingReferralCustomer() async {
    try {
      final controller =
          Provider.of<CustomerController>(context, listen: false);
      Map<String, String> documentPaths = {};
      final String customerType;
      final String paidAmount;

      // Handle file uploads (only upload if new files are selected)
      selectedFiles.forEach((key, value) {
        if (value != null) {
          String filePath;

          // Check if it's a new file (File object) or existing URL (String)
          if (value is File) {
            filePath = value.path;
          } else {
            filePath = value.toString(); // It's already a URL
          }

          switch (key) {
            case "Profile Picture":
              documentPaths['profilePicture'] = filePath;
              break;
            case "Aadhar Card":
              documentPaths['adharCard'] = filePath;
              break;
            case "Pan Card":
              documentPaths['panCard'] = filePath;
              break;
            case "Bank Passbook":
              documentPaths['bankPassbook'] = filePath;
              break;
            case "Voting Card":
              documentPaths['votingCard'] = filePath;
              break;
            case "Payment Proof":
              documentPaths['paymentProof'] = filePath;
          }
        }
      });

      // Only upload new files (File objects, not existing URLs)
      if (selectedFiles["Profile Picture"] != null &&
          selectedFiles["Profile Picture"] is File) {
        await controller.uploadImage(
            context, 'profile_pic', selectedFiles["Profile Picture"]!.path);
      }
      if (selectedFiles["Aadhar Card"] != null &&
          selectedFiles["Aadhar Card"] is File) {
        await controller.uploadImage(
            context, 'aadhar_card', selectedFiles["Aadhar Card"]!.path);
      }
      if (selectedFiles["Pan Card"] != null &&
          selectedFiles["Pan Card"] is File) {
        await controller.uploadImage(
            context, 'pan_card', selectedFiles["Pan Card"]!.path);
      }
      if (selectedFiles["Voting Card"] != null &&
          selectedFiles["Voting Card"] is File) {
        await controller.uploadImage(
            context, 'voting_card', selectedFiles["Voting Card"]!.path);
      }
      if (selectedFiles["Bank Passbook"] != null &&
          selectedFiles["Bank Passbook"] is File) {
        await controller.uploadImage(
            context, 'passbook', selectedFiles["Bank Passbook"]!.path);
      }
      if (selectedFiles["Payment Proof"] != null &&
          selectedFiles["Payment Proof"] is File) {
        await controller.uploadImage(
            context, 'payment_proof', selectedFiles["Payment Proof"]!.path);
      }

      // Handle payment mode data
      if (_selectedPaymentMode == "Cheque") {
        chequeNo = _chequeNoController.text;
        chequeDate = _chequeDateController.text;
        bankName = _bankNameController.text;
      } else if (_selectedPaymentMode == "UPI/NEFT") {
        transactionId = _transactionIDController.text;
      }

      // Handle payment type
      if (_selectedPayment == "Free") {
        customerType = "Free";
        paidAmount = "Free";
      } else if (_selectedPayment == "Prime: ₹ 10,000") {
        customerType = "Prime";
        paidAmount = "10,000";
      } else if (_selectedPayment == "Premium: ₹ 30,000") {
        customerType = "Premium";
        paidAmount = "30,000";
      } else {
        customerType = "Premium Plus";
        paidAmount = "35,000";
      }

      final int id = widget.pendingCustomer!.id!;
      final updatedCustomer = PendingCustomer()
        ..id = id
        ..taReferenceNo = _taRefrenceIdController.text
        ..taReferenceName = _taRefrenceNameController.text
        ..cuRefId = _customerRefIdController.text
        ..cuRefName = _customerRefNameController.text
        ..firstname = _firstNameController.text
        ..lastname = _lastNameController.text
        ..nomineeName = _nomineeNameController.text
        ..nomineeRelation = _nomineeRelationController.text
        ..email = _emailController.text
        ..dob = _dateController.text
        ..gender = _selectedGender
        ..countryCd = _selectedCountryCode
        ..phoneNumber = _phoneController.text
        ..country = _selectedCountryId
        ..state = _selectedStateId
        ..city = _selectedCityId
        ..pincode = _pincodeController.text
        ..address = _addressController.text
        ..profilePicture = documentPaths['profilePicture']
        ..compChek = "2"
        ..adharCard = documentPaths['adharCard']
        ..panCard = documentPaths['panCard']
        ..bankPassbook = documentPaths['bankPassbook']
        ..votingCard = documentPaths['votingCard']
        ..paymentProof = documentPaths['paymentProof']
        ..registerBy = "10"
        ..registrant = _customerRefIdController.text
        ..paymentMode = _selectedPaymentMode
        ..chequeNo = chequeNo
        ..chequeDate = chequeDate
        ..bankName = bankName
        ..transactionNo = transactionId
        ..paidAmount = paidAmount
        ..customerType = customerType;

      await controller.apiUpdateCustomer(updatedCustomer);
      // Navigator.pop(context);
    } catch (e, s) {
      Logger.error("Error updating form: $e, Stacktrace: $s");
    }
  }

  void populatePendingReferralCustomer(PendingCustomer customer) async {
    try {
      _taRefrenceIdController.text = customer.taReferenceNo ?? "";
      _taRefrenceNameController.text = customer.taReferenceName ?? "";
      _customerRefIdController.text = customer.cuRefId ?? "";
      _customerRefNameController.text = customer.cuRefName ?? "";
      _firstNameController.text = customer.firstname ?? "";
      _lastNameController.text = customer.lastname ?? "";
      _nomineeNameController.text = customer.nomineeName ?? "";
      _nomineeRelationController.text = customer.nomineeRelation ?? "";
      _emailController.text = customer.email ?? "";
      _dateController.text = customer.dob ?? "";
      String countryCode = customer.countryCd!;
      if (!countryCode.startsWith('+')) {
        countryCode = '+$countryCode';
      }
      final allowedCodes = ["+91", "+1", "+44", "+61", "+971"];
      if (allowedCodes.contains(countryCode)) {
        _selectedCountryCode = countryCode;
      } else {
        _selectedCountryCode = '+91';
      }
      _selectedGender = normalizeGender(customer.gender!);
      _phoneController.text = customer.phoneNumber ?? "";
      _addressController.text = customer.address ?? "";
      _pincodeController.text = customer.pincode ?? "";
      _chequeNoController.text = customer.chequeNo ?? "";
      _chequeDateController.text = customer.chequeDate ?? "";
      _bankNameController.text = customer.bankName ?? "";
      _transactionIDController.text = customer.transactionNo ?? "";
      _selectedPaymentMode = customer.paymentMode!;
      if (customer.paidAmount == "Free") {
        _selectedPayment = "Free";
      } else if (customer.paidAmount == "10,000") {
        _selectedPayment = "Prime: ₹ 10,000";
      } else if (customer.paidAmount == "30,000") {
        _selectedPayment = "Premium: ₹ 30,000";
      } else {
        _selectedPayment = "Premium Plus: ₹ 35,000";
      }

      if (customer.profilePicture != null) {
        if (customer.profilePicture!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Profile Picture"] = customer.profilePicture!;
        } else {
          selectedFiles["Profile Picture"] =
              "https://testca.uniqbizz.com/uploading/${customer.profilePicture!}";
        }
        Logger.success(selectedFiles["Profile Picture"]);
      }

      if (customer.adharCard != null) {
        if (customer.adharCard!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Aadhar Card"] = customer.adharCard!;
        } else {
          selectedFiles["Aadhar Card"] =
              "https://testca.uniqbizz.com/uploading/${customer.adharCard!}";
        }
        Logger.success(selectedFiles["Aadhar Card"]);
      }

      if (customer.panCard != null) {
        if (customer.panCard!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Pan Card"] = customer.panCard!;
        } else {
          selectedFiles["Pan Card"] =
              "https://testca.uniqbizz.com/uploading/${customer.panCard!}";
        }
        Logger.success(selectedFiles["Pan Card"]);
      }

      if (customer.bankPassbook != null) {
        if (customer.bankPassbook!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Bank Passbook"] = customer.bankPassbook!;
        } else {
          selectedFiles["Bank Passbook"] =
              "https://testca.uniqbizz.com/uploading/${customer.bankPassbook!}";
        }
        Logger.success(selectedFiles["Bank Passbook"]);
      }

      if (customer.votingCard != null) {
        if (customer.votingCard!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Voting Card"] = customer.votingCard!;
        } else {
          selectedFiles["Voting Card"] =
              "https://testca.uniqbizz.com/uploading/${customer.votingCard!}";
        }
        Logger.success(selectedFiles["Voting Card"]);
      }

      if (customer.paymentProof != null) {
        if (customer.paymentProof!
            .startsWith("https://testca.uniqbizz.com/uploading/")) {
          selectedFiles["Payment Proof"] = customer.paymentProof!;
        } else {
          selectedFiles["Payment Proof"] =
              "https://testca.uniqbizz.com/uploading/${customer.paymentProof!}";
        }
        Logger.success(selectedFiles["Payment Proof"]);
      }

      if (_countries.isEmpty) {
        await _loadCountry();
      }

      final String countryId = customer.country!;
      _selectedCountryId = countryId;

      final countryObject = _countries.firstWhere(
        (country) => country['id'].toString() == countryId,
        orElse: () => {'country_name': '---- Select Country ----'},
      );

      setState(() {
        _selectedCountry =
            countryObject['country_name'] ?? '---- Select Country ----';
        Logger.success(
            "Set selected country to: $_selectedCountry with ID: $_selectedCountryId");
      });

      await _loadStates(_selectedCountryId);
      final String stateId = customer.state!;
      _selectedStateId = stateId;

      final stateObject = _states.firstWhere(
        (state) => state['id'].toString() == stateId,
        orElse: () => {'state_name': '---- Select State ----'},
      );

      setState(() {
        _selectedState = stateObject['state_name'] ?? '---- Select State ----';
        Logger.success(
            "Set selected state to: $_selectedState with ID: $_selectedStateId");
      });

      await _loadCities(_selectedStateId);
      final String cityId = customer.city!;
      _selectedCityId = cityId;

      final cityObject = _cities.firstWhere(
        (city) => city['id'].toString() == cityId,
        orElse: () => {'city_name': '---- Select City -----'},
      );

      setState(() {
        _selectedCity = cityObject['city_name'] ?? '---- Select City -----';
        Logger.success(
            "Set selected city $_selectedCity with ID: $_selectedCityId");
      });
    } catch (e, s) {
      Logger.error(
          "Error populating pending referral customer: $e, Stacktrace: $s");
    }
  }

  void _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result == null) return;

      String originalPath = result.files.single.path!;

      final appDir = await getApplicationDocumentsDirectory();
      final bizmirthDir = Directory('${appDir.path}/bizmirth');

      if (!await bizmirthDir.exists()) {
        await bizmirthDir.create();
      }

      String subFolderName;
      switch (fileType) {
        case "Profile Picture":
          subFolderName = "profile_pic";
          break;
        case "ID Proof":
          subFolderName = "id_proof";
          break;
        case "Bank Passbook":
          subFolderName = "passbook";
          break;

        case "Aadhar Card":
          subFolderName = "aadhar_card";
          break;
        case "Pan Card":
          subFolderName = "pan_card";
          break;
        case "Voting Card":
          subFolderName = "voting_card";
          break;
        case "Payment Proof":
          subFolderName = "payment_proof";
          break;
        default:
          subFolderName = "other_documents";
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
      Logger.error("Error picking file: $e");
    }
  }

  void _removeFile(String fileType) {
    setState(() {
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      String? Function(String?)? validator,
      GlobalKey<FormFieldState>? fieldKey,
      bool? forceReadOnly}) {
    return TextFormField(
      key: fieldKey,
      readOnly: forceReadOnly ?? widget.isViewMode,
      maxLines: maxLines,
      validator: validator,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        // ignore: deprecated_member_use
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        filled: true,
        // ignore: deprecated_member_use
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String selectedValue,
    Function(String?) onValueChanged, {
    String? Function(String?)? validator,
    String? emptyMessage,
    GlobalKey<FormFieldState>? fieldKey,
  }) {
    String defaultOption = "---- Select $label ----";

    // Handle empty items list with emptyMessage
    if (items.isEmpty && emptyMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.8))),
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emptyMessage, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    if (!items.contains(selectedValue) && selectedValue != defaultOption) {
      selectedValue = defaultOption;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: [
          DropdownMenuItem(
            enabled: widget.isViewMode,
            key: fieldKey,
            value: defaultOption, // Placeholder value
            child: Text(defaultOption, style: TextStyle(color: Colors.white)),
          ),
          ...items.map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(color: Colors.white),
              ))),
        ],
        onChanged: onValueChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
        dropdownColor: const Color.fromARGB(255, 129, 129, 129),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerController>(
        builder: (context, customerController, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Referral Customer',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: customerController.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          _buildTextField('Customer Reference Id *',
                              _customerRefIdController,
                              fieldKey: _customerRefrenceIdKey,
                              forceReadOnly: true, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer reference id';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          _buildTextField('Customer Reference Name *',
                              _customerRefNameController,
                              fieldKey: _customerRefrenceNameKey,
                              forceReadOnly: true, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer reference name';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          _buildTextField(
                              'TA Reference Id *', _taRefrenceIdController,
                              fieldKey: _taRefrenceIdKey,
                              forceReadOnly: true, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter TA reference id';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          _buildTextField(
                              'TA Refrence Name *', _taRefrenceNameController,
                              fieldKey: _taRefrenceNameKey,
                              forceReadOnly: true, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter TA reference name';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          _buildTextField(
                            'First Name*',
                            _firstNameController,
                            fieldKey: _firstNameKey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          _buildTextField('Last Name*', _lastNameController,
                              fieldKey: _lastNameKey, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                // Country code dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButton<String>(
                                    value: _selectedCountryCode,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedCountryCode = newValue!;
                                      });
                                    },
                                    items: ["+91", "+1", "+44", "+61", "+971"]
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: Text(value,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255))),
                                        ),
                                      );
                                    }).toList(),
                                    dropdownColor:
                                        const Color.fromARGB(255, 83, 83, 83),
                                    isExpanded: false,
                                    underline: SizedBox(),
                                  ),
                                ),
                                // Phone number text field
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    key: _mobileKey,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    decoration: InputDecoration(
                                      labelText: "Phone number",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.8)),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildTextField('Email *', _emailController,
                              fieldKey: _emailKey, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email name';
                            }
                            return null;
                          }),
                          SizedBox(height: 15),
                          _buildDropdown(
                              'Gender *',
                              ['Male', 'Female', 'Other'],
                              _selectedGender,
                              fieldKey: _genderKey,
                              (value) => setState(
                                    () {
                                      _selectedGender = value!;
                                    },
                                  ), validator: (value) {
                            if (value == null ||
                                value == "---- Select Gender * ----") {
                              return 'Please select a gender';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly:
                                  true, // Makes the TextFormField non-editable
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Date of Birth *',
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                suffixIcon: _dateController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _dateController.clear();
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _dateController.text.isNotEmpty
                                      ? DateFormat('dd-MM-yyyy')
                                          .parse(_dateController.text)
                                      : DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _dateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildDropdown('Country *', _countryNames,
                              fieldKey: _countryKey, validator: (value) {
                            if (value == null ||
                                value == "---- Select Country * ----") {
                              return 'Please select a Country';
                            }
                            return null;
                          },
                              _selectedCountry,
                              (value) => setState(() {
                                    _selectedCountry = value!;
                                    final selectedCountryObject =
                                        _countries.firstWhere(
                                            (country) =>
                                                country['country_name'] ==
                                                value,
                                            orElse: () => null);
                                    if (selectedCountryObject != null) {
                                      _selectedCountryId =
                                          selectedCountryObject['id']
                                              .toString();
                                      Logger.success(
                                          "selected country is $_selectedCountry ID : $_selectedCountryId");
                                    }
                                    _loadStates(_selectedCountryId);
                                  })),
                          SizedBox(height: 10),
                          _buildDropdown('State *', _stateNames,
                              fieldKey: _stateKey,
                              emptyMessage: "Please select a country first",
                              validator: (value) {
                            if (value == null ||
                                value == "---- Select State * ----") {
                              return 'Please select a state';
                            }
                            return null;
                          },
                              _selectedState,
                              (value) => setState(() {
                                    _selectedState = value!;

                                    final selectedStateObject =
                                        _states.firstWhere(
                                            (state) =>
                                                state['state_name'] == value,
                                            orElse: () => null);
                                    if (selectedStateObject != null) {
                                      _selectedStateId =
                                          selectedStateObject['id'].toString();
                                      Logger.success(
                                          "selected state is $_selectedState ID : $_selectedStateId");
                                      _loadCities(_selectedStateId);
                                    }
                                  })),
                          SizedBox(height: 10),
                          _buildDropdown('City *', _cityNames, _selectedCity,
                              emptyMessage: "Please select a state first",
                              fieldKey: _cityKey, validator: (value) {
                            if (value == null ||
                                value == "---- Select City * ----") {
                              return 'Please select a city';
                            }
                            return null;
                          },
                              (value) => setState(() {
                                    _selectedCity = value!;
                                    final selectedCityObject =
                                        _cities.firstWhere(
                                            (city) =>
                                                city['city_name'] == value,
                                            orElse: () => null);
                                    if (selectedCityObject != null) {
                                      _selectedCityId =
                                          selectedCityObject['id'].toString();
                                      Logger.success(
                                          "selected city is $_selectedCity ID : $_selectedCityId");
                                    }
                                    getPincode(_selectedCityId);
                                  })),
                          SizedBox(height: 10),
                          _buildTextField('Pincode *', _pincodeController,
                              fieldKey: _pincodeKey, validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pincode is required';
                            }
                            return null;
                          }, forceReadOnly: true),
                          SizedBox(height: 15),
                          _buildTextField(
                            'Address *',
                            _addressController,
                            fieldKey: _addressKey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          _buildDropdown(
                              'Payment Fee *',
                              [
                                'Free',
                                'Prime: ₹ 10,000',
                                'Premium: ₹ 30,000',
                                'Premium Plus: ₹ 35,000'
                              ],
                              _selectedPayment,
                              fieldKey: _paymentFeeKey,
                              (value) => setState(() {
                                    _selectedPayment = value!;
                                    Logger.success(
                                        "Customer Type : $_selectedPayment");
                                  }), validator: (value) {
                            if (value == null ||
                                value == "---- Select Payment Fee * ----") {
                              return 'Please select a payment fee';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          if (_selectedPayment != "Free")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Payment Mode * ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: ["Cash", "Cheque", "UPI/NEFT"]
                                        .map((package) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedPaymentMode = package;
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Radio<String>(
                                              value: package,
                                              groupValue: _selectedPaymentMode,
                                              activeColor: Colors
                                                  .white, // Change radio button color
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedPaymentMode = value!;
                                                  Logger.success(
                                                      "Selected payment Mode: $_selectedPaymentMode");
                                                });
                                              },
                                            ),
                                            Text(
                                              package,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors
                                                    .white, // Gray out text if disabled
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    10), // Spacing between radio buttons
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 10),
                          if (_selectedPaymentMode == "Cheque") ...{
                            _buildTextField('Check No. *', _chequeNoController),
                            SizedBox(height: 10),
                            _buildTextField(
                                'Cheque  Date *', _chequeDateController),
                            SizedBox(height: 10),
                            _buildTextField('Bank Name *', _bankNameController),
                            SizedBox(height: 10),
                          } else if (_selectedPaymentMode == "UPI/NEFT") ...{
                            _buildTextField(
                                'Transaction No. *', _transactionIDController),
                            SizedBox(height: 10),
                          },
                          SizedBox(height: 20),
                          Text(
                            "Attachments",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildUploadButton("Profile Picture"),
                          _buildUploadButton("Aadhar Card"),
                          _buildUploadButton("Pan Card"),
                          _buildUploadButton("Bank Passbook"),
                          _buildUploadButton("Voting Card"),
                          if (_selectedPayment != "Free")
                            _buildUploadButton("Payment Proof"),
                          SizedBox(height: 20),
                          if (widget.isEditMode) ...[
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (widget.pendingCustomer != null) {
                                    _updatePendingReferralCustomer();
                                    // employeeController.updatePendingEmployees(pending);
                                  }

                                  //  else if (widget. != null) {
                                  //   updateRegisteredEmployee();
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 16),
                                ),
                              ),
                            ),
                          ] else if (!widget.isViewMode) ...[
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitForm();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 16),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildUploadButton(String fileType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          if (!widget.isViewMode) // later change this to isViewMode
            ElevatedButton.icon(
              onPressed: () => _pickFile(fileType),
              icon: Icon(Icons.upload_file),
              label: Text("Upload $fileType"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          SizedBox(height: 8),
          if (selectedFiles[fileType] != null)
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: selectedFiles[fileType] is File
                        ? Image.file(
                            selectedFiles[fileType]!,
                            fit: BoxFit.cover,
                          )
                        : (selectedFiles[fileType] != null &&
                                selectedFiles[fileType].toString().isNotEmpty)
                            ? Image.network(
                                selectedFiles[fileType],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Image unavailable",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Image.network(
                                selectedFiles[fileType],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                  ),
                ),
                if (!widget.isViewMode)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () => _removeFile(fileType),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  // widget.isViewMode ? "No $fileType available"
                  "No $fileType uploaded",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
