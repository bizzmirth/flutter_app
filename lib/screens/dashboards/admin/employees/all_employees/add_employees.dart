import 'dart:io';

import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AddEmployeePage extends StatefulWidget {
  final PendingEmployeeModel? pendingEmployee;
  final RegisteredEmployeeModel? registerEmployee;
  final bool isViewMode;
  final bool isEditMode;
  const AddEmployeePage(
      {super.key,
      this.pendingEmployee,
      this.registerEmployee,
      this.isEditMode = false,
      this.isViewMode = false});

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  Map<String, File?> selectedFiles = {
    "Profile Picture": null,
    "ID Proof": null,
    "Bank Details": null,
  };
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dojController = TextEditingController();

  String _selectedGender = "---- Select Gender * ----";
  String _selectedDepartment = "---- Select Department * ----";
  String _selectedDesignation = "---- Select Designation * ----";
  String _selectedZone = "---- Select Zone * ----";
  String _selectedBranch = "---- Select Branch * ----";
  String _selectedManager = "---- Select Reporting Manager * ----";
  final IsarService _isarService = IsarService();

  // Define GlobalKeys for each form field
  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();

  String _selectedCountryCode = '+91'; // Default country code

  void _populatePendingEmployeeForm(PendingEmployeeModel employee) {
    _firstController.text = employee.name?.split(" ").first ?? '';
    _lastnameController.text = employee.name?.split(" ").last ?? '';
    _mobileController.text = employee.mobileNumber!;
    _emailController.text = employee.email!;
    _addressController.text = employee.address!;
    _dobController.text = employee.dateOfBirth!;
    _dojController.text = employee.dateOfJoining!;
    _selectedGender = employee.gender!;
    _selectedDepartment = employee.department!;
    _selectedDesignation = employee.designation!;
    _selectedZone = employee.zone!;
    _selectedBranch = employee.branch!;
    _selectedManager = employee.reportingManager!;

    // Set the file paths for images in selectedFiles
    if (employee.profilePicture != null) {
      selectedFiles["Profile Picture"] = File(employee.profilePicture!);
    }
    if (employee.idProof != null) {
      selectedFiles["ID Proof"] = File(employee.idProof!);
    }
    if (employee.bankDetails != null) {
      selectedFiles["Bank Details"] = File(employee.bankDetails!);
    }
  }

  void _populateRegisteredEmployeeForm(RegisteredEmployeeModel employee) {
    _firstController.text = employee.name?.split(" ").first ?? '';
    _lastnameController.text = employee.name?.split(" ").last ?? '';
    _mobileController.text = employee.mobileNumber!;
    _emailController.text = employee.email!;
    _addressController.text = employee.address!;
    _dobController.text = employee.dateOfBirth!;
    _dojController.text = employee.dateOfJoining!;
    _selectedGender = employee.gender!;
    _selectedDepartment = employee.department!;
    _selectedDesignation = employee.designation!;
    _selectedZone = employee.zone!;
    _selectedBranch = employee.branch!;
    _selectedManager = employee.reportingManager!;

    // Set the file paths for images in selectedFiles
    if (employee.profilePicture != null) {
      selectedFiles["Profile Picture"] = File(employee.profilePicture!);
    }
    if (employee.idProof != null) {
      selectedFiles["ID Proof"] = File(employee.idProof!);
    }
    if (employee.bankDetails != null) {
      selectedFiles["Bank Details"] = File(employee.bankDetails!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.pendingEmployee != null) {
      _populatePendingEmployeeForm(widget.pendingEmployee!);
    }

    if (widget.registerEmployee != null) {
      _populateRegisteredEmployeeForm(widget.registerEmployee!);
    }
  }

  void updatePendingEmployee() async {
    try {
      if (_formKey.currentState!.validate()) {
        // int employeeId =
        int? id = widget.pendingEmployee!.id;
        PendingEmployeeModel updatePendingEmployee = PendingEmployeeModel()
          ..id = id
          ..name = '${_firstController.text} ${_lastnameController.text}'
          ..mobileNumber = _mobileController.text
          ..email = _emailController.text
          ..address = _addressController.text
          ..gender = _selectedGender
          ..dateOfBirth = _dobController.text
          ..dateOfJoining = _dojController.text
          ..status = 2
          ..department = _selectedDepartment
          ..designation = _selectedDesignation
          ..zone = _selectedZone
          ..branch = _selectedBranch
          ..reportingManager = _selectedManager
          ..profilePicture = selectedFiles["Profile Picture"]?.path
          ..idProof = selectedFiles["ID Proof"]?.path
          ..bankDetails = selectedFiles["Bank Details"]?.path;

        final updated = await _isarService.update<PendingEmployeeModel>(
            updatePendingEmployee, id!);
        if (updated) {
          ToastHelper.showSuccessToast(
              context: context, title: "Updated Employee Successfully");

          Navigator.pop(context);
        }
      }
    } catch (e) {
      Logger.error("Error updating Pending Employe $e");
    }
  }

  void updateRegisteredEmployee() async {
    try {
      if (_formKey.currentState!.validate()) {
        int? id = widget.registerEmployee!.id;
        RegisteredEmployeeModel updateRegisteredEmployee =
            RegisteredEmployeeModel()
              ..id = id
              ..name = '${_firstController.text} ${_lastnameController.text}'
              ..mobileNumber = _mobileController.text
              ..email = _emailController.text
              ..address = _addressController.text
              ..gender = _selectedGender
              ..dateOfBirth = _dobController.text
              ..dateOfJoining = _dojController.text
              ..status = 1
              ..department = _selectedDepartment
              ..designation = _selectedDesignation
              ..zone = _selectedZone
              ..branch = _selectedBranch
              ..reportingManager = _selectedManager
              ..profilePicture = selectedFiles["Profile Picture"]?.path
              ..idProof = selectedFiles["ID Proof"]?.path
              ..bankDetails = selectedFiles["Bank Details"]?.path;

        final updated = await _isarService.update<RegisteredEmployeeModel>(
            updateRegisteredEmployee, id!);

        Logger.warning(":::::$updated");
        if (updated) {
          ToastHelper.showSuccessToast(
              context: context, title: "Updated Employee Successfully");

          Navigator.pop(context);
        }
      }
    } catch (e) {
      Logger.error("Error updating registered employee $e");
    }
  }

  void _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result == null) return;

      String path = result.files.single.path!;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${fileType.replaceAll(" ", "_").toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = '${appDir.path}/$fileName';

      await File(path).copy(savedImagePath);

      setState(() {
        if (fileType == "Profile Picture") {}

        // Store the file object
        selectedFiles[fileType] = File(savedImagePath);
      });
    } catch (e) {
      Logger.error("Error picking file: $e");
    }
  }

  void _scrollToFirstError() {
    final Map<String, GlobalKey<FormFieldState>> fieldKeys = {
      'firstName': _firstNameKey,
      'lastName': _lastNameKey,
      'mobile': _mobileKey,
      'email': _emailKey,
      'address': _addressKey,
      // Add all your other fields here
    };

    // Check each field for validation errors
    for (final entry in fieldKeys.entries) {
      final fieldState = entry.value.currentState;
      if (fieldState != null && fieldState.hasError) {
        // Found an error, scroll to this field
        Scrollable.ensureVisible(
          entry.value.currentContext!,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0, // Adjust this value to position the field in the view
        );
        break; // Stop after finding the first error
      }
    }
  }

  void _submitForm() async {
    String? profilePicturePath = selectedFiles["Profile Picture"]?.path;
    String? idProofPath = selectedFiles["ID Proof"]?.path;
    String? bankDetailsPath = selectedFiles["Bank Details"]?.path;

    // Now you can use these variables in your API call
    Logger.info(
        'entered username ${_firstController.text} ${_lastnameController.text}');
    Logger.info('entered mobile ${_mobileController.text}');
    Logger.info('entered email ${_emailController.text}');
    Logger.info('entered address ${_addressController.text}');
    Logger.info('entered dob ${_dobController.text}');
    Logger.info('entered doj ${_dojController.text}');

    Logger.info('selected gender: $_selectedGender');
    Logger.info('selected department: $_selectedDepartment');
    Logger.info('selected designation: $_selectedDesignation');
    Logger.info('selected zone: $_selectedZone');
    Logger.info('selected branch: $_selectedBranch');
    Logger.info('selected manager: $_selectedManager');

    Logger.info("Profile Picture Path: $profilePicturePath");
    Logger.info("ID Proof Path: $idProofPath");
    Logger.info("Bank Details Path: $bankDetailsPath");

    try {
      final formState = _formKey.currentState;

      if (formState == null || !formState.validate()) {
        // Find the first field with an error and scroll to it
        _scrollToFirstError();
        ToastHelper.showErrorToast(
            context: context, title: "Please Fill all the required fields");
        return; // Stop the submission process
      }
      if (_formKey.currentState!.validate()) {
        final newEmployee = PendingEmployeeModel()
          ..name = '${_firstController.text} ${_lastnameController.text}'
          ..mobileNumber = _mobileController.text
          ..email = _emailController.text
          ..address = _addressController.text
          ..gender = _selectedGender
          ..dateOfBirth = _dobController.text
          ..dateOfJoining = _dojController.text
          ..status = 2
          ..department = _selectedDepartment
          ..designation = _selectedDesignation
          ..zone = _selectedZone
          ..branch = _selectedBranch
          ..reportingManager = _selectedManager
          ..profilePicture = selectedFiles["Profile Picture"]?.path
          ..idProof = selectedFiles["ID Proof"]?.path
          ..bankDetails = selectedFiles["Bank Details"]?.path;

        await _isarService.save<PendingEmployeeModel>(newEmployee);
        Logger.success("data saved successfully");
        Navigator.pop(context);
        ToastHelper.showSuccessToast(
            context: context, title: "Employee Saved Successfully");

        _clearFormFields();
      } else {
        ToastHelper.showErrorToast(
            context: context,
            title: "Please fill all the required fields correctly.");
      }
    } catch (e) {
      Logger.error("Error saving data: $e");
    }
  }

  void _clearFormFields() {
    _firstController.clear();
    _lastnameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _addressController.clear();
    _dobController.clear();
    _dojController.clear();

    _selectedGender = "---- Select Gender * ----";
    _selectedDepartment = "---- Select Department * ----";
    _selectedDesignation = "---- Select Designation * ----";
    _selectedZone = "---- Select Zone * ----";
    _selectedBranch = "---- Select Branch * ----";
    _selectedManager = "---- Select Reporting Manager * ----";

    selectedFiles.clear();

    // Refresh UI if needed
    setState(() {});
  }

  void _removeFile(String fileType) {
    setState(() {
      selectedFiles[fileType] = null;
      if (fileType == "Profile Picture") {}
    });
  }

  Widget _customInputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
    required GlobalKey<FormFieldState> fieldKey,
  }) {
    return TextFormField(
      key: fieldKey,
      validator: validator,
      readOnly: widget.isViewMode,
      controller: controller,
      maxLines: maxLines,
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
    String appBarTitle = 'Add Employee';

    if (widget.isViewMode) {
      appBarTitle = 'View Employee';
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
                  Text("Personal Details",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 15),
                  _customInputField(
                    'First Name *',
                    _firstController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    fieldKey: _firstNameKey,
                  ),
                  SizedBox(height: 15),
                  _customInputField('Last Name *', _lastnameController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  }, fieldKey: _lastNameKey),
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
                                enabled: widget.isViewMode,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile number';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Mobile number must be exactly 10 digits';
                              }
                              return null;
                            },
                            readOnly: widget.isViewMode,
                            controller: _mobileController,
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
                  _customInputField('Email *', _emailController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }, fieldKey: _emailKey),
                  SizedBox(height: 15),
                  _customInputField('Address *', _addressController,
                      fieldKey: _addressKey),
                  SizedBox(height: 15),
                  _buildDropdown('Gender *', ['Male', 'Female', 'Other'],
                      validator: (value) {
                    if (value == null || value == "---- Select Gender * ----") {
                      return 'Please select a gender';
                    }
                    return null;
                  }, _selectedGender,
                      (value) => setState(() => _selectedGender = value!)),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dobController,
                      validator: (value) {
                        // DateTime dob = DateFormat('dd-MM-yyyy').parse(value!);
                        if (value == null || value.isEmpty) {
                          return 'Please select a date of birth';
                        }
                        // if (DateTime.now().difference(dob).inDays < 18 * 365) {
                        //   return 'You must be at least 18 years old';
                        // }
                        return null;
                      },
                      readOnly: true, // Makes the TextFormField non-editable
                      enabled: !widget.isViewMode, // Disable field in view mode
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
                        suffixIcon: _dobController.text.isNotEmpty &&
                                !widget
                                    .isViewMode // Only show cancel button if not in view mode
                            ? IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _dobController
                                        .clear(); // Clears the date when cancel button is pressed
                                  });
                                },
                              )
                            : null, // Only show cancel button if date is selected and not in view mode
                      ),
                      onTap: widget.isViewMode
                          ? null // Disable date picker in view mode
                          : () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _dobController.text.isNotEmpty
                                    ? DateFormat('dd-MM-yyyy')
                                        .parse(_dobController.text)
                                    : DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dobController.text = DateFormat('dd-MM-yyyy')
                                      .format(pickedDate);
                                });
                              }
                            },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Employment Details",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dojController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date of joining';
                        }
                        // DateTime doj = DateFormat('dd-MM-yyyy').parse(value!);
                        // if (DateTime.now().difference(doj).inDays < 1) {
                        //   return 'Date of joining must be at least one day in the future';
                        // }
                        return null;
                      },
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
                        suffixIcon: _dojController.text.isNotEmpty &&
                                !widget.isViewMode
                            ? IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _dojController
                                        .clear(); // Clears the date when cancel button is pressed
                                  });
                                },
                              )
                            : null, // Only show cancel button if date is selected
                      ),
                      onTap: widget.isViewMode
                          ? null // Disable date picker in view mode
                          : () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _dojController.text.isNotEmpty
                                    ? DateFormat('dd-MM-yyyy')
                                        .parse(_dojController.text)
                                    : DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dojController.text = DateFormat('dd-MM-yyyy')
                                      .format(pickedDate);
                                });
                              }
                            },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown('Department *', ['HR', 'Engineering', 'Sales'],
                      _selectedDepartment, validator: (value) {
                    if (value == null ||
                        value == "---- Select Department * ----") {
                      return 'Please select a department';
                    }
                    return null;
                  }, (value) => setState(() => _selectedDepartment = value!)),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Designation *',
                      ['Manager', 'Executive', 'Intern'],
                      _selectedDesignation, validator: (value) {
                    if (value == null ||
                        value == "---- Select Designation * ----") {
                      return 'Please select a designation';
                    }
                    return null;
                  }, (value) => setState(() => _selectedDesignation = value!)),
                  SizedBox(height: 10),
                  _buildDropdown('Zone *', ['North', 'South', 'East', 'West'],
                      _selectedZone, validator: (value) {
                    if (value == null || value == "---- Select Zone * ----") {
                      return 'Please select a zone';
                    }
                    return null;
                  }, (value) => setState(() => _selectedZone = value!)),
                  SizedBox(height: 10),
                  _buildDropdown('Branch *', ['Mumbai', 'Delhi', 'Bangalore'],
                      _selectedBranch, validator: (value) {
                    if (value == null || value == "---- Select Branch * ----") {
                      return 'Please select a branch';
                    }
                    return null;
                  }, (value) => setState(() => _selectedBranch = value!)),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Reporting Manager *',
                      ['John Doe', 'Jane Smith', 'Alice Brown'],
                      _selectedManager, validator: (value) {
                    if (value == null ||
                        value == "---- Select Reporting Manager * ----") {
                      return 'Please select a reporting manager';
                    }
                    return null;
                  }, (value) => setState(() => _selectedManager = value!)),
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
                  _buildUploadButton("ID Proof"),
                  _buildUploadButton("Bank Details"),
                  SizedBox(height: 20),
                  if (widget.isEditMode) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.pendingEmployee != null) {
                            updatePendingEmployee();
                          } else if (widget.registerEmployee != null) {
                            updateRegisteredEmployee();
                          }
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
                        onPressed: _submitForm,
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
          // Only show the upload button if NOT in view mode
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
            // Show image with or without the remove button based on view mode
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
                    child: Image.file(
                      selectedFiles[fileType]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Only show the remove button if NOT in view mode
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
                  widget.isViewMode
                      ? "No $fileType available"
                      : "No $fileType uploaded",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                )))
        ],
      ),
    );
  }
}
