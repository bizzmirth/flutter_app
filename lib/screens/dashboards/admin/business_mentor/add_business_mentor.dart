import 'dart:convert';
import 'dart:io';

import 'package:bizzmirth_app/controllers/admin_busniess_mentor_controller.dart';
import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddbmPage extends StatefulWidget {
  final PendingBusinessMentorModel? pendingBusinessMentor;
  final bool isViewMode;
  final bool isEditMode;
  const AddbmPage(
      {super.key,
      this.pendingBusinessMentor,
      this.isEditMode = false,
      this.isViewMode = false});

  @override
  // ignore: library_private_types_in_public_api
  _AddbmState createState() => _AddbmState();
}

class _AddbmState extends State<AddbmPage> {
  Map<String, dynamic> selectedFiles = {
    "Profile Picture": null,
    "Aadhar Card": null,
    "Pan Card": null,
    "Bank Passbook": null,
    "Voting Card": null,
    "Payment Proof": null,
  };

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _refNameController = TextEditingController();
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nomineeNameController = TextEditingController();
  final TextEditingController _nomineeRelationController =
      TextEditingController();
  final TextEditingController _chequeNoController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _transactionIDController =
      TextEditingController();
  String? selectedDesignationId = "";
  String? selectedCountryCode = "";
  String selectedGender = "---- Select Gender ----";
  String selectedCountry = "---- Select Country ----";
  String selectedState = "---- Select State ----";
  String selectedCity = "---- Select City ----";
  String _selectedDesignation = "---- Select Designation * ----";
  String _selectedZone = "---- Select Zone * ----";
  String _selectedBranch = "---- Select Branch * ----";
  String _selectedPaymentMode = "Cash";

  String? _selectedCountryId;
  List<dynamic> _countries = [];
  List<String> _countryNames = [];

  String? _selectedZoneId;
  List<dynamic> _zones = [];
  List<String> _zoneNames = [];

  String? _selectedBranchId;
  List<dynamic> _branches = [];
  List<String> _branchesNames = [];

  String? _selectedStateId;
  List<dynamic> _states = [];
  List<String> _stateNames = [];

  String? _selectedCityId;
  List<dynamic> _cities = [];
  List<String> _cityNames = [];

  String selectedUserId = "---- User Id & Name * ----";
  var savedImagePath = "";
  List<Map<String, dynamic>> _employeesByDesignation = [];
  final IsarService _isarService = IsarService();

  List<Map<String, dynamic>> designations = [];

  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String selectedRegId = "";
  String selectedRefName = "";
  String chequeNo = "";
  String chequeDate = "";
  String bankDate = "";
  String transactionId = "";

  String _selectedCountryCode = '+91'; // Default country code

  @override
  void initState() {
    super.initState();
    if (widget.pendingBusinessMentor != null) {
      _populateBusniessMentor(widget.pendingBusinessMentor!);
    }
    _loadDesignations();
    _loadZones();
    _loadCountry();
  }

  Future<void> _loadDesignations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final designationDataString = prefs.getString('designationData');

