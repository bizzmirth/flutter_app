import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DepartmentDropdown extends StatefulWidget {
  final ValueChanged<Map<String, String>?>? onDepartmentSelected;
  final bool isViewMode;
  final String? initialDepartment;
  final String? initialDepartmentId;

  const DepartmentDropdown({
    Key? key,
    this.onDepartmentSelected,
    this.isViewMode = false,
    this.initialDepartment,
    this.initialDepartmentId,
  }) : super(key: key);

  @override
  _DepartmentDropdownState createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {
  List<Map<String, dynamic>> departments = [];
  String? selectedDepartment;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final departmentDataString = prefs.getString('departmentData');

      print('Raw Department Data: $departmentDataString'); // Debug print

      if (departmentDataString != null) {
        final List<dynamic> departmentData = json.decode(departmentDataString);

        print('Parsed Department Data: $departmentData'); // Debug print

        setState(() {
          departments = departmentData
              .map<Map<String, dynamic>>((dept) => {
                    'id': dept['id'].toString(),
                    'dept_name': dept['dept_name'].toString()
                  })
              .toList();

          print('Processed Departments: $departments'); // Debug print

          // Set selected department for both view AND edit mode
          if (widget.initialDepartment != null) {
            selectedDepartment = widget.initialDepartment;
            print(
                'Initial Department: ${widget.initialDepartment}'); // Debug print
          }

          isLoading = false;
        });
      } else {
        print('No department data found in SharedPreferences');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading departments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedDepartment ?? "  Select Department    ",
        items: [
          DropdownMenuItem(
            value: "  Select Department    ",
            child: Text(
              "  Select Department    ",
              style: TextStyle(color: const Color.fromARGB(166, 29, 29, 29)),
            ),
          ),
          ...departments.map((dept) => DropdownMenuItem(
                value: dept['dept_name'],
                child: Text(dept['dept_name']),
              )),
        ],
        onChanged: widget.isViewMode
            ? null
            : (value) {
                if (value != "  Select Department    ") {
                  // Find the corresponding department ID
                  final selectedDept = departments.firstWhere(
                    (dept) => dept['dept_name'] == value,
                    orElse: () => {'id': null},
                  );

                  // Log the department ID
                  print('Selected Department ID: ${selectedDept['id']}');
                  print('Selected Department ID: ${selectedDept['id']}');

                  // Update the state and call the callback
                  setState(() {
                    selectedDepartment = value;
                  });

                  widget.onDepartmentSelected?.call({
                    'id': selectedDept['id'],
                    'name': selectedDept['dept_name']
                  });
                }
              },
        decoration: InputDecoration(
          labelText: 'Department *',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: widget.isViewMode
              ? Colors.grey[200]
              : const Color.fromARGB(255, 255, 255, 255),
        ),
        style: widget.isViewMode
            ? TextStyle(color: Colors.black54)
            : const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        isExpanded: true,
      ),
    );
  }
}
