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
  String _selectedPackage = "Stag"; // Default selection
  String? selectedRoomType; // Store the selected room type
  String? selectedRoomType1; // Store the selected room type
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    "Profile Picture": null,
    "ID Proof": null,
    "Bank Details": null,
  };

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
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

  Widget _buildDropdown(String label, List<String> items) {
    String defaultOption = "---- Select $label ----"; // Default placeholder

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: defaultOption, // Set default selection
        items: [
          DropdownMenuItem(
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
                  Text("General Details:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  _buildDropdown('Category *', ['International', 'Domestic']),
                  SizedBox(height: 10),
                  _buildDropdown(
                      'Sub - Category *', ['Club', 'Individual', 'Group']),
                  SizedBox(height: 10),
                  _buildDropdown('Club *', ['Premium', 'Silver', 'Membership']),
                  SizedBox(height: 10),
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
                        children: ["Stag", "Couple", "Family"].map((package) {
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
                                          "Selected Package $_selectedPackage");
                                    });
                                  },
                                  child: Radio<String>(
                                    value: package,
                                    activeColor: Colors.white,
                                  ),
                                ),
                                Text(
                                  package,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
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
                  SizedBox(height: 10),
                  _buildTextField('Package Name*'),
                  SizedBox(height: 15),
                  _buildTextField('Unique Code *'),
                  SizedBox(height: 15),
                  _buildTextField('Tour Days *'),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true, // Makes the TextFormField non-editable
                      style: TextStyle(color: Colors.white),
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
                  _buildTextField('Description *'),
                  SizedBox(height: 15),
                  _buildTextField('Destination *'),
                  SizedBox(height: 15),
                  _buildTextField('Location *'),
                  SizedBox(height: 15),
                  _buildTextField('Transfer From *'),
                  SizedBox(height: 15),
                  _buildTextField('Transfer To *'),
                  SizedBox(height: 15),
                  _buildTextField('Sightseeing Type *'),
                  SizedBox(height: 15),
                  _buildDropdown('Hotel Category *', [
                    '1 Star',
                    '2 Star',
                    '3 Star',
                    '4 Star',
                    '5 Star',
                    'Vila',
                    'Apartment'
                  ]),
                  SizedBox(height: 15),
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
                                  "Selected room type: $selectedRoomType");
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
                  SizedBox(height: 10),
                  _buildDropdown('Meal Type *', [
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Breakfast + Lunch',
                    'Breakfast + Dinner',
                    'Lunch + Dinner',
                    'No Meals'
                  ]),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  _buildTextField('Package Keywords *'),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
