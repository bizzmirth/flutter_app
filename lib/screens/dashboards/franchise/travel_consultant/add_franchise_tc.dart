import 'dart:io';
import 'package:bizzmirth_app/controllers/admin_controller/admin_customer_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_controller.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_pending_tc.dart';
import 'package:bizzmirth_app/models/franchise_models/franchisee_registered_tc.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/services/my_navigator.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/common_functions.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddFranchiseTc extends StatefulWidget {
  final FranchiseeRegisteredTc? franchiseeRegisteredTc;
  final bool isViewMode;
  final bool isEditMode;
  const AddFranchiseTc({
    super.key,
    this.franchiseeRegisteredTc,
    this.isViewMode = false,
    this.isEditMode = false,
  });

  @override
  State<AddFranchiseTc> createState() => _AddFranchiseTcState();
}

class _AddFranchiseTcState extends State<AddFranchiseTc> {
  Map<String, dynamic> selectedFiles = {
    'Profile Picture': null,
    'Aadhar Card': null,
    'Pan Card': null,
    'Bank Passbook': null,
    'Voting Card': null,
    'Payment Proof': null,
  };

  final _formKey = GlobalKey<FormState>();
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  // ------------------------------- text controller for the form fields ---------------------------------------
  final TextEditingController _taReferenceIdController =
      TextEditingController();
  final TextEditingController _taReferenceNameController =
      TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _nomineeNameController = TextEditingController();
  final TextEditingController _nomineeRelationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _chequeNoController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _transactionIDController =
      TextEditingController();

  // selected option for dropdown with default already defined
  String _selectedCountryCode = '+91'; // Default country code
  String _selectedGender = '---- Select Gender ----';
  String _selectedCountry = '---- Select Country ----';
  String _selectedState = '---- Select State ----';
  String _selectedCity = '---- Select City ----';
  String _selectedPaymentFee = 'Free';
  String _selectedPaymentMode = 'Cash';

  String chequeNo = '';
  String chequeDate = '';
  String bankName = '';
  String transactionId = '';
  // Timer? _debounce;

  // ----------------------------- global form keys ---------------------------------------------
  final _taRefIdKey = GlobalKey<FormFieldState>();
  final _taRefNameKey = GlobalKey<FormFieldState>();
  final _fNameKey = GlobalKey<FormFieldState>();
  final _lNameKey = GlobalKey<FormFieldState>();
  final _nomineeName = GlobalKey<FormFieldState>();
  final _nomineeRelation = GlobalKey<FormFieldState>();
  final _mobileKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _genderKey = GlobalKey<FormFieldState>();
  final _dobKey = GlobalKey<FormFieldState>();
  final _countryKey = GlobalKey<FormFieldState>();
  final _stateKey = GlobalKey<FormFieldState>();
  final _cityKey = GlobalKey<FormFieldState>();
  final _pincodeKey = GlobalKey<FormFieldState>();
  final _addressKey = GlobalKey<FormFieldState>();
  final _paymentFeeKey = GlobalKey<FormFieldState>();
  final _paymentModeKey = GlobalKey<FormFieldState>();
  final _chequeNoKey = GlobalKey<FormFieldState>();
  final _chequeDateKey = GlobalKey<FormFieldState>();
  final _bankNameKey = GlobalKey<FormFieldState>();
  final _transactionNoKey = GlobalKey<FormFieldState>();
  final _profilePicKey = GlobalKey<FormFieldState>();
  final _aadharCardKey = GlobalKey<FormFieldState>();
  final _panCardKey = GlobalKey<FormFieldState>();
  final _bankPassbookKey = GlobalKey<FormFieldState>();
  final _votingCardKey = GlobalKey<FormFieldState>();
  final _paymentProofKey = GlobalKey<FormFieldState>();

  var savedImagePath = '';
  bool _showImageValidationErrors = false;

// --------------------- to store country data -------------------------------
  String? _selectedCountryId;
  List<dynamic> _countries = [];
  List<String> _countryNames = [];

// ------------------------ to store state data --------------------------------
  String? _selectedStateId;
  List<dynamic> _states = [];
  List<String> _stateNames = [];

// ------------------------- to store city data ------------------------
  String? _selectedCityId;
  List<dynamic> _cities = [];
  List<String> _cityNames = [];

