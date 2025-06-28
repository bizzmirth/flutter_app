import 'dart:io';

import 'package:bizzmirth_app/controllers/customer_controller.dart';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddcustPage extends StatefulWidget {
  final PendingCustomer? pendingCustomer;
  final bool isViewMode;
  final bool isEditMode;
  const AddcustPage(
      {super.key,
      this.pendingCustomer,
      this.isEditMode = false,
      this.isViewMode = false});

  @override
  // ignore: library_private_types_in_public_api
  _AddcustState createState() => _AddcustState();
}

class _AddcustState extends State<AddcustPage> {
  Map<String, dynamic> selectedFiles = {
    "Profile Picture": null,
    "Aadhar Card": null,
    "Pan Card": null,
    "Bank Passbook": null,
    "Voting Card": null,
  };
  var savedImagePath = "";
  String _selectedPaymentMode = "Cash";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _refNameController = TextEditingController();
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
  final TextEditingController _notesController = TextEditingController();
  bool _isComplimentary = false;

  String _selectedUserName = "---- Select User Id & Name * ----";
  String _selectedGender = "---- Select Gender ----";
  String _selectedCountry = "---- Select Country ----";
  String _selectedState = "---- Select State ----";
  String _selectedCity = "---- Select City ----";

  String _selectedPayment = "---- Select Payment Fee * ----";

  String _selectedCountryCode = '+91'; // Default country code

