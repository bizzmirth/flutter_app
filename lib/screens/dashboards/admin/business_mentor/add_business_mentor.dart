import 'dart:io';

import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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
  };

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _refNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nomineeNameController = TextEditingController();
  final TextEditingController _nomineeRelationController =
      TextEditingController();
  String selectedGender = "---- Select Gender ----";
  String selectedCountry = "---- Select Country ----";
  String selectedState = "---- Select State ----";
  String selectedCity = "---- Select City ----";
  String selectedDesignation = "---- Select Designation ----";
  String selectedUserId = "---- User Id & Name * ----";
  var savedImagePath = "";
  final IsarService _isarService = IsarService();

  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedCountryCode = '+91'; // Default country code

  @override
  void initState() {
    super.initState();
    if (widget.pendingBusinessMentor != null) {
      _populateBusniessMentor(widget.pendingBusinessMentor!);
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
        case "Bank Details":
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
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      readOnly: widget.isViewMode,
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
    String? Function(String?)? validator, // Add this parameter
  }) {
    String defaultOption = "---- Select $label ----"; // Default placeholder
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

  Future<void> submitForm() async {
    final designation = selectedDesignation;
    final String userId = selectedUserId;
    final String refName = _refNameController.text;
    final String name =
        '${_firstNameController.text} ${_lastNameController.text}';
    final String nomineeName = _nomineeNameController.text;
    final String nomineeRelation = _nomineeRelationController.text;
    final String phoneNumber = _phoneController.text;
    final String email = _emailController.text;
    final String gender = selectedGender;
    final String dob = _dateController.text;
    final String country = selectedCountry;
    final String state = selectedState;
    final String city = selectedCity;
    final String pincode = _pincodeController.text;
    final String address = _addressController.text;
    final String formattedDate = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(_dateController.text),
    );

    Logger.success(
        "selectedDesignation: $designation, selecteduserId: $userId refName: $refName, name:$name, nomineeName: $nomineeName, nomineeRelation: $nomineeRelation, phoneNumber: $phoneNumber, email: $email, gender: $gender dob: $dob, country: $country, state: $state, city:$city, pincode: $pincode, address: $address");
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
          }
        }
      });

      final newBusinessMentor = PendingBusinessMentorModel()
        ..designation = designation
        ..userId = userId
        ..refName = refName
        ..name = name
        ..nomineeName = nomineeName
        ..nomineeRelation = nomineeRelation
        ..countryCd = "91"
        ..phoneNumber = phoneNumber
        ..email = email
        ..gender = gender
        ..dob = formattedDate
        ..status = 2
        ..country = country
        ..state = state
        ..city = city
        ..pincode = pincode
        ..address = address
        ..profilePicture = documentPaths["profilePicture"]
        ..adharCard = documentPaths["adharCard"]
        ..panCard = documentPaths["panCard"]
        ..bankPassbook = documentPaths["bankPassbook"]
        ..votingCard = documentPaths["votingCard"];

      await _isarService.save<PendingBusinessMentorModel>(newBusinessMentor);
      //  Logger.success("Updating the techno enterprise was : $updated");
    } catch (e) {
      Logger.error("Error submitting form: $e");
    }
  }

  void _populateBusniessMentor(PendingBusinessMentorModel busniessMentor) {
    DateTime? originalDate = DateTime.tryParse(busniessMentor.dob!);

    // populate the fields from here
    selectedDesignation = busniessMentor.designation!;
    selectedUserId = busniessMentor.userId!;
    _refNameController.text = busniessMentor.refName!;
    _firstNameController.text = busniessMentor.name!.split(' ')[0];
    _lastNameController.text = busniessMentor.name!.split(' ')[1];
    _nomineeNameController.text = busniessMentor.nomineeName!;
    _nomineeRelationController.text = busniessMentor.nomineeRelation!;
    _phoneController.text = busniessMentor.phoneNumber!;
    _emailController.text = busniessMentor.email!;
    selectedGender = busniessMentor.gender!;
    _dateController.text = originalDate?.toString() ?? "";
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
                  _buildDropdown(
                      'Designation *',
                      ['Goa', 'Delhi', 'Other'],
                      selectedDesignation,
                      (value) => setState(() {
                            selectedDesignation = value!;
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'User Id & Name *',
                      ['Margao', 'Panjim', 'Other'],
                      selectedUserId,
                      (value) => setState(() {
                            selectedUserId = value!;
                          })),
                  SizedBox(height: 15),
                  _buildTextField('Reference Name *', _refNameController),
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
                      ['India', 'Pakistan', 'Other'],
                      selectedCountry,
                      (value) => setState(() {
                            selectedCountry = value!;
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'State *',
                      ['Goa', 'Delhi', 'Other'],
                      selectedState,
                      (value) => setState(() {
                            selectedState = value!;
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'City *',
                      ['Margao', 'Panjim', 'Other'],
                      selectedCity,
                      (value) => setState(() {
                            selectedCity = value!;
                          })),
                  SizedBox(height: 10),
                  _buildTextField('Pincode *', _pincodeController),
                  SizedBox(height: 15),
                  _buildTextField('Address *', _addressController),
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
                        onPressed: submitForm,
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
                        : Image.network(
                            selectedFiles[fileType],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
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
