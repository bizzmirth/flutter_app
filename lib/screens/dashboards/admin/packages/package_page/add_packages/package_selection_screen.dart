import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PackageSelectionScreen extends StatefulWidget {
  const PackageSelectionScreen({super.key});

  @override
  State<PackageSelectionScreen> createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  String _selectedPackage = 'Stag'; // Default selection
  String? selectedRoomType; // Store the selected room type
  String? selectedRoomType1; // Store the selected room type
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    'Profile Picture': null,
    'ID Proof': null,
    'Bank Details': null,
  };

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
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

  Widget _buildDropdown(String label, List<String> items) {
    final String defaultOption =
        '---- Select $label ----'; // Default placeholder

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: defaultOption, // Set default selection
        items: [
          DropdownMenuItem(
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
        onChanged: (value) {
          // Handle selection
        },
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
      body: Container(
        height: double.infinity,
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('General Details:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  _buildDropdown('Category *', ['International', 'Domestic']),
                  const SizedBox(height: 10),
                  _buildDropdown(
                      'Sub - Category *', ['Club', 'Individual', 'Group']),
                  const SizedBox(height: 10),
                  _buildDropdown('Club *', ['Premium', 'Silver', 'Membership']),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Package applicable for ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: ['Stag', 'Couple', 'Family'].map((package) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPackage = package;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Radio<String>(
                                //   value: package,
                                //   groupValue: _selectedPackage,
                                //   activeColor:
                                //       Colors.white, // Change radio button color
                                //   onChanged: (value) {
                                //     setState(() {
                                //       _selectedPackage = value!;
                                //     });
                                //   },
                                // ),
                                RadioGroup<String>(
                                  groupValue: _selectedPackage,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPackage = value!;
                                      Logger.success(
                                          'Selected Package $_selectedPackage');
                                    });
                                  },
                                  child: Radio<String>(
                                    value: package,
                                    activeColor: Colors.white,
                                  ),
                                ),
                                Text(
                                  package,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                    width: 10), // Spacing between radio buttons
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Package Name*'),
                  const SizedBox(height: 15),
                  _buildTextField('Unique Code *'),
                  const SizedBox(height: 15),
                  _buildTextField('Tour Days *'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true, // Makes the TextFormField non-editable
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Validity Upto *',
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
                  _buildTextField('Description *'),
                  const SizedBox(height: 15),
                  _buildTextField('Destination *'),
                  const SizedBox(height: 15),
                  _buildTextField('Location *'),
                  const SizedBox(height: 15),
                  _buildTextField('Transfer From *'),
                  const SizedBox(height: 15),
                  _buildTextField('Transfer To *'),
                  const SizedBox(height: 15),
                  _buildTextField('Sightseeing Type *'),
                  const SizedBox(height: 15),
                  _buildDropdown('Hotel Category *', [
                    '1 Star',
                    '2 Star',
                    '3 Star',
                    '4 Star',
                    '5 Star',
                    'Vila',
                    'Apartment'
                  ]),
                  const SizedBox(height: 15),
                  Text(
                    'Occupancy Category',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      for (var roomType in [
                        'Single',
                        'Double',
                        'Triple',
                        'Quad',
                        'Extra Bed'
                      ])
                        RadioGroup<String>(
                          groupValue: selectedRoomType,
                          onChanged: (value) {
                            setState(() {
                              selectedRoomType = value; // Update selection
                              Logger.success(
                                  'Selected room type: $selectedRoomType');
                            });
                          },
                          child: RadioListTile<String>(
                            title: Text(
                              roomType,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            value: roomType, // Assign each radio button a value
                            activeColor: Colors
                                .white, // Change radio button color to white
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown('Meal Type *', [
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Breakfast + Lunch',
                    'Breakfast + Dinner',
                    'Lunch + Dinner',
                    'No Meals'
                  ]),
                  const SizedBox(height: 10),
                  Text(
                    'Vehicle Category',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      RadioGroup<String>(
                        groupValue: selectedRoomType1,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedRoomType1 = value;
                            });
                          }
                        },
                        child: Column(
                          children: [
                            for (var roomType in [
                              'Car',
                              'Bus',
                              'Train',
                              'Volvo Bus',
                            ])
                              RadioListTile<String>(
                                title: Text(
                                  roomType,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                value: roomType,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Package Keywords *'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
