import 'dart:convert';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DepartmentDropdown extends StatefulWidget {
  final ValueChanged<Map<String, String>?>? onDepartmentSelected;
  final bool isViewMode;
  final String? initialDepartment;
  final String? initialDepartmentId;

  const DepartmentDropdown({
    super.key,
    this.onDepartmentSelected,
    this.isViewMode = false,
    this.initialDepartment,
    this.initialDepartmentId,
  });

  @override
  State<DepartmentDropdown> createState() => _DepartmentDropdownState();
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

      Logger.info('Raw Department Data: $departmentDataString');

      if (departmentDataString != null) {
        final List<dynamic> departmentData = jsonDecode(departmentDataString);

        Logger.info('Parsed Department Data: $departmentData');

        setState(() {
          departments = departmentData
              .map<Map<String, dynamic>>((dept) => {
                    'id': dept['id'].toString(),
                    'dept_name': dept['dept_name'].toString()
                  })
              .toList();

          Logger.info('Processed Departments: $departments');
          if (widget.initialDepartment != null) {
            selectedDepartment = widget.initialDepartment;
            Logger.info('Initial Department: ${widget.initialDepartment}');
          }

          isLoading = false;
        });
      } else {
        Logger.error('No department data found in SharedPreferences');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Logger.error('Error loading departments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: selectedDepartment ?? '  Select Department    ',
        items: [
          const DropdownMenuItem(
            value: '  Select Department    ',
            child: Text(
              '  Select Department    ',
              style: TextStyle(color: Color.fromARGB(166, 29, 29, 29)),
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
                if (value != '  Select Department    ') {
                  // Find the corresponding department ID
                  final selectedDept = departments.firstWhere(
                    (dept) => dept['dept_name'] == value,
                    orElse: () => {'id': null},
                  );

                  // Log the department ID
                  Logger.info('Selected Department ID: ${selectedDept['id']}');
                  Logger.info('Selected Department ID: ${selectedDept['id']}');

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
            ? const TextStyle(color: Colors.black54)
            : const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        isExpanded: true,
      ),
    );
  }
}
