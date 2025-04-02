import 'dart:convert';
import 'dart:io';

import 'package:bizzmirth_app/controllers/employee_controller.dart';
import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, dynamic> selectedFiles = {
    "Profile Picture": null,
    "ID Proof": null,
    "Bank Details": null,
  };
  var savedImagePath = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dojController = TextEditingController();
  String? dobForApi;
  String? dojForApi;
  String _selectedGender = "---- Select Gender * ----";
  String _selectedDepartment = "---- Select Department * ----";
  String _selectedDesignation = "---- Select Designation * ----";
  String _selectedZone = "---- Select Zone * ----";
  String _selectedBranch = "---- Select Branch * ----";
  String _selectedManager = "---- Select Reporting Manager * ----";
  final IsarService _isarService = IsarService();
  final EmployeeController employeeController = EmployeeController();

  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _addressKey = GlobalKey<FormFieldState>();

  String? selectedDepartmentId = "";
  String? selectedDesignationId = "";
  String selectedManagerRegId = "";
  String? selectedZoneId = "";
  String? selectedBranchId = "";
  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> designations = [];
  List<Map<String, dynamic>> zones = [];
  List<Map<String, dynamic>> branches = [];
  List<RegisteredEmployeeModel> reportingManager = [];
  List<String> reportingManagerNames = [];
  Map<String, String> managerNameToRegIdMap = {};

  String _selectedCountryCode = '+91';

  Future<void> _loadDepartments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final departmentDataString = prefs.getString('departmentData');

      if (departmentDataString != null) {
        final List<dynamic> departmentData = json.decode(departmentDataString);

        setState(() {
          departments = departmentData
              .map<Map<String, dynamic>>((dept) => {
                    'id': dept['id'].toString(),
                    'dept_name': dept['dept_name'].toString()
                  })
              .toList();
          Logger.success("departmetss :: $departments");
        });
      } else {}
    } catch (e) {
      print('Error loading departments: $e');
    }
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
                  'designation_name':
                      desg['designation_name'].toString(), // match the key name
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

  Future<void> _loadReportingManager() async {
    try {
      reportingManager = await _isarService.getAll<RegisteredEmployeeModel>();

      reportingManager = reportingManager
          .where((employee) => employee.userType == "24")
          .toList();

      reportingManagerNames = [];
      managerNameToRegIdMap = {};

      for (var rm in reportingManager) {
        Logger.success("reporting manager ${rm.name} userType: ${rm.userType}");
        reportingManagerNames.add(rm.name!);
        managerNameToRegIdMap[rm.name!] = rm.regId!;
      }

      setState(() {}); // Refresh UI after loading data
    } catch (e) {
      Logger.error("Error fetching Reporting Manager: $e");
    }
  }

  Future<void> _getZones() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await employeeController.apiGetZone();
      final zoneDataString = prefs.getString('zones');

      if (zoneDataString != null) {
        final List<dynamic> zoneData = json.decode(zoneDataString);
        setState(() {
          zones = zoneData
              .map<Map<String, dynamic>>((zone) => {
                    'id': zone['id'].toString(),
                    'zone_name': zone['zone_name'].toString()
                  })
              .toList();
        });
        Logger.success("zones :: $zones");
      } else {
        Logger.error("No Zone data found");
      }
    } catch (e) {
      Logger.error('Error fetching Zone: $e');
    }
  }

  Future<void> _getBranches(String zoneId) async {
    try {
      setState(() {
        // Clear previous branches when a new zone is selected
        branches = [];
        _selectedBranch = "---- Select Branch * ----"; // Reset selected branch
      });

      await employeeController.apiGetBranchs(zoneId);

      // We need to update the apiGetBranchs function to store the response data
      // and return it or store it in SharedPreferences like you did with zones
      final prefs = await SharedPreferences.getInstance();
      final branchDataString = prefs.getString('branches_$zoneId');

      if (branchDataString != "---- Select Branch * ----") {
        final List<dynamic> branchData = json.decode(branchDataString!);
        setState(() {
          branches = branchData
              .map<Map<String, dynamic>>((branch) => {
                    'id': branch['id'].toString(),
                    'branch_name': branch['branch_name'].toString()
                  })
              .toList();
          if (branches != null) {
            _selectedBranch = branches[0]['branch_name'];
            selectedBranchId = branches[0]['id'];
          }
        });
        Logger.success("branches :: $branches");
      } else {
        Logger.warning("No branches found for the selected zone");
      }
    } catch (e) {
      Logger.error('Error fetching branches: $e');
    }
  }

  void _populatePendingEmployeeForm(PendingEmployeeModel employee) async {
    _firstController.text = employee.name?.split(" ").first ?? '';
    _lastnameController.text = employee.name?.split(" ").last ?? '';
    _mobileController.text = employee.mobileNumber!;
    _emailController.text = employee.email!;
    _addressController.text = employee.address!;
    _selectedGender = employee.gender!;

    if (employee.department != null) {
      _selectedDepartment =
          (await getDepartmentNameById(employee.department!)) ??
              "---- Select Department * ----";
      selectedDepartmentId = employee.department!;
    }
    selectedDepartmentId = employee.department;
    // _selectedDepartment = employee.department!;
    if (employee.designation != null) {
      _selectedDesignation =
          (await getDesignationById(employee.designation!)) ??
              "---- Select Department * ----";
      selectedDesignationId = employee.designation!;
    }
    // if (employee.zone != null) {
    //   _selectedZone =
    //       (await getZoneById(employee.zone!)) ?? "---- Select Zone * ----";
    //   selectedZoneId = employee.zone!;
    // }
    if (employee.reportingManager != null) {
      _selectedManager =
          (await getReportingManagerNameById(employee.reportingManager!)) ??
              "---- Select Reporting Manager * ----";
      selectedManagerRegId = employee.reportingManager!;
    }
    if (employee.zone != null) {
      // First get the zone name
      _selectedZone =
          (await getZoneById(employee.zone!)) ?? "---- Select Zone * ----";
      selectedZoneId = employee.zone!;

      // Now fetch branches for this zone
      if (selectedZoneId!.isNotEmpty) {
        await _getBranches(selectedZoneId!);

        if (employee.branch != null) {
          if (employee.branch!.contains(RegExp(r'^\d+$'))) {
          } else {
            _selectedBranch = employee.branch!;
          }

          bool branchExists = branches
              .any((branch) => branch['branch_name'] == _selectedBranch);

          if (!branchExists) {
            _selectedBranch = "---- Select Branch * ----";
            Logger.warning(
                "Branch '${employee.branch}' not found in loaded branches for zone '${employee.zone}'");
          }
        } else {
          _selectedBranch = "---- Select Branch * ----";
        }
      }
    }
    // dobForApi = employee.dateOfBirth!;
    // dojForApi = employee.dateOfJoining!;

    try {
      if (employee.dateOfBirth != null &&
          employee.dateOfBirth!.contains('-') &&
          employee.dateOfBirth!.split('-').length == 3 &&
          employee.dateOfBirth!.split('-')[0].length == 4) {
        // Date is already in yyyy-MM-dd format
        dobForApi = employee.dateOfBirth;
        _dobController.text = DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(employee.dateOfBirth!));
      } else {
        // Date is in display format (dd-MM-yyyy), convert to API format
        DateTime dobDate =
            DateFormat('dd-MM-yyyy').parse(employee.dateOfBirth!);
        dobForApi = DateFormat('yyyy-MM-dd').format(dobDate);
        _dobController.text = DateFormat('dd-MM-yyyy').format(dobDate);
      }

      // Check if DOJ is already in API format (yyyy-MM-dd)
      if (employee.dateOfJoining != null &&
          employee.dateOfJoining!.contains('-') &&
          employee.dateOfJoining!.split('-').length == 3 &&
          employee.dateOfJoining!.split('-')[0].length == 4) {
        // Date is already in yyyy-MM-dd format
        dojForApi = employee.dateOfJoining;
        _dojController.text = DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(employee.dateOfJoining!));
      } else {
        // Date is in display format, convert to API format
        DateTime dojDate =
            DateFormat('dd-MM-yyyy').parse(employee.dateOfJoining!);
        dojForApi = DateFormat('yyyy-MM-dd').format(dojDate);
        _dojController.text = DateFormat('dd-MM-yyyy').format(dojDate);
      }
    } catch (e) {
      print("Error parsing dates during form population: $e");
      // Fallback to original values if parsing fails
      dobForApi = employee.dateOfBirth;
      dojForApi = employee.dateOfJoining;
      _dobController.text = employee.dateOfBirth ?? '';
      _dojController.text = employee.dateOfJoining ?? '';
    }

    if (employee.profilePicture != null) {
      selectedFiles["Profile Picture"] =
          "https://testca.uniqbizz.com/uploading/${employee.profilePicture!}";
    }
    if (employee.idProof != null) {
      selectedFiles["ID Proof"] =
          "https://testca.uniqbizz.com/uploading/${employee.idProof!}";
    }
    if (employee.bankDetails != null) {
      selectedFiles["Bank Details"] =
          "https://testca.uniqbizz.com/uploading/${employee.bankDetails!}";
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

    try {
      // Convert from display format to API format
      DateTime dobDate = DateFormat('dd-MM-yyyy').parse(employee.dateOfBirth!);
      DateTime dojDate =
          DateFormat('dd-MM-yyyy').parse(employee.dateOfJoining!);

      dobForApi = DateFormat('yyyy-MM-dd').format(dobDate);
      dojForApi = DateFormat('yyyy-MM-dd').format(dojDate);
    } catch (e) {
      Logger.error("Error parsing dates during form population: $e");
      // Fallback to original values if parsing fails
      dobForApi = employee.dateOfBirth;
      dojForApi = employee.dateOfJoining;
    }

    // Set the file paths for images in selectedFiles
    if (employee.profilePicture != null) {
      selectedFiles["Profile Picture"] =
          "https://testca.uniqbizz.com/uploading/${employee.profilePicture!}";
    }
    if (employee.idProof != null) {
      selectedFiles["ID Proof"] =
          "https://testca.uniqbizz.com/uploading/${employee.idProof!}";
    }
    if (employee.bankDetails != null) {
      selectedFiles["Bank Details"] =
          "https://testca.uniqbizz.com/uploading/${employee.bankDetails!}";
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.pendingEmployee != null) {
      _populatePendingEmployeeForm(widget.pendingEmployee!);
    } else if (widget.registerEmployee != null) {
      _populateRegisteredEmployeeForm(widget.registerEmployee!);
    } else {
      // We're adding a new employee, ensure selectedFiles are all null
      selectedFiles = {
        "Profile Picture": null,
        "ID Proof": null,
        "Bank Details": null,
      };
    }
    _loadDepartments();
    _loadDesignations();
    _loadReportingManager();
    _getZones();
  }

  void updatePendingEmployee() async {
    try {
      if (_formKey.currentState!.validate()) {
        int? id = widget.pendingEmployee!.id;
        PendingEmployeeModel updatePendingEmployee = PendingEmployeeModel()
          ..id = id
          ..name = '${_firstController.text} ${_lastnameController.text}'
          ..mobileNumber = _mobileController.text
          ..email = _emailController.text
          ..address = _addressController.text
          ..gender = _selectedGender
          ..dateOfBirth = dobForApi
          ..dateOfJoining = dojForApi
          ..status = 2
          ..department = selectedDepartmentId
          ..designation = selectedDesignationId
          ..zone = _selectedZone
          ..branch = _selectedBranch
          ..reportingManager = _selectedManager
          ..profilePicture = selectedFiles["Profile Picture"]
          ..idProof = selectedFiles["ID Proof"]
          ..bankDetails = selectedFiles["Bank Details"];

        final updated = await _isarService.update<PendingEmployeeModel>(
            updatePendingEmployee, id!);
        if (updated) {
          final apiUpdate = await employeeController
              .updatePendingEmployees(updatePendingEmployee);
          Logger.success("Api update status : $apiUpdate");
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
        Logger.success(
            "Date of joining and date of birth $dobForApi $dojForApi");
        RegisteredEmployeeModel updateRegisteredEmployee =
            RegisteredEmployeeModel()
              ..id = id
              ..regId = widget.registerEmployee?.regId
              ..name = '${_firstController.text} ${_lastnameController.text}'
              ..mobileNumber = _mobileController.text
              ..email = _emailController.text
              ..address = _addressController.text
              ..gender = _selectedGender
              ..dateOfBirth = dobForApi
              ..dateOfJoining = dojForApi
              ..status = 1
              ..department = _selectedDepartment
              ..designation = _selectedDesignation
              ..zone = _selectedZone
              ..branch = _selectedBranch
              ..reportingManager = _selectedManager
              ..profilePicture = selectedFiles["Profile Picture"]
              ..idProof = selectedFiles["ID Proof"]
              ..bankDetails = selectedFiles["Bank Details"];

        final updated = await _isarService.update<RegisteredEmployeeModel>(
            updateRegisteredEmployee, id!);

        Logger.warning(":::::$updated");
        if (updated) {
          final apiUpdate = await employeeController
              .updateRegisterEmployee(updateRegisteredEmployee);
          Logger.success("Api update status : $apiUpdate");
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
  // void _pickFile(String fileType) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles();
  //     if (result != null && result.files.isNotEmpty) {
  //       PlatformFile file = result.files.first;

  //       setState(() {
  //         selectedFiles[fileType] =
  //             file.name as File?; // 🔥 Save selected file name
  //       });

  //       Logger.success("Picked file for $fileType: ${file.name}");
  //     }
  //   } catch (e) {
  //     print("Error picking file: $e");
  //   }
  // }

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
    try {
      final formState = _formKey.currentState;

      if (formState == null || !formState.validate()) {
        _scrollToFirstError();
        ToastHelper.showErrorToast(
            context: context, title: "Please Fill all the required fields");
        return; // Stop the submission process
      }
      if (_formKey.currentState!.validate()) {
        // if (true) {
        String? profilePicturePath;
        String? idProofPath;
        String? bankDetailsPath;

        // Upload Profile Picture if selected
        if (selectedFiles["Profile Picture"] != null) {
          await employeeController.uploadImage(
              context, 'profile_pic', selectedFiles["Profile Picture"]!.path);
          profilePicturePath = selectedFiles["Profile Picture"]!.path;
        }

        // Upload ID Proof if selected
        if (selectedFiles["ID Proof"] != null) {
          await employeeController.uploadImage(
              context, 'id_proof', selectedFiles["ID Proof"]!.path);
          idProofPath = selectedFiles["ID Proof"]!.path;
        }

        // Upload Bank Details if selected
        if (selectedFiles["Bank Details"] != null) {
          await employeeController.uploadImage(
              context, 'passbook', selectedFiles["Bank Details"]!.path);
          bankDetailsPath = selectedFiles["Bank Details"]!.path;
        }

        final newEmployee = PendingEmployeeModel()
          ..name = '${_firstController.text} ${_lastnameController.text}'
          ..mobileNumber = _mobileController.text
          ..email = _emailController.text
          ..address = _addressController.text
          ..gender = _selectedGender
          ..dateOfBirth = dobForApi
          ..dateOfJoining = dojForApi
          ..status = 2
          ..department = selectedDepartmentId
          ..designation = selectedDesignationId
          ..zone = selectedZoneId
          ..branch = selectedBranchId
          ..reportingManager = selectedManagerRegId
          ..profilePicture = profilePicturePath
          ..idProof = idProofPath
          ..bankDetails = bankDetailsPath;

        final bool apiSuccess =
            await employeeController.addEmployee(newEmployee);

        if (apiSuccess) {
          Logger.success(
              "Data going in DB is Profile picture $profilePicturePath ID Proof: $idProofPath bank Details : $bankDetailsPath");
          await _isarService.save<PendingEmployeeModel>(newEmployee);
          Logger.success(
              "Employee saved to API and local database successfully");
          Navigator.pop(context);
          ToastHelper.showSuccessToast(
              context: context, title: "Employee Added Successfully");
          _clearFormFields();
        } else {
          await _isarService.save<PendingEmployeeModel>(newEmployee);
          Logger.warning("Employee saved locally but API submission failed");
          Navigator.pop(context);
          ToastHelper.showWarningToast(
              context: context,
              title:
                  "Employee saved locally but couldn't be uploaded to server");
          _clearFormFields();
        }
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
    String? Function(String?)? validator,
    String? emptyMessage, // Add this parameter for empty message
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
                    // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    //     .hasMatch(value)) {
                    //   return 'Please enter a valid email';
                    // }
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
                      readOnly: true,
                      enabled: !widget.isViewMode,
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
                          ? null
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
                                  String displayFormat =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);

                                  // Format for logging (yyyy-MM-dd)
                                  dobForApi = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);

                                  // Log the date in yyyy-MM-dd format
                                  print(
                                      "Selected DOB (for API/logging): $dobForApi");

                                  // Set the display format in the text field
                                  setState(() {
                                    _dobController.text = displayFormat;
                                  });
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
                              // Initialize with a safe default date
                              DateTime initialDate = DateTime.now();

                              // Only try to parse if text is not empty
                              if (_dojController.text.isNotEmpty) {
                                try {
                                  // Try to parse the existing date
                                  initialDate = DateFormat('dd-MM-yyyy')
                                      .parse(_dojController.text);

                                  // Safety check - if the year is before 1900, use current date
                                  if (initialDate.year < 1900) {
                                    initialDate = DateTime.now();
                                  }
                                } catch (e) {
                                  // If parsing fails, use current date
                                  print("Error parsing date: $e");
                                  initialDate = DateTime.now();
                                }
                              }

                              // Now use the safe initialDate
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String displayFormat =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                dojForApi =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    "Selected DOJ (for API/logging): $dojForApi");

                                setState(() {
                                  _dojController.text = displayFormat;
                                });
                              }
                            },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(
                    'Department *',
                    departments
                        .map<String>((dept) => dept['dept_name'])
                        .toList(),
                    _selectedDepartment,
                    validator: (value) {
                      if (value == null ||
                          value == "---- Select Department * ----") {
                        return 'Please select a department';
                      }
                      return null;
                    },
                    (value) {
                      setState(() {
                        _selectedDepartment = value!;
                        final selectedDept = departments.firstWhere(
                          (dept) => dept['dept_name'] == value,
                          orElse: () => {'id': '', 'dept_name': ''},
                        );
                        selectedDepartmentId = selectedDept['id'];
                        if (selectedDept['id'] != '') {
                          selectedDepartmentId = selectedDept['id'];
                          Logger.success(
                              'Selected Department ID: $selectedDepartmentId');
                        } else {
                          Logger.success(
                              'Error: Department ID not found for $value');
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Designation *',
                      designations
                          .map<String>((desg) => desg['designation_name'])
                          .toList(),
                      _selectedDesignation, validator: (value) {
                    if (value == null ||
                        value == "---- Select Designation * ----") {
                      return 'Please select a designation';
                    }
                    return null;
                  },
                      (value) => setState(() {
                            _selectedDesignation = value!;
                            final selectedDesg = designations.firstWhere(
                              (desg) => desg['designation_name'] == value,
                              orElse: () => {'id': '', 'designation_name': ''},
                            );
                            selectedDesignationId = selectedDesg['id'];
                            if (selectedDesg['id'] != '') {
                              selectedDepartmentId = selectedDesg['id'];
                              Logger.success(
                                  'Selected Designation ID: $selectedDesignationId');
                            } else {
                              Logger.success(
                                  'Error: Designation ID not found for $value');
                            }
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Zone *',
                      zones.map<String>((zone) => zone['zone_name']).toList(),
                      _selectedZone, validator: (value) {
                    if (value == null || value == "---- Select Zone * ----") {
                      return 'Please select a zone';
                    }
                    return null;
                  },
                      (value) => setState(() {
                            _selectedZone = value!;
                            final selectedZone = zones.firstWhere(
                              (zone) => zone['zone_name'] == value,
                              orElse: () => {'id': '', 'zone_name': ''},
                            );
                            selectedZoneId = selectedZone['id'];
                            Logger.warning(
                                'Selected Zone : $_selectedZone and selected zone ID : $selectedZoneId');
                            if (selectedZoneId != null) {
                              _getBranches(selectedZoneId!);
                            }
                          })),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Branch *',
                      branches.isEmpty
                          ? []
                          : branches
                              .map<String>((branch) => branch['branch_name'])
                              .toList(),
                      _selectedBranch, validator: (value) {
                    if (branches.isEmpty) {
                      return null; // Don't validate if no branches are available
                    }
                    if (value == null || value == "---- Select Branch * ----") {
                      return 'Please select a branch';
                    }
                    return null;
                  },
                      (value) => setState(() {
                            _selectedBranch = value!;
                            final selectedBranch = branches.firstWhere(
                              (branch) => branch['branch_name'] == value,
                              orElse: () => {'id': '', 'branch_name': ''},
                            );
                            selectedBranchId = selectedBranch['id'];
                          }),
                      emptyMessage:
                          "No branches available for the selected zone"),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Reporting Manager *',
                      reportingManagerNames, // Use the filtered list of manager names
                      _selectedManager, validator: (value) {
                    if (value == null ||
                        value == "---- Select Reporting Manager * ----") {
                      return 'Please select a reporting manager';
                    }
                    return null;
                  },
                      (value) => setState(() {
                            _selectedManager = value!;
                            selectedManagerRegId =
                                managerNameToRegIdMap[_selectedManager] ?? "";

                            // Now you can use selectedManagerRegId for saving or other purposes
                            Logger.success(
                                "Selected manager: $_selectedManager, ID: $selectedManagerRegId");
                          })),
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
                            // employeeController.updatePendingEmployees(pending);
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
                  widget.isViewMode
                      ? "No $fileType available"
                      : "No $fileType uploaded",
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