      if (designationDataString != null) {
        final List<dynamic> designationData = json.decode(
          designationDataString,
        );

        setState(() {
          designations = designationData
              .map<Map<String, dynamic>>(
                (desg) => {
                  'id': desg['id'].toString(),
                  'desg_name': desg['designation_name'].toString(),
                },
              )
              .toList();
          Logger.success("designationss :: $designations");
        });
      }
    } catch (e) {
      print('Error loading designations: $e');
    }
  }

  Future<void> _loadCountry() async {
    try {
      final controller =
          Provider.of<AdminBusniessMentorController>(context, listen: false);
      List<dynamic> countries = await controller.apiGetCountry();

      _countries = countries;

      List<String> countryNames = countries
          .map<String>(
              (country) => country['country_name'] ?? "No Country Available")
          .toList();
      setState(() {
        _countryNames = countryNames;
      });
    } catch (e) {
      Logger.error("error fetching countries $e");
    }
  }

  Future<void> _loadStates(selectedCountryId) async {
    try {
      final controller =
          Provider.of<AdminBusniessMentorController>(context, listen: false);
      List<dynamic> states = await controller.apiGetStates(selectedCountryId);
      _states = states;

      List<String> stateNames = states
          .map<String>((state) => state['state_name'] ?? "No State Available")
          .toList();

      setState(() {
        _stateNames = stateNames;
      });
      Logger.success("Fetched states from the api $states");
    } catch (e) {
      Logger.success("Error fetching states $e");
    }
  }

  Future<void> _loadCities(selectedStateId) async {
    try {
      final controller =
          Provider.of<AdminBusniessMentorController>(context, listen: false);
      List<dynamic> cities = await controller.apiGetCity(selectedStateId);
      _cities = cities;

      List<String> citiesNames = cities
          .map<String>((city) => city['city_name'] ?? "No cities available")
          .toList();

      setState(() {
        _cityNames = citiesNames;
      });
      Logger.success("Fetched cities from the api $cities");
    } catch (e) {
      Logger.error("Error fetching states $e");
    }
  }

  Future<void> _loadZones() async {
    try {
      final controller =
          Provider.of<AdminBusniessMentorController>(context, listen: false);

      List<dynamic> zones = await controller.apiGetZone();

      _zones = zones;

      List<String> zoneNames = zones
          .map<String>((zone) => zone['zone_name'] ?? "Unknown Zone")
          .toList();

      setState(() {
        _zoneNames = zoneNames;
      });
    } catch (e) {
      Logger.error("Error loading zones: $e");
    }
  }

  Future<void> _getBranches(String zoneId) async {
    final controller =
        Provider.of<AdminBusniessMentorController>(context, listen: false);
    final branches = await controller.apiGetBranchs(zoneId);
    _branches = branches;

    List<String> branchNames = branches
        .map<String>((branch) => branch['branch_name'] ?? "No Branches")
        .toList();
    setState(() {
      _branchesNames = branchNames;
    });
    Logger.success("new branches based on zone $branches");
  }

  Future<List<Map<String, dynamic>>> getUserByDesignationID(
      String selectedDesignationId) async {
    try {
      // Get all registered employees from the database
      final List<RegisteredEmployeeModel> allEmployees =
          await _isarService.getAll<RegisteredEmployeeModel>();

      // Filter employees by designation ID and status
      final filteredEmployees = allEmployees
          .where((employee) =>
              employee.designation == selectedDesignationId &&
              employee.status == 1)
          .map((employee) => {
                'regId': employee.regId,
                'name': employee.name,
              })
          .toList();

      Logger.success(
          "Found ${filteredEmployees.length} employees with designation $selectedDesignationId");
      return filteredEmployees;
    } catch (e) {
      Logger.error("Error getting user by designation: $e");
      return [];
    }
  }

  Future<void> getPincode(selectedCity) async {
    try {
      final controller =
          Provider.of<AdminBusniessMentorController>(context, listen: false);
      final pincode = await controller.apiGetPincode(selectedCity);
      setState(() {
        _pincodeController.text = pincode;
      });
      Logger.success("Pincode fetched from the $pincode");
    } catch (e) {
      Logger.error("Error fetching pincode $e");
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

      // Create the specific subfolder
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
      bool? forceReadOnly}) {
    return TextFormField(
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

    // Original implementation for non-empty lists
    if (!items.contains(selectedValue) && selectedValue != defaultOption) {
      selectedValue = defaultOption;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue, // Use the provided selected value
        items: [
          DropdownMenuItem(
            enabled: widget.isViewMode,
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

  Future<void> submitForm(context) async {
    final controller =
        Provider.of<AdminBusniessMentorController>(context, listen: false);
    final designation = _selectedDesignation;
    final String userId = selectedUserId;
    final String refName = selectedRefName;
    final String name =
        '${_firstNameController.text} ${_lastNameController.text}';
    final String nomineeName = _nomineeNameController.text;
    final String nomineeRelation = _nomineeRelationController.text;
    final String selectedCountrycode = _selectedCountryCode;
    final String phoneNumber = _phoneController.text;
    final String email = _emailController.text;
    final String gender = selectedGender;
    final String pincode = _pincodeController.text;
    final String address = _addressController.text;
    final String paymentMode = _selectedPaymentMode;
    final String formattedDate = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(_dateController.text),
    );

    try {
      Map<String, String> documentPaths = {};
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
      if (_selectedPaymentMode == "Cheque") {
        chequeNo = _chequeNoController.text;
        chequeDate = _chequeDateController.text;
        bankDate = _bankNameController.text;
      } else if (_selectedPaymentMode == "UPI/NEFT") {
        transactionId = _transactionIDController.text;
      }

      final newBusinessMentor = PendingBusinessMentorModel()
        ..designation = designation
        ..userId = userId
        ..refName = refName
        ..name = name
        ..firstName = _firstNameController.text
        ..lastName = _lastNameController.text
        ..nomineeName = nomineeName
        ..nomineeRelation = nomineeRelation
        ..countryCd = selectedCountrycode.replaceAll('+', '')
        ..phoneNumber = phoneNumber
        ..email = email
        ..gender = gender
        ..dob = formattedDate
        ..status = 2
        ..country = _selectedCountryId
        ..state = _selectedStateId
        ..city = _selectedCityId
        ..pincode = pincode
        ..address = address
        ..zone = _selectedZoneId
        ..branch = _selectedBranchId
        ..paymentMode = paymentMode
        ..chequeNo = chequeNo
        ..chequeDate = chequeDate
        ..bankName = bankDate
        ..transactionNo = transactionId
        ..profilePicture = documentPaths["profilePicture"]
        ..adharCard = documentPaths["adharCard"]
        ..panCard = documentPaths["panCard"]
        ..bankPassbook = documentPaths["bankPassbook"]
        ..votingCard = documentPaths["votingCard"]
        ..paymentProof = documentPaths['paymentProof'];

      await _isarService.save<PendingBusinessMentorModel>(newBusinessMentor);
      await controller.apiAddBusinessMentor(newBusinessMentor);
      clearFormFields();
      Navigator.pop(context);
    } catch (e) {
      Logger.error("Error submitting form: $e");
    }
  }

  void clearFormFields() {
    _refNameController.clear();
    _refNoController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _nomineeNameController.clear();
    _nomineeRelationController.clear();
    _chequeNoController.clear();
    _chequeDateController.clear();
    _bankNameController.clear();
    _transactionIDController.clear();
    _pincodeController.clear();
    _dateController.clear();
  }

  void _populateBusniessMentor(
      PendingBusinessMentorModel busniessMentor) async {
    Logger.success("Populated Gender is ${busniessMentor.gender}");
    // DateTime? originalDate = DateTime.tryParse(busniessMentor.dob!);
    _refNoController.text = busniessMentor.referenceNo!;
    String? refname = await getNameByReferenceNo(busniessMentor.referenceNo!);
    _refNameController.text = refname!;
    _firstNameController.text = busniessMentor.firstName!;
    _lastNameController.text = busniessMentor.lastName!;
    _nomineeNameController.text = busniessMentor.nomineeName!;
    _nomineeRelationController.text = busniessMentor.nomineeRelation!;
    _phoneController.text = busniessMentor.phoneNumber!;
    _emailController.text = busniessMentor.email!;
    selectedGender = busniessMentor.gender!;
    _dateController.text = busniessMentor.dob!;
    selectedCountry = busniessMentor.country!;
    selectedState = busniessMentor.state!;
    selectedCity = busniessMentor.city!;
    _pincodeController.text = busniessMentor.pincode!;
    _addressController.text = busniessMentor.address!;
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Add Busniness Mentor';

    if (widget.isViewMode) {
      appBarTitle = 'View Busniness Mentor';
    } else if (widget.isEditMode) {
      appBarTitle = 'Edit Busniness Mentor';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
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
                  SizedBox(height: 10),
                  widget.isViewMode || widget.isEditMode
                      ? _buildTextField('Reference ID *', _refNoController,
                          forceReadOnly: true)
                      : Column(
                          children: [
                            _buildDropdown(
                                'Designation *',
                                designations
                                    .map<String>(
                                      (desg) => desg['desg_name'] ?? "nothing",
                                    )
                                    .toList(),
                                _selectedDesignation,
                                (value) => setState(() {
                                      _selectedDesignation = value!;
                                      final selectedDesg =
                                          designations.firstWhere(
                                        (desg) => desg['desg_name'] == value,
                                        orElse: () =>
                                            {'id': '', 'desg_name': ''},
                                      );
                                      selectedDesignationId =
                                          selectedDesg['id'];

                                      if (selectedDesignationId != '') {
                                        getUserByDesignationID(
                                                selectedDesignationId!)
                                            .then((employees) {
                                          setState(() {
                                            _employeesByDesignation = employees;
                                            selectedUserId =
                                                "---- Select User Id & Name * ----";
                                          });
                                        });
                                      }

                                      Logger.success(
                                          "Selected Designation $_selectedDesignation and $selectedDesignationId");
                                    })),
                            SizedBox(height: 10),
                            _buildDropdown(
                                'User Id & Name *',
                                _employeesByDesignation.isEmpty
                                    ? [] // Empty list if no employees found
                                    : _employeesByDesignation
                                        .map<String>(
                                          (emp) =>
                                              "${emp['regId']} - ${emp['name']}",
                                        )
                                        .toList(),
                                selectedUserId,
                                (value) => setState(() {
                                      selectedUserId = value!;

                                      if (value !=
                                          "---- Select User Id & Name * ----") {
                                        // The regId is before the first " - "
                                        selectedRegId = value.split(" - ")[0];
                                        selectedRefName = value.split(" - ")[1];
                                        Logger.success(
                                            "Selected User RegID: $selectedRegId and Name: $selectedRefName");
                                        _refNameController.text =
                                            selectedRefName;
                                      }
                                    })),
                          ],
                        ),
                  SizedBox(height: 15),
                  _buildTextField('Reference Name *', _refNameController,
                      forceReadOnly: true),
                  SizedBox(height: 15),
                  _buildTextField('First Name*', _firstNameController),
                  SizedBox(height: 15),
                  _buildTextField('Last Name*', _lastNameController),
                  SizedBox(height: 15),
                  _buildTextField('Nominee Name*', _nomineeNameController),
                  SizedBox(height: 15),
                  _buildTextField(
                      'Nominee Relation*', _nomineeRelationController),
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
                                Logger.success(
                                    "selectedCountryCode : $_selectedCountryCode");
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
                        // Phone number text field
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
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
                  SizedBox(height: 15),
                  _buildTextField('Email *', _emailController),
                  SizedBox(height: 15),
                  _buildDropdown(
                      'Gender *',
                      ['Male', 'Female', 'Other'],
                      selectedGender,
                      (value) => setState(() {
                            selectedGender = value!;
                          })),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true, // Makes the TextFormField non-editable
                      enabled: !widget.isViewMode,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Date of Joining *',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        suffixIcon: _dateController.text.isNotEmpty &&
                                !widget.isViewMode
                            ? IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
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
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            Logger.warning(
                                "Selected date ${_dateController.text}");
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Country *',
                      _countryNames,
                      selectedCountry,
                      (value) => setState(() {
                            selectedCountry = value!;
                            final selectedCountryObject = _countries.firstWhere(
                                (country) => country['country_name'] == value,
                                orElse: () => null);
                            if (selectedCountryObject != null) {
                              _selectedCountryId =
                                  selectedCountryObject['id'].toString();
                              Logger.success(
                                  "selected country is $selectedCountry ID : $_selectedCountryId");
                            }
                            _loadStates(_selectedCountryId);
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'State *',
                      _stateNames,
                      selectedState,
                      (value) => setState(() {
                            selectedState = value!;

                            final selectedStateObject = _states.firstWhere(
                                (state) => state['state_name'] == value,
                                orElse: () => null);
                            if (selectedStateObject != null) {
                              _selectedStateId =
                                  selectedStateObject['id'].toString();
                              Logger.success(
                                  "selected state is $selectedState ID : $_selectedStateId");
                              _loadCities(_selectedStateId);
                            }
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'City *',
                      _cityNames,
                      selectedCity,
                      (value) => setState(() {
                            selectedCity = value!;
                            final selectedCityObject = _cities.firstWhere(
                                (city) => city['city_name'] == value,
                                orElse: () => null);
                            if (selectedCityObject != null) {
                              _selectedCityId =
                                  selectedCityObject['id'].toString();
                              Logger.success(
                                  "selected city is $selectedCity ID : $_selectedCityId");
                            }
                            getPincode(_selectedCityId);
                          })),
                  SizedBox(height: 10),
                  _buildTextField('Pincode *', _pincodeController,
                      forceReadOnly: true),
                  SizedBox(height: 15),
                  _buildTextField('Address *', _addressController),
                  SizedBox(height: 20),
                  _buildDropdown(
                    'Zone *',
                    _zoneNames.isEmpty ? ['No zones available'] : _zoneNames,
                    _selectedZone,
                    (value) => setState(() {
                      _selectedZone = value!;

                      if (_zones.isNotEmpty) {
                        final selectedZoneObject = _zones.firstWhere(
                            (zone) => zone['zone_name'] == value,
                            orElse: () => null);

                        if (selectedZoneObject != null) {
                          _selectedZoneId = selectedZoneObject['id'].toString();
                          Logger.success(
                              "Selected Zone: $_selectedZone, ID: $_selectedZoneId");
                          _getBranches(_selectedZoneId!);
                        }
                      }
                    }),
                  ),
                  SizedBox(height: 20),
                  _buildDropdown(
                      'Branch *',
                      _branchesNames.isEmpty
                          ? ['No branches available']
                          : _branchesNames,
                      _selectedBranch,
                      (value) => setState(() {
                            _selectedBranch = value!;
                            final selectedBranchObject = _branches.firstWhere(
                                (branch) => branch['branch_name'] == value,
                                orElse: () => null);
                            if (selectedBranchObject != null) {
                              _selectedBranchId =
                                  selectedBranchObject['id'].toString();
                              Logger.success(
                                  "selected branch is $_selectedBranch and its Id : $_selectedBranchId");
                            }
                          }),
                      emptyMessage: "No Branches available"),
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
                      Row(
                        children: ["Cash", "Cheque", "UPI/NEFT"].map((package) {
                          return GestureDetector(
                            onTap: widget.isViewMode
                                ? null
                                : () {
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
                                  activeColor:
                                      Colors.white, // Change radio button color
                                  onChanged: widget.isViewMode
                                      ? null
                                      : (value) {
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
                                    width: 10), // Spacing between radio buttons
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
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
                  _buildUploadButton("Payment Proof"),
                  SizedBox(height: 20),
                  if (widget.isEditMode) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
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
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16),
                        ),
                      ),
                    ),
                  ] else if (!widget.isViewMode) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          submitForm(context);
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
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16),
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
  }

  Widget _buildUploadButton(String fileType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          if (!widget.isViewMode)
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
