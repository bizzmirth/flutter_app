import 'package:bizzmirth_app/screens/dashboards/admin/admin_dashboard.dart';
import 'package:bizzmirth_app/screens/dashboards/business_channel_head/business_channel_head.dart';
import 'package:bizzmirth_app/screens/dashboards/business_development_manager/business_development_manager.dart';
import 'package:bizzmirth_app/screens/dashboards/business_mentor/business_mentor.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/techno_enterprise/techno_enterprise.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/travel_consultant.dart';
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ✅ **Side Navigation Drawer**
class SideNavDrawer extends StatefulWidget {
  const SideNavDrawer({super.key});

  @override
  State<SideNavDrawer> createState() => _SideNavDrawerState();
}

class _SideNavDrawerState extends State<SideNavDrawer> {
  String? userType = '';
  String? userName = '';
  String? userProfilePic = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  void getUserType() async {
    final getUserType = await SharedPrefHelper().getUserType();
    final getUserName = await SharedPrefHelper().getCustomerName();
    final getUserProfilePic = await SharedPrefHelper().getCustomerProfilePic();
    Logger.info("User Type from Shared Preferences: $getUserType");

    setState(() {
      userType = getUserType;
      userName = getUserName;
      userProfilePic = getUserProfilePic;
      isLoading = false;
    });
  }

  void _navigateToDashboard(BuildContext context, String userType) {
    switch (userType) {
      case "Admin":
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

  String _getDashboardTitle(String userType) {
    switch (userType) {
      case "Admin":
        return "My Admin Dashboard";
      case "Customer":
        return "My Customer Dashboard";
      case "Travel Consultant":
        return "My Travel Consultant Dashboard";
      case "Techno Enterprise":
        return "My Techno Enterprise Dashboard";
      case "Business Channel manager":
        return "My Business Channel Head Dashboard";
      case "Business Development Manager":
        return "My Business Development Manager Dashboard";
      case "Business Mentor":
        return "My Business Mentor Dashboard";
      default:
        return "My Dashboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 81, 131, 246),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userProfilePic != null && userProfilePic!.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(userProfilePic!),
                      radius: 30,
                      onBackgroundImageError: (_, __) {
                        setState(() {
                          userProfilePic = '';
                        });
                      },
                    )
                  else
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/user_image.jpg'),
                      radius: 30,
                    ),
                  SizedBox(height: 10),
                  if (userName != null && userName!.isNotEmpty)
                    Text(
                      "Welcome, $userName!",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      "Welcome, Traveler!",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    "Explore the best trips and deals",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation items (uses Expanded to take up space)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.blue),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Show loading indicator while fetching user type
                if (isLoading)
                  ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text("Loading..."),
                  ),
                if (!isLoading && userType != null && userType!.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.orange),
                    title: Text(_getDashboardTitle(userType!)),
                    onTap: () {
                      _navigateToDashboard(context, userType!);
                    },
                  ),

                Divider(),
                ListTile(
                  leading: Icon(
                    (userType != null && userType!.isNotEmpty)
                        ? Icons.logout
                        : Icons.login,
                    color: Colors.black,
                  ),
                  title: Text((userType != null && userType!.isNotEmpty)
                      ? "Log out"
                      : "Log in"),
                  onTap: () {
                    if (userType != null && userType!.isNotEmpty) {
                      _handleLogout();
                    } else {
                      // Handle login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              "assets/bizz_logo.png",
              height: 80,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    await SharedPrefHelper().removeDetails();
    setState(() {
      userType = '';
      userName = '';
      userProfilePic = '';
    });
    Logger.info("User logged out successfully");
  }
}
