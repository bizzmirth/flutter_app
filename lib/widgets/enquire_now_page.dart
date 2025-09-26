import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnquireNowPage extends StatefulWidget {
  const EnquireNowPage({super.key});

  @override
  State<EnquireNowPage> createState() => _EnquireNowPageState();
}

class _EnquireNowPageState extends State<EnquireNowPage> {
  TextEditingController adultsController = TextEditingController();
  TextEditingController childrenController = TextEditingController();
  TextEditingController infantsController = TextEditingController();
  String selectedCountryCode = '+91';
  TextEditingController phoneController = TextEditingController();
  bool isBreakfast = false;
  bool isLunch = false;
  bool isEveningSnack = false;
  bool isDinner = false;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView
  }

  @override
  void dispose() {
    adultsController.dispose();
    childrenController.dispose();
    infantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enquiry Form',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Enquiry/Quotation Form',
                style: Appwidget.poppinsHeadline(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'The following enquiry/quotation form is for ',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(178, 33, 149, 243),
                    ),
                    child: const Text('Shimla, Manali'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _customInputField(Icons.person, 'Your Name'),
              const SizedBox(height: 15),
              _customPhoneNumberField(
                selectedCountryCode: selectedCountryCode,
                onCountryCodeChanged: (newCode) {
                  setState(() {
                    selectedCountryCode = newCode;
                  });
                },
                phoneController: phoneController,
              ),
              const SizedBox(height: 15),
              _customInputField(Icons.email, 'Your Email'),
              const SizedBox(height: 15),
              _customInputField(Icons.timelapse, 'Trip Duration'),
              const SizedBox(height: 15),
              _customDatePicker(context, Icons.date_range, 'Travel Date'),
              const SizedBox(height: 15),
              customInputRow(
                icon1: Icons.emoji_people_rounded,
                label1: 'Adults',
                controller1: adultsController,
                icon2: Icons.child_care_rounded,
                label2: 'Children',
                controller2: childrenController,
                icon3: Icons.baby_changing_station_rounded,
                label3: 'Infants',
                controller3: infantsController,
                onUpdate: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Approx. Budget',
                  // ignore: deprecated_member_use
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  prefixIcon: const Icon(Icons.attach_money_outlined,
                      color: Colors.white),
                  filled: true,
                  // ignore: deprecated_member_use
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.2), // Semi-transparent white
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meals Required',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            child: _customCheckbox('Breakfast', isBreakfast,
                                (value) {
                              setState(() {
                                isBreakfast = value!;
                              });
                            }),
                          ),
                        ),
                        const SizedBox(width: 193),
                        Expanded(
                          child: Align(
                            child: _customCheckbox('Lunch', isLunch, (value) {
                              setState(() {
                                isLunch = value!;
                              });
                            }),
                          ),
                        ),
                        const SizedBox(width: 193),
                        Expanded(
                          child: Align(
                            child: _customCheckbox('Dinner', isDinner, (value) {
                              setState(() {
                                isDinner = value!;
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _customInputField(Icons.message, 'Additional Remarks(if any)',
                  maxLines: 5),
              const SizedBox(height: 20),
              const Row(),

              // Animated Send Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Your Query has been escalated to the team! They will get in touch with you shortly.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    'Submit Details',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Expanded(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color.fromARGB(134, 0, 94, 255),
            checkColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white.withValues(alpha: 1)),
          ),
        ],
      ),
    );
  }

  Widget _customPhoneNumberField({
    required String selectedCountryCode,
    required Function(String) onCountryCodeChanged,
    required TextEditingController phoneController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Country Code Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedCountryCode,
                onChanged: (newValue) {
                  if (newValue != null) {
                    onCountryCodeChanged(newValue);
                  }
                },
                items: ['+91', '+1', '+44', '+61', '+971'].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: const Color.fromARGB(255, 83, 83, 83),
                underline: const SizedBox(),
              ),
            ),
            const SizedBox(width: 10),
            // Phone Number Input
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10, // Limit to typical phone number length
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter phone number',
                  labelStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                  prefixIcon: const Icon(Icons.phone, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  counterText: '', // Hide character counter
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Custom Input Field
  Widget _customInputField(IconData icon, String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        // ignore: deprecated_member_use
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white),
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

  Widget _customDatePicker(BuildContext context, IconData icon, String label) {
    final TextEditingController dateController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: dateController,
          readOnly: true, // Prevent manual input
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            prefixIcon: Icon(icon, color: Colors.white),
            suffixIcon: dateController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close,
                        color: Colors.white.withValues(alpha: 0.8)),
                    onPressed: () {
                      setState(dateController.clear);
                    },
                  )
                : null, // Show clear button only when date is selected
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              setState(() {
                dateController.text =
                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              });
            }
          },
        );
      },
    );
  }
}