  final _userIdNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _refNameKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nomineeName = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nomineeRelation =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dojKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pincodeKey = GlobalKey<FormFieldState>();
  final _countryKey = GlobalKey<FormFieldState>();
  final _stateKey = GlobalKey<FormFieldState>();
  final _cityKey = GlobalKey<FormFieldState>();

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
          Provider.of<CustomerController>(context, listen: false);
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
          Provider.of<CustomerController>(context, listen: false);

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
          Provider.of<CustomerController>(context, listen: false);
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
          Provider.of<CustomerController>(context, listen: false);
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
    _loadCountry();
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
      selectedFiles[fileType] = null;
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      String? Function(String?)? validator,
      GlobalKey<FormFieldState>? fieldKey,
      bool? forceReadOnly}) {
    return TextFormField(
      key: fieldKey,
      // readOnly: forceReadOnly ?? widget.isViewMode,
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
    String defaultOption = "---- Select $label ----"; // Default placeholder

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
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Text(emptyMessage, style: TextStyle(color: Colors.red[300])),
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
        value: selectedValue, // Use the provided selected value
        items: [
          DropdownMenuItem(
            enabled: widget.isViewMode, // change with is viewmode
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
        onChanged: widget.isViewMode ? null : onValueChanged,
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

  void submitForm(context) {
    try {
      final name = '${_firstNameController.text} ${_lastNameController.text}';
      final nomineeName = _nomineeNameController.text;
      final nomineeRelation = _nomineeRelationController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;
      final dob = _dateController.text;
      final pincode = _pincodeController.text;
      final address = _addressController.text;

      Logger.success(
          "$name, $nomineeRelation, $nomineeName, $phone, $email, $dob, $pincode, $address");
    } catch (e, s) {
      Logger.error("Error Submitting Form, Error: $e Stacktree $s");
    }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Complimentary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Checkbox(
                          value: _isComplimentary,
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                          onChanged: (bool? value) {
                            setState(() {
                              _isComplimentary = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildDropdown(
                    'User Id & Name *',
                    ['Margao', 'Panjim', 'Other'],
                    _selectedUserName,
                    (String? value) {
                      // Handle the selection change
                      setState(() {
                        _selectedUserName = value!;
                      });
                    },
                    fieldKey: _userIdNameKey,
                    validator: (value) {
                      if (value == null ||
                          value == "---- Select User Id & Name * ----") {
                        return 'Please select a user id and name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextField('Reference Name *', _refNameController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Reference name is required';
                    }
                    return null;
                  }, fieldKey: _refNameKey, forceReadOnly: true),
                  SizedBox(height: 15),
                  _buildTextField('First Name*', _firstNameController,
                      fieldKey: _firstNameKey, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  }),
                  SizedBox(height: 15),
                  _buildTextField('Last Name*', _lastNameController,
                      fieldKey: _lastNameKey, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  }),
                  SizedBox(height: 15),
                  _buildTextField('Nominee Name*', _nomineeNameController,
                      fieldKey: _nomineeName, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter nominee name';
                    }
                    return null;
                  }),
                  SizedBox(height: 15),
                  _buildTextField(
                      'Nominee Relation*', _nomineeRelationController,
                      fieldKey: _nomineeRelation, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter nominee relation';
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
                                  width:
                                      50, // Adjust this value to reduce the width of each item
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
                            underline:
                                SizedBox(), // Hides the default underline
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: _mobileKey,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone name';
                              }
                              return null;
                            },
                            maxLength:
                                10, // Limit to typical phone number length
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
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
                              counterText: "", // Hide character counter
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                    if (value == null || value == "---- Select Gender * ----") {
                      return 'Please select a gender';
                    }
                    return null;
                  }),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true, // Makes the TextFormField non-editable
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth *',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        suffixIcon: _dateController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _dateController
                                        .clear(); // Clears the date when cancel button is pressed
                                  });
                                },
                              )
                            : null, // Only show cancel button if date is selected
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
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown('Country *', [""], fieldKey: _countryKey,
                      validator: (value) {
                    if (value == null ||
                        value == "---- Select Country * ----") {
                      return 'Please select a Country';
                    }
                    return null;
                  },
                      _selectedCountry,
                      (value) => setState(() {
                            _selectedCity = value!;
                            final selectedCountryObject = _countries.firstWhere(
                                (country) => country['country_name'] == value,
                                orElse: () => null);
                            if (selectedCountryObject != null) {
                              _selectedCountryId =
                                  selectedCountryObject['id'].toString();
                              Logger.success(
                                  "selected country is $_selectedCountry ID : $_selectedCountryId");
                            }
                            _loadStates(_selectedCountryId);
                          })),
                  SizedBox(height: 10),
                  _buildDropdown('State *', _stateNames, fieldKey: _stateKey,
                      validator: (value) {
                    if (value == null || value == "---- Select State * ----") {
                      return 'Please select a state';
                    }
                    return null;
                  },
                      _selectedState,
                      (value) => setState(() {
                            _selectedState = value!;

                            final selectedStateObject = _states.firstWhere(
                                (state) => state['state_name'] == value,
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
                      fieldKey: _cityKey, validator: (value) {
                    if (value == null || value == "---- Select City * ----") {
                      return 'Please select a city';
                    }
                    return null;
                  },
                      (value) => setState(() {
                            _selectedCity = value!;
                            final selectedCityObject = _cities.firstWhere(
                                (city) => city['city_name'] == value,
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
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Payment Mode * ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 2),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children:
                              ["Cash", "Cheque", "UPI/NEFT"].map((package) {
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
                    _buildTextField('Cheque  Date *', _chequeDateController),
                    SizedBox(height: 10),
                    _buildTextField('Bank Name *', _bankNameController),
                    SizedBox(height: 10),
                  } else if (_selectedPaymentMode == "UPI/NEFT") ...{
                    _buildTextField(
                        'Transaction No. *', _transactionIDController),
                    SizedBox(height: 10),
                  },
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
                      fieldKey: _genderKey,
                      (value) => setState(() {
                            _selectedPayment = value!;
                          }), validator: (value) {
                    if (value == null ||
                        value == "---- Select Payment Fee * ----") {
                      return 'Please select a payment fee';
                    }
                    return null;
                  }),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  _buildTextField('Extra Notes *', _notesController),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        submitForm(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Submit",
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

  Widget _buildUploadButton(String fileType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          if (true) // later change this to isViewMode
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
                                  // Instead of showing broken image icon for 404s,
                                  // we can show the same UI as "No $fileType uploaded"
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
                if (true) // later change this to isViewMode
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
