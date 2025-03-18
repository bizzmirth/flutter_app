import 'package:bizzmirth_app/controllers/login_controller.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/admin_dashboard.dart';
import 'package:bizzmirth_app/screens/dashboards/business_channel_head/business_channel_head.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/business_development_manager.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/business_mentor.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/techno_enterprise/techno_enterprise.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/travel_consultant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<LoginController>(context, listen: false);
      controller.loadUserTypes();
    });
  }

  // Navigate to the appropriate dashboard based on user type
  void _navigateToDashboard(BuildContext context, String userType) {
    switch (userType) {
      case "admin":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
        break;
      case "Customer":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CDashboardPage()),
        );
        break;
      case "Travel Consultant":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TCDashboardPage()),
        );
        break;
      case "Techno Enterprise":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TEDashboardPage()),
        );
        break;
      case "Business Channel manager":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BCHDashboardPage()),
        );
        break;
      case "Business Development Manager":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BDMDashboardPage()),
        );
        break;
      case "Business Mentor":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BMDashboardPage()),
        );
        break;
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    final controller = Provider.of<LoginController>(context, listen: false);
    final result = await controller.loginUser();

    if (result["success"]) {
      if (!context.mounted) return;
      _navigateToDashboard(context, result["user_type"]);
    }
  }

  Widget _buildCustomDropdown(String label, List<Map<String, String>> items) {
    final controller = Provider.of<LoginController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.selectedUserTypeId, // Default selection
        hint: Text("Select $label"),
        isExpanded: true,
        items: controller.userTypeNames.map((e) {
          return DropdownMenuItem<String>(
            value: e["id"],
            child: Text(e["name"]!),
          );
        }).toList(),
        onChanged: (value) => controller.setSelectedUserType(value),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.person, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Detect if the device is a tablet (assumed if width > 600)
    final bool isTablet = screenWidth > 600;

    // Adjust padding dynamically based on device type & orientation
    final double outerHorizontalPadding = isTablet
        ? (isPortrait ? 190 : 380) // Tablet padding
        : (isPortrait
            ? 30 // Portrait padding for phone
            : screenWidth > screenHeight
                ? 40 // Landscape padding for phones
                : 80); // Fallback padding for landscape if the condition fails

    final double outerVerticalPadding = isPortrait ? 50 : 30;
    final double innerHorizontalPadding = isTablet
        ? (isPortrait ? 50 : 60)
        : (screenWidth > screenHeight
            ? 40
            : 30); // Adjust inner padding in landscape
    final controller = Provider.of<LoginController>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/tokyo.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // Login Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: outerHorizontalPadding, // ✅ Dynamic padding
                  vertical: outerVerticalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Image.asset(
                      "assets/uniqbizz.png",
                      height: 100,
                    ),
                    const SizedBox(height: 1),

                    // Login Card with Dynamic Padding
                    Form(
                      key: _loginFormKey,
                      child: Container(
                        width: screenWidth < 600
                            ? screenWidth * 0.8
                            : screenWidth * 0.6, // Adjust width
                        padding: EdgeInsets.symmetric(
                            horizontal: innerHorizontalPadding,
                            vertical: 30), // ✅ Dynamic inner padding
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildCustomDropdown(
                              'Users *',
                              controller.userTypeNames,
                            ),
                            const SizedBox(height: 10),
                            if (controller.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  controller.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            // Email Input
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon:
                                    const Icon(Icons.email, color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Please enter your email";
                              //   }
                              //   if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                              //     return "Enter a valid email address";
                              //   }
                              //   return null;
                              // },  usee this when we start using email for login
                            ),
                            const SizedBox(height: 20),

                            // Password Input
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      controller.togglePasswordVisibility(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Remember Me
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // ✅ Remember Me Checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                      value: controller.rememberMe,
                                      onChanged: (value) =>
                                          controller.toggleRememberMe(value!),
                                    ),
                                    const Text("Remember Me"),
                                  ],
                                ),

                                // ✅ Forgot Password Button
                                TextButton(
                                  onPressed: () {
                                    // Navigate to Forgot Password Page (Placeholder)
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                    // );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.blue, // Matches theme
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Login Button
                            ElevatedButton(
                              onPressed: controller.isLoading
                                  ? null
                                  : () => _handleLogin(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 81, 131, 246),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Footer Text
                    Text(
                      "© 2025 Uniqbizz. Crafted with ♡ by Bizzmirth Holdays",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600, // Made it a bit bolder
                      ),
                    ),
                    Image.asset(
                      "assets/bizz_logo.png",
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