  @override
  void initState() {
    super.initState();
    _loadCountry();
    if (widget.franchiseeRegisteredTc != null) {
      populateRegisteredTcData(widget.franchiseeRegisteredTc!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSharedPrefData();
    });
  }

  Future<void> _loadCountry() async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final List<dynamic> countries = await controller.apiGetCountry();

      _countries = countries;

      final List<String> countryNames = countries
          .map<String>(
              (country) => country['country_name'] ?? 'No Country Available')
          .toList();
      setState(() {
        _countryNames = countryNames;
        Logger.success('Countries: $_countryNames');
      });
    } catch (e, s) {
      Logger.error('Error fetching countries, Error: $e, Stacktrace: $s');
    }
  }

  Future<void> _loadStates(String? selectedCountryId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);

      final List<dynamic> states =
          await controller.apiGetStates(selectedCountryId!);
      _states = states;

      final List<String> stateNames = states
          .map<String>((state) => state['state_name'] ?? 'No State Available')
          .toList();

      setState(() {
        _stateNames = stateNames;
      });
      Logger.success('Fetched states from the api $states');
    } catch (e, s) {
      Logger.success('Error fetching states, Error: $e, Stacktrace $s');
    }
  }

  Future<void> _loadCities(String? selectedStateId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final List<dynamic> cities =
          await controller.apiGetCity(selectedStateId!);
      _cities = cities;

      final List<String> citiesNames = cities
          .map<String>((city) => city['city_name'] ?? 'No cities available')
          .toList();

      setState(() {
        _cityNames = citiesNames;
      });
      Logger.success('Fetched cities from the api $cities');
    } catch (e, s) {
      Logger.error('Error fetching cities, Error: $e, StackTrace: $s');
    }
  }

  Future<void> getPincode(String? selectedCity) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final pincode = await controller.apiGetPincode(selectedCity!);
      setState(() {
        _pincodeController.text = pincode;
      });
      Logger.success('Pincode fetched from the $pincode');
    } catch (e, s) {
      Logger.error('Error fetching pincode, Error: $e, Stacktrace: $s');
    }
  }

  void clearFormFields() {
    // 🧹 Clear all text controllers
    _taReferenceIdController.clear();
    _taReferenceNameController.clear();
    _fNameController.clear();
    _lNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _dateController.clear();
    _pincodeController.clear();
    _addressController.clear();
    _chequeNoController.clear();
    _chequeDateController.clear();
    _bankNameController.clear();
    _transactionIDController.clear();

    // 🧾 Reset dropdown selections to default values
    _selectedCountryCode = '+91';
    _selectedGender = '---- Select Gender ----';
    _selectedCountry = '---- Select Country ----';
    _selectedState = '---- Select State ----';
    _selectedCity = '---- Select City ----';
    _selectedPaymentFee = 'Free';
    _selectedPaymentMode = 'Cash';

    // 💳 Clear cheque/payment-related strings
    chequeNo = '';
    chequeDate = '';
    bankName = '';
    transactionId = '';

    selectedFiles.updateAll((key, value) => null);

    _formKey.currentState?.reset();

    setState(() {});
  }

  Future<void> getSharedPrefData() async {
    final loginData = await _sharedPrefHelper.getLoginResponse();
    if (loginData != null) {
      Logger.info('Login Data: $loginData');
      _taReferenceIdController.text = loginData.userId ?? 'N/A';
      _taReferenceNameController.text =
          '${loginData.userFname} ${loginData.userLname}';
    }
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
        _showImageValidationErrors =
            false; // Clear validation errors when user uploads
      });

      String subFolderName;
      switch (fileType) {
        case 'Profile Picture':
          subFolderName = 'profile_pic';
          break;
        case 'ID Proof':
          subFolderName = 'id_proof';
          break;
        case 'Bank Passbook':
          subFolderName = 'passbook';
          break;

        case 'Aadhar Card':
          subFolderName = 'aadhar_card';
          break;
        case 'Pan Card':
          subFolderName = 'pan_card';
          break;
        case 'Voting Card':
          subFolderName = 'voting_card';
          break;
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
    setState(() {
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      String? Function(String?)? validator,
      GlobalKey<FormFieldState>? fieldKey,
      bool? forceReadOnly,
      void Function(String)? onChanged}) {
    return TextFormField(
      key: fieldKey,
      readOnly: forceReadOnly ?? widget.isViewMode,
      maxLines: maxLines,
      validator: validator,
      controller: controller,
      onChanged: onChanged ??
          (value) {
            if (fieldKey?.currentState?.hasError == true) {
              fieldKey?.currentState?.validate();
            }
          },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
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
    final String defaultOption = '---- Select $label ----';

    // Handle empty items list with emptyMessage
    if (items.isEmpty && emptyMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withValues(alpha: 0.8))),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Text(emptyMessage, style: const TextStyle(color: Colors.red)),
          ),
        ],
      );
    }

    if (!items.contains(selectedValue) && selectedValue != defaultOption) {
      selectedValue = defaultOption;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
        key: fieldKey,
        items: [
          DropdownMenuItem(
            // enabled: widget.isViewMode,
            value: defaultOption, // Placeholder value
            child: Text(defaultOption,
                style: const TextStyle(color: Colors.white)),
          ),
          ...items.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
        onChanged: onValueChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255)
                  .withValues(alpha: 0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.2),
        ),
        dropdownColor: const Color.fromARGB(255, 129, 129, 129),
      ),
    );
  }

  bool _validateImages() {
    final List<String> requiredImages = [
      'Profile Picture',
      'Aadhar Card',
      'Pan Card',
      'Bank Passbook',
      'Voting Card'
    ];

    if (_selectedPaymentFee != 'Free') {
      requiredImages.add('Payment Proof');
    }

    for (String imageType in requiredImages) {
      if (selectedFiles[imageType] == null) {
        Logger.error('Missing required image: $imageType');
        return false;
      }
    }

    return true;
  }

  Future<void> _submitForm() async {
    try {
      setState(() {
        _showImageValidationErrors = false;
      });

      final controller =
          Provider.of<FranchiseeTcController>(context, listen: false);
      final formState = _formKey.currentState;
      final String customerType;
      final String paidAmount;
      final Map<String, String> documentPaths = {};
      final bool isFormValid = formState != null && formState.validate();
      final bool areImagesValid = _validateImages();

      if (!isFormValid || !areImagesValid) {
        if (!areImagesValid) {
          setState(() {
            _showImageValidationErrors = true;
          });
        }

        _scrollToFirstError();
        ToastHelper.showErrorToast(
            title:
                'Please fill all the required fields and upload required documents');
        return;
      }

      selectedFiles.forEach(
        (key, value) {
          if (value != null) {
            final String filePath = value.path;

            switch (key) {
              case 'Profile Picture':
                documentPaths['profilePicture'] = filePath;
                break;
              case 'Aadhar Card':
                documentPaths['adharCard'] = filePath;
                break;
              case 'Pan Card':
                documentPaths['panCard'] = filePath;
                break;
              case 'Bank Passbook':
                documentPaths['bankPassbook'] = filePath;
                break;
              case 'Voting Card':
                documentPaths['votingCard'] = filePath;
                break;
              case 'Payment Proof':
                documentPaths['paymentProof'] = filePath;
            }
          }
        },
      );

      // -------------------------------- upload the selected image ------------------------------------
      if (selectedFiles['Profile Picture'] != null) {
        await controller.uploadImage(
            'profile_pic', selectedFiles['Profile Picture']!.path);
      }
      if (selectedFiles['Aadhar Card'] != null) {
        await controller.uploadImage(
            'aadhar_card', selectedFiles['Aadhar Card']!.path);
      }
      if (selectedFiles['Pan Card'] != null) {
        await controller.uploadImage(
            'pan_card', selectedFiles['Pan Card']!.path);
      }
      if (selectedFiles['Voting Card'] != null) {
        await controller.uploadImage(
            'voting_card', selectedFiles['Voting Card']!.path);
      }
      if (selectedFiles['Bank Passbook'] != null) {
        await controller.uploadImage(
            'passbook', selectedFiles['Bank Passbook']!.path);
      }
      if (selectedFiles['Payment Proof'] != null) {
        await controller.uploadImage(
            'payment_proof', selectedFiles['Payment Proof']!.path);
      }
      if (_selectedPaymentMode == 'Cheque') {
        chequeNo = _chequeNoController.text;
        chequeDate = _chequeDateController.text;
        bankName = _bankNameController.text;
      } else if (_selectedPaymentMode == 'UPI/NEFT') {
        transactionId = _transactionIDController.text;
      }

      if (_selectedPaymentFee == 'Free') {
        customerType = 'Free';
        paidAmount = 'Free';
      } else if (_selectedPaymentFee == 'Prime: ₹ 10,000') {
        customerType = 'Prime';
        paidAmount = '10,000';
      } else if (_selectedPaymentFee == 'Premium: ₹ 30,000') {
        customerType = 'Premium';
        paidAmount = '30,000';
      } else {
        customerType = 'Premium Plus';
        paidAmount = '35,000';
      }

      final newTc = FranchiseePendingTc()
        ..userId = _taReferenceIdController.text
        ..registrant = _taReferenceNameController.text
        ..userType = '11'
        ..userIdName = _taReferenceIdController.text
        ..referenceName = _taReferenceNameController.text
        ..name = '${_fNameController.text} ${_lNameController.text}'
        ..firstName = _fNameController.text
        ..lastName = _lNameController.text
        ..nomineeName = _nomineeNameController.text
        ..nomineeRelation = _nomineeRelationController.text
        ..email = _emailController.text
        ..gender = formatGender(_selectedGender)
        ..countryCode = sanitizeCountryCode(_selectedCountryId)
        ..phone = _phoneController.text
        ..dob = _dateController.text
        ..aadharCard = documentPaths['adharCard']
        ..profilePic = documentPaths['profilePicture']
        ..panCard = documentPaths['panCard']
        ..passbook = documentPaths['bankPassbook']
        ..votingCard = documentPaths['votingCard']
        ..paymentProof = documentPaths['paymentProof']
        ..paymentFee = _selectedPaymentFee
        ..paymentMode = _selectedPaymentMode
        ..chequeNo = chequeNo
        ..chequeDate = chequeDate
        ..bankName = bankName
        ..transactionNo = transactionId
        ..address = _addressController.text
        ..pincode = _pincodeController.text
        ..country = _selectedCountryId
        ..state = _selectedStateId
        ..city = _selectedCityId;
      await controller.apiAddTc(newTc);
      clearFormFields();
      MyNavigator.pop(true);
    } catch (e, s) {
      Logger.error('Error submitting form: $e, Stacktrace: $s');
    }
  }

  void _scrollToFirstError() {
    final Map<String, GlobalKey<FormFieldState>> fieldKeys = {
      'firstName': _fNameKey,
      'lastName': _lNameKey,
      'phoneNumber': _mobileKey,
      'pincode': _pincodeKey,
      'dateOfBirth': _dobKey,
      'address': _addressKey
    };

    if (_selectedPaymentMode == 'Cheque') {
      fieldKeys.addAll({
        'chequeNo': _chequeNoKey,
        'chequeDate': _chequeDateKey,
        'bankName': _bankNameKey,
      });
    } else if (_selectedPaymentMode == 'UPI/NEFT') {
      fieldKeys.addAll({
        'transactionNo': _transactionNoKey,
      });
    }

    for (final entry in fieldKeys.entries) {
      final fieldState = entry.value.currentState;
      if (fieldState != null && fieldState.hasError) {
        Logger.error('Found error in field: ${entry.key}');
        Scrollable.ensureVisible(
          entry.value.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        return;
      }
    }

    if (_selectedGender == '---- Select Gender ----') {
      final RenderObject? renderObject =
          _genderKey.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          _genderKey.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        return;
      }
    }

    if (_selectedCountry == '---- Select Country ----') {
      final RenderObject? renderObject =
          _countryKey.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          _countryKey.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        return;
      }
    }
    if (_selectedState == '---- Select State ----') {
      final RenderObject? renderObject =
          _stateKey.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          _stateKey.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        return;
      }
    }

    if (_selectedCity == '---- Select City ----') {
      final RenderObject? renderObject =
          _cityKey.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          _cityKey.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        return;
      }
    }

    final Map<String, GlobalKey> imageKeys = {
      'Profile Picture': _profilePicKey,
      'Aadhar Card': _aadharCardKey,
      'Pan Card': _panCardKey,
      'Bank Passbook': _bankPassbookKey,
      'Voting Card': _votingCardKey,
    };

    if (_selectedPaymentFee != 'Free') {
      imageKeys['Payment Proof'] = _paymentProofKey;
    }

    for (final entry in imageKeys.entries) {
      final String imageType = entry.key;
      final GlobalKey imageKey = entry.value;

      if (selectedFiles[imageType] == null) {
        Logger.error('Missing required image: $imageType');

        // Show validation errors
        setState(() {
          _showImageValidationErrors = true;
        });

        // Scroll to the missing image upload button
        final RenderObject? renderObject =
            imageKey.currentContext?.findRenderObject();
        if (renderObject != null) {
          Scrollable.ensureVisible(
            imageKey.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          return;
        }
      }
    }
  }

  Future<void> populateRegisteredTcData(
      FranchiseeRegisteredTc franchiseeRegisteredTc) async {
    try {
      _fNameController.text = franchiseeRegisteredTc.firstname ?? '';
      _lNameController.text = franchiseeRegisteredTc.lastname ?? '';
      _nomineeNameController.text = franchiseeRegisteredTc.nomineeName ?? '';
      _nomineeRelationController.text =
          franchiseeRegisteredTc.nomineeRelation ?? '';
      String countryCode = franchiseeRegisteredTc.countryCode!;
      if (!countryCode.startsWith('+')) {
        countryCode = '+$countryCode';
      }
      final allowedCodes = ['+91', '+1', '+44', '+61', '+971'];
      if (allowedCodes.contains(countryCode)) {
        _selectedCountryCode = countryCode;
      } else {
        _selectedCountryCode = '+91';
      }
      _phoneController.text = franchiseeRegisteredTc.phone ?? '';
      _emailController.text = franchiseeRegisteredTc.email ?? '';
      _dateController.text = franchiseeRegisteredTc.dob ?? '';
      _selectedGender = normalizeGender(franchiseeRegisteredTc.gender!);
      _addressController.text = franchiseeRegisteredTc.address ?? '';
      _pincodeController.text = franchiseeRegisteredTc.pincode ?? '';
      _chequeNoController.text = franchiseeRegisteredTc.chequeNo ?? '';
      _chequeDateController.text = franchiseeRegisteredTc.chequeDate ?? '';
      _bankNameController.text = franchiseeRegisteredTc.bankName ?? '';
      _transactionIDController.text =
          franchiseeRegisteredTc.transactionNo ?? '';
      _selectedPaymentMode =
          franchiseeRegisteredTc.paymentMode![0].toUpperCase() +
              franchiseeRegisteredTc.paymentMode!.substring(1);

      if (franchiseeRegisteredTc.paymentMode == 'Free') {
        _selectedPaymentFee = 'Free';
      } else if (franchiseeRegisteredTc.paymentMode == '10000') {
        _selectedPaymentFee = 'Prime: ₹ 10,000';
      } else if (franchiseeRegisteredTc.paymentMode == '30000') {
        _selectedPaymentFee = 'Premium: ₹ 30,000';
      } else {
        _selectedPaymentFee = 'Premium Plus: ₹ 35000';
      }
      handleFile(
          selectedFiles, 'Profile Picture', franchiseeRegisteredTc.profilePic);
      handleFile(
          selectedFiles, 'Aadhar Card', franchiseeRegisteredTc.aadharCard);
      handleFile(selectedFiles, 'Pan Card', franchiseeRegisteredTc.panCard);
      handleFile(
          selectedFiles, 'Bank Passbook', franchiseeRegisteredTc.passbook);
      handleFile(
          selectedFiles, 'Voting Card', franchiseeRegisteredTc.votingCard);
      handleFile(
          selectedFiles, 'Payment Proof', franchiseeRegisteredTc.paymentProof);

      if (_countries.isEmpty) {
        await _loadCountry();
      }

      final String countryId = franchiseeRegisteredTc.country!;
      _selectedCountryId = countryId;

      final countryObject = _countries.firstWhere(
        (country) => country['id'].toString() == countryId,
        orElse: () => {'country_name': '---- Select Country ----'},
      );

      setState(() {
        _selectedCountry =
            countryObject['country_name'] ?? '---- Select Country ----';
        Logger.success(
            'Set selected country to: $_selectedCountry with ID: $_selectedCountryId');
      });

      await _loadStates(_selectedCountryId);
      final String stateId = franchiseeRegisteredTc.state!;
      _selectedStateId = stateId;

      final stateObject = _states.firstWhere(
        (state) => state['id'].toString() == stateId,
        orElse: () => {'state_name': '---- Select State ----'},
      );

      setState(() {
        _selectedState = stateObject['state_name'] ?? '---- Select State ----';
        Logger.success(
            'Set selected state to: $_selectedState with ID: $_selectedStateId');
      });

      await _loadCities(_selectedStateId);
      final String cityId = franchiseeRegisteredTc.city!;
      _selectedCityId = cityId;

      final cityObject = _cities.firstWhere(
        (city) => city['id'].toString() == cityId,
        orElse: () => {'city_name': '---- Select City -----'},
      );

      setState(() {
        _selectedCity = cityObject['city_name'] ?? '---- Select City -----';
        Logger.success(
            'Set selected city $_selectedCity with ID: $_selectedCityId');
      });
    } catch (e, s) {
      Logger.error('Error populating registered customer: $e, Stacktrace: $s');
      ToastHelper.showErrorToast(
          title: 'Error displaying registered customer. $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Add Travel Consultant';
    if (widget.isViewMode) {
      appBarTitle = 'View Travel Consultant';
    } else if (widget.isEditMode) {
      appBarTitle = 'Edit Travel Consultant';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: Appwidget.poppinsAppBarTitle(),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildTextField(
                    'User Id & Name',
                    _taReferenceIdController,
                    fieldKey: _taRefIdKey,
                    forceReadOnly: true,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Reference Name',
                    _taReferenceNameController,
                    fieldKey: _taRefNameKey,
                    forceReadOnly: true,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'First Name*',
                    _fNameController,
                    fieldKey: _fNameKey,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Last Name*',
                    _lNameController,
                    fieldKey: _lNameKey,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Nominee Name*',
                    _nomineeNameController,
                    fieldKey: _nomineeName,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Nominee Relation*',
                    _nomineeRelationController,
                    fieldKey: _nomineeRelation,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        // Country code dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCountryCode = newValue!;
                              });
                            },
                            items: AppData.countryCodeOptions.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  width:
                                      50, // Adjust this value to reduce the width of each item
                                  alignment: Alignment.center,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                              );
                            }).toList(),
                            dropdownColor:
                                const Color.fromARGB(255, 83, 83, 83),
                            underline:
                                const SizedBox(), // Hides the default underline
                          ),
                        ),
                        // Phone number text field
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            key: _mobileKey,
                            keyboardType: TextInputType.phone,
                            maxLength:
                                10, // Limit to typical phone number length
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              counterText: '', // Hide character counter
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Email *',
                    _emailController,
                    fieldKey: _emailKey,
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    'Gender *',
                    AppData.genderOptions,
                    _selectedGender,
                    (value) => setState(() {
                      _selectedGender = value!;
                    }),
                    fieldKey: _genderKey,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      key: _dobKey,
                      readOnly: true, // Makes the TextFormField non-editable
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth *',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        suffixIcon: _dateController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(_dateController.clear);
                                },
                              )
                            : null, // Only show cancel button if date is selected
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
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
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    'Country *',
                    _countryNames,
                    _selectedCountry,
                    (value) => setState(
                      () {
                        _selectedCountry = value!;
                        final selectedCountryObject = _countries.firstWhere(
                            (country) => country['country_name'] == value,
                            orElse: () => null);
                        if (selectedCountryObject != null) {
                          _selectedCountryId =
                              selectedCountryObject['id'].toString();
                          Logger.success(
                              'selected country is $_selectedCountry ID : $_selectedCountryId');
                        }
                        _loadStates(_selectedCountryId);
                      },
                    ),
                    fieldKey: _countryKey,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    'State *',
                    _stateNames,
                    _selectedState,
                    (value) => setState(
                      () {
                        _selectedState = value!;

                        final selectedStateObject = _states.firstWhere(
                            (state) => state['state_name'] == value,
                            orElse: () => null);
                        if (selectedStateObject != null) {
                          _selectedStateId =
                              selectedStateObject['id'].toString();
                          Logger.success(
                              'selected state is $_selectedState ID : $_selectedStateId');
                          _loadCities(_selectedStateId);
                        }
                      },
                    ),
                    emptyMessage: 'Please select a country first.',
                    fieldKey: _stateKey,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    'City *',
                    _cityNames,
                    _selectedCity,
                    (value) => setState(
                      () {
                        _selectedCity = value!;
                        final selectedCityObject = _cities.firstWhere(
                            (city) => city['city_name'] == value,
                            orElse: () => null);
                        if (selectedCityObject != null) {
                          _selectedCityId = selectedCityObject['id'].toString();
                          Logger.success(
                              'selected city is $_selectedCity ID : $_selectedCityId');
                        }
                        getPincode(_selectedCityId);
                      },
                    ),
                    emptyMessage: 'Please select a state first',
                    fieldKey: _cityKey,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'Pincode *',
                    _pincodeController,
                    fieldKey: _pincodeKey,
                    forceReadOnly: true,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    'Address *',
                    _addressController,
                    fieldKey: _addressKey,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(
                    'Payment Fee *',
                    AppData.paymentFeeFranchiseOptions,
                    _selectedPaymentFee,
                    (value) => setState(() {
                      _selectedPaymentFee = value!;
                    }),
                    fieldKey: _paymentFeeKey,
                  ),
                  const SizedBox(height: 10),
                  if (_selectedPaymentFee != 'Free')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        FormField<String>(
                          key: _paymentModeKey,
                          validator: (value) {
                            if (_selectedPaymentMode.isEmpty) {
                              return 'Please select a payment mode';
                            }
                            return null;
                          },
                          builder: (fieldState) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: 'Payment Mode * ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: ['Cash', 'Cheque', 'UPI/NEFT']
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
                                          // Radio<String>(
                                          //   value: package,
                                          //   groupValue:
                                          //       _selectedPaymentMode,
                                          //   activeColor: Colors
                                          //       .white, // Change radio button color
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedPaymentMode =
                                          //           value!;
                                          //       Logger.success(
                                          //           "Selected payment Mode: $_selectedPaymentMode");
                                          //     });
                                          //   },
                                          // ),
                                          RadioGroup<String>(
                                              groupValue: _selectedPaymentMode,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedPaymentMode = value!;
                                                  Logger.success(
                                                      'Selected payment Mode: $_selectedPaymentMode');
                                                });
                                              },
                                              child: Radio<String>(
                                                value: package,
                                              )),
                                          Text(
                                            package,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors
                                                  .white, // Gray out text if disabled
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  10), // Spacing between radio buttons
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              if (fieldState.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    fieldState.errorText ?? '',
                                    style: const TextStyle(
                                        color: Colors.redAccent, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (_selectedPaymentMode == 'Cheque') ...[
                    _buildTextField(
                      'Cheque No. *', _chequeNoController,
                      // fieldKey: _chequeNoKey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cheque No. is required';
                        }
                        return null;
                      },
                      fieldKey: _chequeNoKey,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Cheque  Date *', _chequeDateController,
                      // fieldKey: _chequeDateKey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cheque Date is required';
                        }
                        return null;
                      },
                      fieldKey: _chequeDateKey,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Bank Name *',
                      _bankNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bank Date is required';
                        }
                        return null;
                      },
                      fieldKey: _bankNameKey,
                    ),
                    const SizedBox(height: 10),
                  ] else if (_selectedPaymentMode == 'UPI/NEFT') ...[
                    _buildTextField(
                      'Transaction No. *',
                      _transactionIDController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Transaction No. is required';
                        }
                        return null;
                      },
                      fieldKey: _transactionNoKey,
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Attachments',
                    style: Appwidget.normalSubTitle(),
                  ),
                  const SizedBox(height: 10),
                  _buildUploadButton(
                    'Profile Picture',
                    showError: _showImageValidationErrors,
                    uploadKey: _profilePicKey,
                  ),
                  _buildUploadButton(
                    'Aadhar Card',
                    showError: _showImageValidationErrors,
                    uploadKey: _aadharCardKey,
                  ),
                  _buildUploadButton(
                    'Pan Card',
                    showError: _showImageValidationErrors,
                    uploadKey: _panCardKey,
                  ),
                  _buildUploadButton(
                    'Bank Passbook',
                    showError: _showImageValidationErrors,
                    uploadKey: _bankPassbookKey,
                  ),
                  _buildUploadButton(
                    'Voting Card',
                    showError: _showImageValidationErrors,
                    uploadKey: _votingCardKey,
                  ),
                  if (_selectedPaymentFee != 'Free')
                    _buildUploadButton(
                      'Payment Proof',
                      showError: _showImageValidationErrors,
                      uploadKey: _paymentProofKey,
                    ),
                  const SizedBox(height: 20),
                  if (widget.isEditMode) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  ] else if (!widget.isViewMode) ...[
                    Center(
                      child: Consumer<FranchiseeTcController>(
                        builder: (context, controller, child) {
                          return ElevatedButton(
                            onPressed: _submitForm, // disable while loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: controller.state == ViewState.loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.blueAccent,
                                    ),
                                  )
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.blueAccent, fontSize: 16),
                                  ),
                          );
                        },
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
  }

  Widget _buildUploadButton(
    String fileType, {
    bool showError = false,
    GlobalKey? uploadKey,
  }) {
    final bool isRequired =
        fileType != 'Payment Proof' || _selectedPaymentFee != 'Free';
    final bool hasError =
        showError && isRequired && selectedFiles[fileType] == null;

    Future<bool> isImageAvailable(String url) async {
      try {
        final response =
            await HttpClient().headUrl(Uri.parse(url)).then((r) => r.close());
        return response.statusCode == 200;
      } catch (_) {
        return false;
      }
    }

    return Padding(
      key: uploadKey,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // if (!widget.isViewMode)
          ElevatedButton.icon(
            onPressed: () => _pickFile(fileType),
            icon: const Icon(Icons.upload_file),
            label: Text('Upload $fileType'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (selectedFiles[fileType] != null)
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: selectedFiles[fileType] is File
                        ? Image.file(
                            selectedFiles[fileType]!,
                            fit: BoxFit.cover,
                          )
                        : FutureBuilder<bool>(
                            future: isImageAvailable(selectedFiles[fileType]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError ||
                                  snapshot.data == false) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Image unavailable',
                                        style: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Image.network(
                                  selectedFiles[fileType],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
                // if (!widget.isViewMode)
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
                      child: const Icon(
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  'No $fileType uploaded',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
                'Please Upload $fileType',
                style: TextStyle(color: Colors.red.shade300, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
