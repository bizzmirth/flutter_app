import 'dart:io';

import 'package:bizzmirth_app/controllers/admin_controller/admin_customer_controller.dart';
import 'package:bizzmirth_app/resources/app_data.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddCustomerTc extends StatefulWidget {
  // final PendingCustomer? pendingCustomer;
  // final RegisteredCustomer? registeredCustomer;
  final bool isViewMode;
  final bool isEditMode;
  const AddCustomerTc({
    super.key,
    this.isViewMode = false,
    this.isEditMode = false,
  });

  @override
  State<AddCustomerTc> createState() => _AddCustomerTc();
}

class _AddCustomerTc extends State<AddCustomerTc> {
  Map<String, dynamic> selectedFiles = {
    'Profile Picture': null,
    'Aadhar Card': null,
    'Pan Card': null,
    'Bank Passbook': null,
    'Voting Card': null,
    'Payment Proof': null,
  };

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taReferenceIdController =
      TextEditingController();
  final TextEditingController _taReferenceNameController =
      TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _chequeNoController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _transactionIDController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedPaymentMode = 'Cash';

  String _selectedGender = '---- Select Gender ----';
  String _selectedCountry = '---- Select Country ----';
  String _selectedState = '---- Select State ----';
  String _selectedCity = '---- Select City ----';

  String _selectedCountryCode = '+91'; // Default country code
  String _selectedPaymentFee = 'Free';
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

  Future<void> _loadStates(selectedCountryId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);

      final List<dynamic> states =
          await controller.apiGetStates(selectedCountryId);
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

  Future<void> _loadCities(selectedStateId) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final List<dynamic> cities = await controller.apiGetCity(selectedStateId);
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

  Future<void> getPincode(selectedCity) async {
    try {
      final controller =
          Provider.of<AdminCustomerController>(context, listen: false);
      final pincode = await controller.apiGetPincode(selectedCity);
      setState(() {
        _pincodeController.text = pincode;
      });
      Logger.success('Pincode fetched from the $pincode');
    } catch (e, s) {
      Logger.error('Error fetching pincode, Error: $e, Stacktrace: $s');
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
        value: selectedValue,
        items: [
          DropdownMenuItem(
            enabled: widget.isViewMode,
            key: fieldKey,
            value: defaultOption, // Placeholder value
            child: Text(defaultOption,
                style: const TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
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
                      'TA Reference ID *', _taReferenceIdController),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'TA Reference Name *', _taReferenceNameController),
                  const SizedBox(height: 15),
                  _buildTextField('First Name*', _fNameController),
                  const SizedBox(height: 15),
                  _buildTextField('Last Name*', _lNameController),
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
                          child: TextFormField(
                            controller: _phoneController,
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
                  const SizedBox(height: 10),
                  _buildTextField('Email *', _emailController),
                  const SizedBox(height: 15),
                  _buildDropdown(
                      'Gender *',
                      AppData.genderOptions,
                      _selectedGender,
                      (value) => setState(() {
                            _selectedGender = value!;
                          })),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
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
                      emptyMessage: 'Please select a country first.'),
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
                                _selectedCityId =
                                    selectedCityObject['id'].toString();
                                Logger.success(
                                    'selected city is $_selectedCity ID : $_selectedCityId');
                              }
                              getPincode(_selectedCityId);
                            },
                          ),
                      emptyMessage: 'Please select a state first'),
                  const SizedBox(height: 10),
                  _buildTextField('Pincode *', _pincodeController),
                  const SizedBox(height: 15),
                  _buildTextField('Address *', _addressController),
                  const SizedBox(height: 20),
                  _buildDropdown(
                      'Payment Fee *',
                      AppData.paymentFeeOptions,
                      _selectedPaymentFee,
                      (value) => setState(() {
                            _selectedPaymentFee = value!;
                          })),
                  const SizedBox(height: 10),
                  if (_selectedPaymentFee != 'Free')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Payment Mode * ',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 2),
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
                            children:
                                ['Cash', 'Cheque', 'UPI/NEFT'].map((package) {
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
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (_selectedPaymentMode == 'Cheque') ...[
                    _buildTextField('Cheque No. *', _chequeNoController,
                        // fieldKey: _chequeNoKey,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cheque No. is required';
                      }
                      return null;
                    }),
                    const SizedBox(height: 10),
                    _buildTextField('Cheque  Date *', _chequeDateController,
                        // fieldKey: _chequeDateKey,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cheque Date is required';
                      }
                      return null;
                    }),
                    const SizedBox(height: 10),
                    _buildTextField('Bank Name *', _bankNameController,
                        // fieldKey: _bankNameKey,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bank Date is required';
                      }
                      return null;
                    }),
                    const SizedBox(height: 10),
                  ] else if (_selectedPaymentMode == 'UPI/NEFT') ...[
                    _buildTextField(
                        'Transaction No. *', _transactionIDController,
                        // fieldKey: _transactionNoKey,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Transaction No. is required';
                      }
                      return null;
                    }),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Attachments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildUploadButton('Profile Picture',
                      showError: _showImageValidationErrors),
                  _buildUploadButton('Aadhar Card',
                      showError: _showImageValidationErrors),
                  _buildUploadButton('Pan Card',
                      showError: _showImageValidationErrors),
                  _buildUploadButton('Bank Passbook',
                      showError: _showImageValidationErrors),
                  _buildUploadButton('Voting Card',
                      showError: _showImageValidationErrors),
                  const SizedBox(height: 20),
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
                        'Submit',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String fileType,
      {bool showError = false, GlobalKey? uploadKey}) {
    final bool isRequired =
        fileType != 'Payment Proof' || _selectedPaymentFee != 'Free';
    final bool hasError =
        showError && isRequired && selectedFiles[fileType] == null;
    return Padding(
      key: uploadKey,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          if (!widget.isViewMode) // later change this to isViewMode
            ElevatedButton.icon(
              onPressed: () => _pickFile(fileType),
              icon: const Icon(Icons.upload_file),
              label: Text('Upload $fileType'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        : (selectedFiles[fileType] != null &&
                                selectedFiles[fileType].toString().isNotEmpty)
                            ? Image.network(
                                selectedFiles[fileType],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
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
                                          'Image unavailable',
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
                                  return const Center(
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
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                  ),
                ),
                if (!widget.isViewMode) // later change it to !widget.isViewMode
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
                  // widget.isViewMode ? "No $fileType available"
                  'No $fileType uploaded',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
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
            )
        ],
      ),
    );
  }
}
