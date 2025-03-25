import 'dart:io';

import 'package:bizzmirth_app/entities/pending_techno_enterprise/pending_techno_enterprise_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AddViewTechnoPage extends StatefulWidget {
  final PendingTechnoEnterpriseModel? pendingTechnoEnterprise;
  final bool isViewMode;
  final bool isEditMode;
  const AddViewTechnoPage(
      {super.key,
      this.pendingTechnoEnterprise,
      this.isViewMode = false,
      this.isEditMode = false});

  @override
  // ignore: library_private_types_in_public_api
  _AddViewTechnoPageState createState() => _AddViewTechnoPageState();
}

class _AddViewTechnoPageState extends State<AddViewTechnoPage> {
  Map<String, dynamic> selectedFiles = {
    "Profile Picture": null,
    "Aadhar Card": null,
    "Pan Card": null,
    "Bank Passbook": null,
    "Voting Card": null,
    "Payment Proof": null
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
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  var savedImagePath = "";
  String selectedGender = "---- Select Gender ----";
  String selectedCountry = "---- Select Country ----";
  String selectedState = "---- Select State ----";
  String selectedCity = "---- Select City ----";
  String selectedUserId = "---- Select User Id ----";
  String selectedBusinessPackage = "---- Select Business Package ----";
  final IsarService _isarService = IsarService();

  String _selectedPackage = "Cash"; // Default selection

  String _selectedCountryCode = '+91'; // Default country code

  @override
  void initState() {
    super.initState();
    if (widget.pendingTechnoEnterprise != null) {
      _populatePendingTechnoEnterprise(widget.pendingTechnoEnterprise!);
    }
  }

  void updatePendingTechnoEnterprise() async {
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
              break;
          }
        }
      });
      final String formattedDate = DateFormat("yyyy-MM-dd").format(
        DateFormat("dd-MM-yyyy").parse(_dateController.text),
      );
      Logger.success("formatted date:: $formattedDate");
      int? id = widget.pendingTechnoEnterprise!.id;
      PendingTechnoEnterpriseModel updateTechnoEnterprise =
          PendingTechnoEnterpriseModel()
            ..id = id
            ..userId = selectedUserId
            ..refName = _refNameController.text
            ..name = '${_firstNameController.text} ${_lastNameController.text}'
            ..nomineeName = _nomineeNameController.text
            ..nomineeRelation = _nomineeRelationController.text
            ..businessPackage = selectedBusinessPackage
            ..amount = _amountController.text
            ..gstNo = _gstController.text
            ..countryCd = "91"
            ..phoneNumber = _phoneController.text
            ..email = _emailController.text
            ..dob = formattedDate
            ..status = 2
            ..country = selectedCountry
            ..state = selectedState
            ..city = selectedCity
            ..gender = selectedGender
            ..pincode = _pincodeController.text
            ..address = _addressController.text
            ..packageFor = _selectedPackage
            ..profilePicture = documentPaths["profilePicture"]
            ..adharCard = documentPaths["adharCard"]
            ..panCard = documentPaths["panCard"]
            ..bankPassbook = documentPaths["bankPassbook"]
            ..votingCard = documentPaths["votingCard"]
            ..paymentProof = documentPaths["paymentProof"];

      final updated = await _isarService.update(updateTechnoEnterprise, id!);
      Logger.success("Updating the techno enterprise was : $updated");
    } catch (e) {
      Logger.error("Error updating pending techno enterprise: $e");
    }
  }

  void _populatePendingTechnoEnterprise(
      PendingTechnoEnterpriseModel technoEnterprise) {
    selectedUserId = technoEnterprise.userId!;
    DateTime? originalDate = DateTime.tryParse(technoEnterprise.dob!);
    _refNameController.text = technoEnterprise.refName!;
    _firstNameController.text = technoEnterprise.name?.split(" ").first ?? '';
    _lastNameController.text = technoEnterprise.name?.split(" ").last ?? '';
    _nomineeNameController.text = technoEnterprise.nomineeName!;
    _nomineeRelationController.text = technoEnterprise.nomineeRelation!;
    selectedBusinessPackage = technoEnterprise.packageFor!;
    _amountController.text = technoEnterprise.amount!.toString();
    _gstController.text = technoEnterprise.gstNo!.toString();
    _phoneController.text = technoEnterprise.phoneNumber!;
    _emailController.text = technoEnterprise.email!;
    selectedGender = technoEnterprise.gender!;
    if (originalDate != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(originalDate);
    }
    selectedCountry = technoEnterprise.country!;
    selectedState = technoEnterprise.state!;
    selectedCity = technoEnterprise.city!;
    _pincodeController.text = technoEnterprise.pincode!;
    _addressController.text = technoEnterprise.address!;
    _selectedPackage = technoEnterprise.packageFor!;
    selectedBusinessPackage = technoEnterprise.businessPackage!;
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

  Future<void> submitForm() async {
    final userId = selectedUserId;
    final refName = _refNameController.text;
    final name = '${_firstNameController.text} ${_lastNameController.text}';
    final nomineeName = _nomineeNameController.text;
    final nomineeRelation = _nomineeRelationController.text;
    final businessPackage = selectedBusinessPackage;
    final amount = double.tryParse(_amountController.text);
    final gst = double.tryParse(_gstController.text);
    final phone = _phoneController.text;
    final email = _emailController.text;
    final gender = selectedGender;
    final date = _dateController.text;
    final country = selectedCountry;
    final state = selectedState;
    final city = selectedCity;
    final pincode = _pincodeController.text;
    final address = _addressController.text;
    final String formattedDate = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(_dateController.text),
    );
    Logger.success("formattedDate: $formattedDate");
    Logger.success("Selected User Id : $userId");
    Logger.success("Name: $name");
    Logger.success("Ref Name: $refName");
    Logger.success("Nominee Name: $nomineeName");
    Logger.success("Nominee Relation: $nomineeRelation");
    Logger.success("Business Package: $businessPackage");
    Logger.success("Amount: $amount");
    Logger.success("GST: $gst");
    Logger.success("Phone: $phone");
    Logger.success("Email: $email");
    Logger.success("Gender: $gender");
    Logger.success("Date: $date");
    Logger.success("Country: $country");
    Logger.success("State: $state");
    Logger.success("City: $city");
    Logger.success("Pincode: $pincode");
    Logger.success("Address: $address");

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
              break;
          }
        }
      });
      final newTechnoEnterprise = PendingTechnoEnterpriseModel()
        ..userId = selectedUserId
        ..refName = refName
        ..name = name
        ..nomineeName = nomineeName
        ..nomineeRelation = nomineeRelation
        ..businessPackage = businessPackage
        ..amount = amount.toString()
        ..gstNo = gst.toString()
        ..countryCd = "91"
        ..phoneNumber = phone.toString()
        ..email = email
        ..dob = formattedDate
        ..status = 2
        ..country = country
        ..state = state
        ..city = city
        ..gender = gender
        ..pincode = pincode
        ..address = address
        ..packageFor = _selectedPackage
        ..profilePicture = documentPaths["profilePicture"]
        ..adharCard = documentPaths["adharCard"]
        ..panCard = documentPaths["panCard"]
        ..bankPassbook = documentPaths["bankPassbook"]
        ..votingCard = documentPaths["votingCard"]
        ..paymentProof = documentPaths["paymentProof"];

      await _isarService
          .save<PendingTechnoEnterpriseModel>(newTechnoEnterprise);
    } catch (e) {
      Logger.error("Error in form submission: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Add Techno Enterprise';

    if (widget.isViewMode) {
      appBarTitle = 'View Techno Enterprise';
    } else if (widget.isEditMode) {
      appBarTitle = 'Edit Employee';
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
                  _buildDropdown(
                      'User Id & Name *',
                      ['Margao', 'Panjim', 'Other'],
                      selectedUserId,
                      (value) => setState(() => selectedUserId = value!)),
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
                  SizedBox(height: 10),
                  _buildDropdown(
                    'Business Package/Amount',
                    ['Standard', 'Prime', 'Premium'],
                    selectedBusinessPackage,
                    (value) => setState(() => selectedBusinessPackage = value!),
                  ),
                  SizedBox(height: 15),
                  _buildTextField('Amount', _amountController),
                  SizedBox(height: 15),
                  _buildTextField('GST NO', _gstController),
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
                            onChanged: widget.isViewMode
                                ? null
                                : (String? newValue) {
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
                            readOnly: widget.isViewMode,
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
                    (value) => setState(() => selectedGender = value!),
                  ),
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
                    (value) => setState(() => selectedCountry = value!),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(
                    'State *',
                    ['Goa', 'Delhi', 'Other'],
                    selectedState,
                    (value) => setState(() => selectedState = value!),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(
                    'City *',
                    ['Margao', 'Panjim', 'Other'],
                    selectedCity,
                    (value) => setState(() => selectedCity = value!),
                  ),
                  SizedBox(height: 10),
                  _buildTextField('Pincode *', _pincodeController),
                  SizedBox(height: 15),
                  _buildTextField('Address *', _addressController),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Package applicable for ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                                      _selectedPackage = package;
                                    });
                                  },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: package,
                                  groupValue: _selectedPackage,
                                  activeColor:
                                      Colors.white, // Change radio button color
                                  onChanged: widget.isViewMode
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedPackage = value!;
                                            Logger.success(
                                                "Selected package: $_selectedPackage");
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
                  _buildUploadButton("Payment Proof"),
                  SizedBox(height: 20),
                  if (widget.isEditMode) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.pendingTechnoEnterprise != null) {
                            updatePendingTechnoEnterprise();
                            // employeeController.updatePendingEmployees(pending);
                          }
                          //  else if (widget.registerEmployee != null) {
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
