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
  @override
  void initState() {
    super.initState();
  }

  void getUserType() async {
    final getUserType = await SharedPrefHelper().getUserType();
    Logger.info("User Type from Shared Preferences: $getUserType");

    setState(() {
      userType = getUserType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Fixed Drawer Header with NO white space issues
          Container(
            width: double.infinity, // Ensures full width
            color: Color.fromARGB(255, 81, 131, 246), // Background color
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/user_image.jpg'),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
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
                // ListTile(
                //   leading: Icon(Icons.favorite, color: Colors.red),
                //   title: Text("Wishlist"),
                //   onTap: () {},
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Admin Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => AdminDashboard()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Business Channel Head Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => BCHDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Business Development Manager Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => BDMDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Business Mentor Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => BMDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Techno Enterprise Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => TEDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Travel Consultant Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => TCDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.dashboard, color: Colors.orange),
                //   title: Text("My Customer Dashboard"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => CDashboardPage()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.person, color: Colors.green),
                //   title: Text("Profile"),
                //   onTap: () {},
                // ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text("Log in"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Logo at the Bottom (ALWAYS sticks there)
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
}
