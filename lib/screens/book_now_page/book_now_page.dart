import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookNowPage extends StatefulWidget {
  const BookNowPage({super.key});

  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String selectedCountryCode = '+91';
  TextEditingController phoneController = TextEditingController();
  TextEditingController tourDateController = TextEditingController();
  TextEditingController adultsController = TextEditingController();
  TextEditingController childrenController = TextEditingController();
  TextEditingController infantController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  String selectedCoupon = '';
  double basePrice = 5000.0;
  double totalPrice = 5000.0;
  List<String> availableCoupons = ['DISCOUNT10', 'SAVE20', 'OFFER30'];
  String couponError = '';
  String invalidCouponMessage = '';

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

  void applyCoupon(String couponCode) {
    setState(() {
      if (availableCoupons.contains(couponCode)) {
        selectedCoupon = couponCode;
        totalPrice = basePrice;
        if (couponCode == 'DISCOUNT10') {
          totalPrice *= 0.9;
        } else if (couponCode == 'SAVE20') {
          totalPrice *= 0.8;
        } else if (couponCode == 'OFFER30') {
          totalPrice *= 0.7;
        }
        invalidCouponMessage = ''; // Clear error message
        Navigator.pop(context);
      } else {
        invalidCouponMessage = 'Invalid Coupon';
      }
    });
  }

  void removeCoupon() {
    setState(() {
      selectedCoupon = '';
      totalPrice = basePrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Now',
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
              Text(
                'Book Your Tour',
                style: Appwidget.poppinsHeadline(),
              ),
              const SizedBox(height: 20),
              _buildDropdown('Customer ID *',
                  ['78687676 Subhash', '78687676 Subhash', '78687676 Subhash']),
              const SizedBox(height: 10),
              _customInputField(Icons.person, 'Full Name'),
              const SizedBox(height: 15),
              _customInputField(Icons.email, 'Email ID'),
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
              _customDatePicker(context, Icons.date_range, 'Tour Date'),
              const SizedBox(height: 15),
              _customTravelersInputRow(
                  Icons.group,
                  'Adults',
                  adultsController,
                  '12+ Years',
                  Icons.child_care,
                  'Children',
                  childrenController,
                  '3-11 Years',
                  Icons.child_care,
                  'Infants',
                  infantController,
                  'Under 2 Years'),
              const SizedBox(height: 25),
              _pricingSection(),
              const SizedBox(height: 15),
              _applyCouponButton(),
              const SizedBox(height: 10),
              if (selectedCoupon.isNotEmpty)
                Center(
                  child: ElevatedButton(
                    onPressed: removeCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Remove Coupon',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final int adultsCount =
                        int.tryParse(adultsController.text) ?? 0;
                    final int childrenCount =
                        int.tryParse(childrenController.text) ?? 0;
                    final int infantCount =
                        int.tryParse(infantController.text) ?? 0;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Your booking request has been submitted....Kindly Proceed with adding Booking Details'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      _showPassengerDetailsPopup(
                          adultsCount, childrenCount, infantCount);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pricingSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Details',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _pricingRow('Base Price', '₹${basePrice.toStringAsFixed(2)}'),
          if (selectedCoupon.isNotEmpty) ...[
            const SizedBox(height: 5),
            _pricingRow('Coupon Applied', '-$selectedCoupon',
                color: Colors.greenAccent),
          ],
          const Divider(color: Colors.white54),
          _pricingRow(
            'Final Price',
            '₹${totalPrice.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _pricingRow(String label, String value,
      {bool isBold = false, Color color = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _applyCouponButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _showCouponPopup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shadowColor: Colors.black.withValues(alpha: 0.1),
          elevation: 3,
        ),
        child: Text(
          selectedCoupon.isNotEmpty
              ? 'Coupon Applied: $selectedCoupon'
              : 'Apply Coupon',
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showCouponPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coupon'),
        content: selectedCoupon.isNotEmpty
            ? Text(
                "You've already applied: $selectedCoupon. Would you like to remove or change it?",
                textAlign: TextAlign.center,
              )
            : const Text('Apply a discount coupon to your order.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (selectedCoupon.isNotEmpty) ...[
            TextButton(
              onPressed: () {
                removeCoupon();
                Navigator.pop(context);
              },
              child: const Text('Remove Coupon',
                  style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showApplyCouponDialog();
              },
              child: const Text('Change Coupon'),
            ),
          ] else
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showApplyCouponDialog();
              },
              child: const Text('Apply Coupon'),
            ),
        ],
      ),
    );
  }

  void _showApplyCouponDialog() {
    couponController.clear(); // Clear input field every time popup opens
    setState(() {
      invalidCouponMessage = ''; // Clear error message
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Apply Coupon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: couponController,
                decoration: const InputDecoration(
                  labelText: 'Enter Coupon Code',
                  border: OutlineInputBorder(),
                ),
              ),
              if (invalidCouponMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    invalidCouponMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: availableCoupons
                    .map((coupon) => ElevatedButton(
                          onPressed: () => applyCoupon(coupon),
                          child: Text(coupon),
                        ))
                    .toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  applyCoupon(couponController.text);
                });
              },
              child: const Text('Apply'),
            ),
          ],
        ),
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
                    child: Container(
                      width:
                          50, // Adjust this value to reduce the width of each item
                      alignment: Alignment.center,
                      child: Text(value,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
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
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _customInputField1(
      IconData icon, String label, TextEditingController controller,
      {bool isEnabled = true}) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, // Keeps label inside without moving
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),

        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
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

  Widget _customTravelersInputRow(
      IconData icon1,
      String label1,
      TextEditingController controller1,
      String subText1,
      IconData icon2,
      String label2,
      TextEditingController controller2,
      String subText2,
      IconData icon3,
      String label3,
      TextEditingController controller3,
      String subText3) {
    final FocusNode adultFocusNode = FocusNode();

    // Ensure default value is at least 1
    if (controller1.text.isEmpty || controller1.text == '0') {
      controller1.text = '1';
    }

    adultFocusNode.addListener(() {
      if (!adultFocusNode.hasFocus) {
        if (controller1.text.isEmpty || controller1.text == '0') {
          controller1.text = '1';
          ScaffoldMessenger.of(adultFocusNode.context!).showSnackBar(
            const SnackBar(
              content: Text('At least 1 adult is required'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Row(
              children: [
                // Adults Input Field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller1,
                        focusNode: adultFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: label1,
                          labelStyle: const TextStyle(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(icon1, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          // Prevent leading zeros
                          if (value.isNotEmpty) {
                            controller1.text = int.parse(value).toString();
                            controller1.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller1.text.length),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          subText1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Children Input Field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller2,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: label2,
                          labelStyle: const TextStyle(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(icon2, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          subText2,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Infants Input Field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller3,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: label3,
                          labelStyle: const TextStyle(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: Icon(icon3, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          subText3,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showPassengerDetailsPopup(
      int adultsCount, int childrenCount, int infantCount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 183, 210, 255), // Light background for contrast
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Enter Passenger Details',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite, // Ensures full width usage
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (adultsCount > 0)
                    _buildPassengerInputs('Adult', adultsCount),
                  if (childrenCount > 0)
                    _buildPassengerInputs('Child', childrenCount),
                  if (infantCount > 0)
                    _buildPassengerInputs('Infant', infantCount),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle submission logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPassengerInputs(String type, int count) {
    final List<Widget> inputs = [];

    for (int i = 1; i <= count; i++) {
      final TextEditingController dobController = TextEditingController();
      final TextEditingController ageController = TextEditingController();
      inputs.add(
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: const Color.fromARGB(255, 50, 151, 223),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type $i Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 10),
                _customInputField(Icons.person,
                    'Full Name'), // Separate controllers per passenger if needed
                const SizedBox(height: 10),
                _customDatePicker1(
                    Icons.cake, 'Date of Birth', dobController, ageController),
                const SizedBox(height: 10),
                _customInputField1(Icons.cake, 'Age', ageController),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: inputs);
  }

  Widget _customDatePicker1(IconData icon, String label,
      TextEditingController controller, TextEditingController ageController) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            prefixIcon: Icon(icon, color: Colors.white),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        ageController.clear();
                      });
                    },
                  )
                : null,
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
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setState(() {
                controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                final int age = _calculateAge(pickedDate);
                ageController.text = age.toString();
              });
            }
          },
        );
      },
    );
  }

  int _calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
