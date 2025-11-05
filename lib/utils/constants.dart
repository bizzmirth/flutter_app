// Widget for Contact Info
import 'dart:async';
import 'dart:convert';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/screens/book_now_page/book_now_page.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/enquire_now_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final IsarService _isarService = IsarService();
//contact info
Widget contactInfo(IconData icon, String text) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
    ),
  );
}

// Divider for spacing
Widget divider() {
  return Divider(color: Colors.white.withValues(alpha: 0.5));
}

Widget _customAdultInputField({
  required IconData icon,
  required String label,
  required TextEditingController controller,
  int maxLines = 1,
  VoidCallback? onClear, // Function to handle clearing input
}) {
  return StatefulBuilder(builder: (context, setState) {
    return TextField(
      keyboardType: TextInputType.phone,
      controller: controller,
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
      onChanged: (value) {
        if (value.isEmpty || value == '0') {
          setState(() {
            controller.text = '1'; // Reset to 1 if user enters 0
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('At least 1 adult is a must'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  });
}

Widget _customInputField({
  required IconData icon,
  required String label,
  required TextEditingController controller,
  int maxLines = 1,
  VoidCallback? onClear, // Function to handle clearing input
}) {
  return TextField(
    keyboardType: TextInputType.phone,
    controller: controller,
    maxLines: maxLines,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon:
                  Icon(Icons.clear, color: Colors.white.withValues(alpha: 0.8)),
              onPressed: onClear, // Clear input when tapped
            )
          : null,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

Widget customInputRow({
  required IconData icon1,
  required String label1,
  required TextEditingController controller1,
  required IconData icon2,
  required String label2,
  required TextEditingController controller2,
  required IconData icon3,
  required String label3,
  required TextEditingController controller3,
  required VoidCallback onUpdate, // Callback to update state
  double width1 = 0.33,
  double width2 = 0.33,
  double width3 = 0.33,
}) {
  controller1.text = controller1.text.isEmpty ? '1' : controller1.text;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          // Adults Input
          Expanded(
            flex: (width1 * 10).toInt(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customAdultInputField(
                  icon: icon1,
                  label: label1,
                  controller: controller1,
                  onClear: () {
                    controller1.clear();
                    onUpdate(); // Update state
                  },
                ),
                const SizedBox(height: 2), // Spacing
                Center(
                  child: Text(
                    '12+ Years',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Children Input
          Expanded(
            flex: (width2 * 10).toInt(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customInputField(
                  icon: icon2,
                  label: label2,
                  controller: controller2,
                  onClear: () {
                    controller2.clear();
                    onUpdate(); // Update state
                  },
                ),
                const SizedBox(height: 2), // Spacing
                Center(
                  child: Text(
                    '3-11 Years',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Infants Input
          Expanded(
            flex: (width3 * 10).toInt(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customInputField(
                  icon: icon3,
                  label: label3,
                  controller: controller3,
                  onClear: () {
                    controller3.clear();
                    onUpdate(); // Update state
                  },
                ),
                const SizedBox(height: 2), // Spacing
                Center(
                  child: Text(
                    'Under 2 Years',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// Custom Input Field
Widget customInputField(
    IconData icon, String label, TextEditingController controller,
    {int maxLines = 1,
    String? Function(String?)? validator,
    GlobalKey<FormFieldState>? fieldKey}) {
  return TextFormField(
    maxLines: maxLines,
    controller: controller,
    style: const TextStyle(color: Colors.white),
    key: fieldKey,
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
    validator: validator,
  );
}

String normalizeGender(String gender) {
  switch (gender.toLowerCase().trim()) {
    case 'male':
      return 'Male';
    case 'female':
      return 'Female';
    case 'other':
      return 'Other';
    default:
      return '---- Select Gender ----';
  }
}

// Helper function for tab buttons
Widget buildTabButton(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(label),
    ),
  );
}

// Helper function for tiles

Widget buildTile(String title, List<String> subTitles, List<String> values) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 2),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **Title**
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8), // Space between title & content

        // **Subtitles & Values**
        if (subTitles.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: subTitles.map((subTitle) {
              return Expanded(
                child: Text(
                  subTitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),

        if (values.isNotEmpty)
          const SizedBox(height: 4), // Space between subtitles & numbers

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: values.map((value) {
            return Expanded(
              child: Text(
                value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

Widget buildStatCard({
  required IconData icon,
  required String value,
  required String label,
  required Color backgroundColor,
  required Color iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );
}

//progress tracker card
class ProgressTrackerCard extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final String message;
  final Color progressColor;

  const ProgressTrackerCard({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.message,
    this.progressColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressTracker(
              totalSteps: totalSteps,
              currentStep: currentStep,
              progressColor: progressColor,
            ),
            const SizedBox(height: 10), // Spacing

            // Custom Message Below Progress Bar
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//progress tracker
class ProgressTracker extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  final Color progressColor;

  const ProgressTracker({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.progressColor = Colors.blueAccent, // Default color
  });

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  int animatedStep = 0;

  @override
  void initState() {
    super.initState();
    _startStepAnimation();
  }

  @override
  void didUpdateWidget(covariant ProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _startStepAnimation();
    }
  }

  Future<void> _startStepAnimation() async {
    for (int i = 0; i <= widget.currentStep; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        animatedStep = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double segmentWidth =
        MediaQuery.of(context).size.width / widget.totalSteps;

    return Row(
      children: List.generate(widget.totalSteps, (index) {
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Grey background line
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        // Animated Filling Line
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: index < animatedStep ? segmentWidth : 0,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.progressColor,
                                widget.progressColor.withValues(alpha: 0.7)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animated Check Icon
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: index < animatedStep ? 1.0 : 0.3,
                    child: Icon(
                      Icons.check_circle,
                      color: index < animatedStep
                          ? widget.progressColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              Text((index + 1).toString()),
            ],
          ),
        );
      }),
    );
  }
}

// bookings popup
void showBookingPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth > 600;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline,
                    size: 40, color: Colors.blueAccent),
                const SizedBox(height: 10),
                Text(
                  'Need More Info or Ready to Book?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Text(
              'Would you like to enquire more about this package or proceed to booking?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: isTablet ? 16 : 14),
            ),
            actions: [
              if (isTablet)
                // Your original tablet layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close',
                          style: GoogleFonts.poppins(color: Colors.red)),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _handleUserAction(context, 'enquire'),
                      child: Text('Submit Your Query',
                          style: GoogleFonts.poppins(color: Colors.orange)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _handleUserAction(context, 'book'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('Book Now',
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                )
              else
                // Phone layout
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleUserAction(context, 'book'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('Book Now'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close',
                              style: GoogleFonts.poppins(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () =>
                              _handleUserAction(context, 'enquire'),
                          child: Text('Submit Query',
                              style: GoogleFonts.poppins(color: Colors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _handleUserAction(BuildContext context, String action) async {
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final mediaQuery = MediaQuery.of(context);

  navigator.pop();

  final loginRes = await SharedPrefHelper().getLoginResponse();

  final userType = loginRes!.userType;

  if (userType == null || userType.isEmpty) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You need to log in to continue',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
                navigator.push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: mediaQuery.size.width * 0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  } else {
    if (action == 'enquire') {
      await navigator.push(
          MaterialPageRoute(builder: (context) => const EnquireNowPage()));
    } else if (action == 'book') {
      await navigator
          .push(MaterialPageRoute(builder: (context) => const BookNowPage()));
    }
  }
}

void showBookingPopupAlternative(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(
              'Need More Info or Ready to Book?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Would you like to enquire more about this package or proceed to booking?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 65),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                ),
              ),
              const SizedBox(width: 65),
              TextButton(
                onPressed: () async {
                  await _handleUserActionWithBanner(context, 'enquire');
                },
                child: Text(
                  'Submit Your Query',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange),
                ),
              ),
              const SizedBox(width: 65),
              ElevatedButton(
                onPressed: () async {
                  await _handleUserActionWithBanner(context, 'book');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Book Now',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> _handleUserActionWithBanner(
    BuildContext context, String action) async {
  final loginRes = await SharedPrefHelper().getLoginResponse();
  final userType = loginRes!.userType;

  if (!context.mounted) return;

  if (userType == null || userType.isEmpty) {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          'You need to log in to continue with your ${action == 'enquire' ? 'enquiry' : 'booking'}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        leading: const Icon(Icons.lock_outline, color: Colors.orange),
        backgroundColor: Colors.orange.shade50,
        actions: [
          TextButton(
            onPressed: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              }
            },
            child: Text(
              'Dismiss',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Login Now',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {
        try {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        } catch (e) {
          Logger.error('error due to technical issue $e');
        }
      }
    });
  } else {
    Navigator.of(context).pop();

    if (!context.mounted) return;

    if (action == 'enquire') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EnquireNowPage()),
      );
    } else if (action == 'book') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookNowPage()),
      );
    }
  }
}

String extractUserId(String fullUserId) {
  if (fullUserId.contains(' - ')) {
    return fullUserId.split(' - ')[0].trim();
  }
  return fullUserId;
}

String extractPathSegment(String fullPath, String folderPrefix) {
  final int index = fullPath.lastIndexOf(folderPrefix);
  if (index != -1) {
    return fullPath.substring(index);
  }
  return fullPath;
}

int? parseIntSafely(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    try {
      return int.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

Future<String?> getDepartmentNameById(String departmentId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final departmentDataString = prefs.getString('departmentData');

    if (departmentDataString != null) {
      final List<dynamic> departmentData = json.decode(departmentDataString);
      final departmentInfo = departmentData.firstWhere(
        (dept) => dept['id'].toString() == departmentId,
        orElse: () => {'id': departmentId, 'dept_name': null},
      );

      return departmentInfo['dept_name']?.toString();
    }
  } catch (e) {
    Logger.error('Error looking up department name: $e');
  }
  return null;
}

Future<String?> getDesignationById(String designationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final designationDataString = prefs.getString('designationData');

    if (designationDataString != null) {
      final List<dynamic> designationData = json.decode(designationDataString);
      final designationInfo = designationData.firstWhere(
        (desg) => desg['id'].toString() == designationId,
        orElse: () => {'id': designationId, 'desg_name': null},
      );
      return designationInfo['designation_name']?.toString();
    }
  } catch (e) {
    Logger.error('Error looking up designation name: $e');
  }
  return null;
}

Future<String?> getReportingManagerNameById(String reportingManagerId) async {
  try {
    final reportingManagerDataList =
        await _isarService.getAll<RegisteredEmployeeModel>();

    // Find the employee with the matching regId
    for (var employee in reportingManagerDataList) {
      if (employee.regId == reportingManagerId) {
        return employee.name;
      }
    }

    // If no match is found, return a default value
    return 'N/A';
  } catch (e) {
    Logger.error('Error fetching reporting manager data: $e');
    return null;
  }
}

Future<String?> getNameByReferenceNo(String referenceNo) async {
  try {
    final userList = await _isarService.getAll<RegisteredEmployeeModel>();

    // Find the user with the matching referenceNo
    for (var user in userList) {
      if (user.regId == referenceNo) {
        Logger.success('Fetched Name is : ${user.name}');
        return user.name;
      }
    }

    // If no match is found, return a default value
    return 'N/A';
  } catch (e) {
    Logger.error('Error fetching user data: $e');
    return null;
  }
}

Future<String?> getZoneById(String zoneId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final zoneDataString = prefs.getString('zones');

    if (zoneDataString != null) {
      final List<dynamic> zoneData = json.decode(zoneDataString);
      final zoneInfo = zoneData.firstWhere(
        (zone) => zone['id'].toString() == zoneId,
        orElse: () => {'id': zoneId, 'zone_name': null},
      );
      return zoneInfo['zone_name']?.toString();
    }
  } catch (e) {
    Logger.error('Error looking up zone name : $e');
  }
  return null;
}

void scrollToFirstFormErrors({
  required BuildContext context,
  required List<ValidationTarget> targets,
}) {
  for (final target in targets) {
    if (target.hasError()) {
      final context = target.key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      return;
    }
  }
}

class ValidationTarget {
  final GlobalKey key;
  final bool Function() hasError;

  ValidationTarget({
    required this.key,
    required this.hasError,
  });
}

// filter bar
class FilterBar1 extends StatefulWidget {
  const FilterBar1({super.key});

  @override
  State<FilterBar1> createState() => _FilterBar1State();
}

class _FilterBar1State extends State<FilterBar1> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  int countUsers = 100; // Example count
  double amount = 5000.00; // Example amount

  String? fromDateError;
  String? toDateError;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    final DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    final DateTime lastDate =
        isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            fromDateError = "From Date can't be after To Date";
          } else {
            fromDate = pickedDate;
            fromDateError = null;
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 6, vertical: 6), // Light padding

        child: Row(
          children: [
            const SizedBox(width: 15),
            // Search Bar
            Expanded(
              flex: 2,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide.none, // No border line
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // From Date Picker
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, true),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    fromDate == null
                        ? 'From Date'
                        : DateFormat.yMMMd().format(fromDate!),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            const Text('  --  '),

            // To Date Picker
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, false),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    toDate == null
                        ? 'To Date'
                        : DateFormat.yMMMd().format(toDate!),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Count Users
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Users: $countUsers'),
              ),
            ),

            const SizedBox(width: 10),

            // Amount
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Amount: ₹${amount.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

// filter bar
class FilterBar2 extends StatefulWidget {
  const FilterBar2({super.key});

  @override
  State<FilterBar2> createState() => _FilterBar2State();
}

class _FilterBar2State extends State<FilterBar2> {
  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  int countUsers = 100; // Example count
  double amount = 5000.00; // Example amount

  String? fromDateError;
  String? toDateError;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime initialDate = isFromDate
        ? fromDate ?? DateTime.now()
        : toDate ?? fromDate ?? DateTime.now();

    final DateTime firstDate =
        isFromDate ? DateTime(2000) : fromDate ?? DateTime(2000);
    final DateTime lastDate =
        isFromDate ? toDate ?? DateTime(2101) : DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          if (toDate != null && pickedDate.isAfter(toDate!)) {
            fromDateError = "From Date can't be after To Date";
          } else {
            fromDate = pickedDate;
            fromDateError = null;
          }
        } else {
          if (fromDate != null && pickedDate.isBefore(fromDate!)) {
            toDateError = "To Date can't be before From Date";
          } else {
            toDate = pickedDate;
            toDateError = null;
          }
        }
      });
    }
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            const DropdownMenuItem(
              value: '-- Select --',
              child: Text('-- Select --', style: TextStyle(color: Colors.grey)),
            ),
            ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
          ],
          onChanged: (value) {
            // Handle selection
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, bool isFromDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isFromDate),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            isFromDate
                ? (fromDate == null
                    ? label
                    : DateFormat.yMMMd().format(fromDate!))
                : (toDate == null ? label : DateFormat.yMMMd().format(toDate!)),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _buildDropdown('Designation', ['Option 1', 'Option 2', 'Option 3']),
            _buildDropdown('User', ['Active', 'Inactive', 'Pending']),
            _buildDateSelector('From Date', true),
            const SizedBox(width: 3),
            const Text('--',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 3),
            _buildDateSelector('To Date', false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  } catch (e) {
    return 'Invalid Date';
  }
}

Widget buildTripOrRefundNote(
    {required String userType, required BuildContext context}) {
  // For "premium select" and "neo select", show simple "Refer and earn" message
  if (userType == 'Premium Select' ||
      userType == 'Premium Select Lite' ||
      userType == 'Neo Select') {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.4)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.card_giftcard, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refer & Earn Exclusive Rewards 🎁',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              'Share the premium experience with your network and ',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        TextSpan(
                          text: 'get rewarded for every successful referral!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '💰 ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'Instant Cash Rewards: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Receive direct commission in your wallet for each referral that joins our premium community',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '✈️ ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'Travel Benefits: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Exclusive upgrades, lounge access, and special travel perks',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '🎫 ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'Free Trip Opportunities: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Earn complimentary travel experiences with every milestone you achieve',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add your first referral to start earning rewards today!',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddReferralCustomer(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withValues(alpha: 0.3),
                      ),
                      child: const Text(
                        'Add Referral',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // For "premium" users, show the original detailed content
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.airplane_ticket, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Membership Benefits ✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Your premium membership comes with exclusive travel opportunities ',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      TextSpan(
                        text: 'and guaranteed value protection!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '🎯 ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: 'Coupon Utilization Reward: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const TextSpan(
                        text:
                            'Use all 3 coupons to unlock an exclusive Europe Trip experience 🎉',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '🛡️ ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: 'Value Protection Guarantee: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const TextSpan(
                        text:
                            'If unused within 3 years, receive ₹30,000 refund + ₹10,000 loyalty bonus 💸',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '⏰ ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: 'Flexible Timeline: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '3-year window to utilize your coupons with no pressure',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your investment is protected while you enjoy premium travel opportunities!',
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
