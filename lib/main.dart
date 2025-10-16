import 'dart:async';
import 'dart:io';
import 'package:bizzmirth_app/controllers/admin_controller/admin_busniess_mentor_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_customer_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_designation_department_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_employee_controller.dart';
import 'package:bizzmirth_app/controllers/all_packages_controllers/package_details_controller.dart';
import 'package:bizzmirth_app/controllers/all_packages_controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/contact_us_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/home_page_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/login_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/profile_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_order_history_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_product_payout_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_referral_payout_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_wallet_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_customer_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_markup_controller.dart';
import 'package:bizzmirth_app/data_source/te_data_sources/te_view_package_data_source.dart';
import 'package:bizzmirth_app/models/customer_models/cust_referral_payout_model.dart';

import 'package:bizzmirth_app/screens/homepage/homepage.dart';
import 'package:bizzmirth_app/screens/login_page/login.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/intl.dart';

void main() async {
  bypassSSLVerification();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final sessionStateStream = StreamController<SessionState>();
  late SessionConfig sessionConfig;
  StreamSubscription<SessionTimeoutState>? _sessionSubscription;

  @override
  void initState() {
    super.initState();

    sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 30),
      invalidateSessionForUserInactivity: const Duration(minutes: 30),
    );

    // Listen to session timeout events
    _sessionSubscription = sessionConfig.stream.listen((timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = MyApp.navigatorKey.currentContext;
        if (currentContext != null && mounted) {
          _handleSessionTimeout(currentContext, timeoutEvent);
        }
      });
    });
  }

  Future<void> _handleSessionTimeout(
      BuildContext context, SessionTimeoutState timeoutEvent) async {
    if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
      final sharedPrefHelper = SharedPrefHelper();
      Logger.warning('User inactivity timeout triggered');
      ToastHelper.showErrorToast(
        title: 'Session Expired',
        description:
            'You have been inactive for too long. Please log in again.',
      );
      await sharedPrefHelper.removeDetails();
      if (!context.mounted) return;
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    sessionStateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => CustomerController()),
        ChangeNotifierProvider(create: (_) => AdminEmployeeController()),
        ChangeNotifierProvider(create: (_) => AdminBusniessMentorController()),
        ChangeNotifierProvider(
            create: (_) => AdminDesignationDepartmentController()),
        ChangeNotifierProvider(create: (_) => AdminCustomerController()),
        ChangeNotifierProvider(create: (_) => CustProductPayoutController()),
        ChangeNotifierProvider(create: (_) => CustReferralPayoutController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => CustWalletController()),
        ChangeNotifierProvider(create: (_) => CustOrderHistoryController()),
        ChangeNotifierProvider(create: (_) => TourPackagesController()),
        ChangeNotifierProvider(create: (_) => ContactUsController()),
        ChangeNotifierProvider(create: (_) => PackageDetailsController()),
        ChangeNotifierProvider(create: (_) => TcController()),
        ChangeNotifierProvider(create: (_) => TcCustomerController()),
        ChangeNotifierProvider(create: (_) => TcMarkupController()),
      ],
      child: ToastificationWrapper(
        child: SessionTimeoutManager(
          // userActivityDebounceDuration: const Duration(seconds: 1),
          sessionConfig: sessionConfig,
          // sessionStateStream: sessionStateStream.stream,
          child: MaterialApp(
            navigatorKey: MyApp.navigatorKey,
            title: 'UniqBizz',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            builder: (context, child) {
              final size = MediaQuery.of(context).size.width;

              // scale factor based on width (phone < 600, tablet >= 600)
              final double scale = size < 600 ? 0.85 : 1.0;

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale), // ✅ scales all text
                ),
                child: child!,
              );
            },
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
            // showPerformanceOverlay: true,
          ),
        ),
      ),
    );
  }
}

void bypassSSLVerification() {
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

final List<Map<String, dynamic>> customersTA = [
  {
    'id': '1',
    'name': 'Savio Vaz',
    'dateReg': '10/01/2022',
    'totalCURef': 15,
    'status': 'Active',
  },
  {
    'id': '2',
    'name': 'Pandurang Naik',
    'dateReg': '15/03/2021',
    'totalCURef': 7,
    'status': 'Inactive',
  },
  {
    'id': '3',
    'name': 'Nishant C M',
    'dateReg': '11/06/2025',
    'totalCURef': 22,
    'status': 'Active',
  },
  {
    'id': '4',
    'name': 'Shravan Apte',
    'dateReg': '01/03/2025',
    'totalCURef': 3,
    'status': 'Inactive',
  },
  {
    'id': '5',
    'name': 'Rohan Patil',
    'dateReg': '25/12/2024',
    'totalCURef': 10,
    'status': 'Active',
  },
  {
    'id': '6',
    'name': 'Amit Desai',
    'dateReg': '05/08/2023',
    'totalCURef': 5,
    'status': 'Inactive',
  },
  {
    'id': '7',
    'name': 'Kiran Naik',
    'dateReg': '17/11/2022',
    'totalCURef': 8,
    'status': 'Active',
  },
  {
    'id': '8',
    'name': 'Meera Patil',
    'dateReg': '22/02/2024',
    'totalCURef': 12,
    'status': 'Active',
  },
  {
    'id': '9',
    'name': 'Vikram Jadhav',
    'dateReg': '03/07/2021',
    'totalCURef': 4,
    'status': 'Inactive',
  },
  {
    'id': '10',
    'name': 'Priya Naik',
    'dateReg': '30/09/2023',
    'totalCURef': 6,
    'status': 'Active',
  },
];

final List<Map<String, dynamic>> orders = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'design': 'BM',
    'jd': '10/01/2022',
    'status': 'Approved',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2',
    'name': 'Pandurang Naik',
    'phone': '9876543210',
    'phone1': 'Pandurang Naik',
    'design': 'BM',
    'jd': '15/03/2021',
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'design': 'BM',
    'jd': '11/06/2025',
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Shravan Apte',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
];

final List<Map<String, dynamic>> ordersBM = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Approved',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Pandurang Naik',
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'jd': '11/06/2025',
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': '9876543210',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
];

final List<Map<String, dynamic>> orderstechno = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Approved',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Pandurang Naik',
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'jd': '11/06/2025',
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
];

final List<Map<String, dynamic>> orderstechno1 = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Pandurang Naik',
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210',
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
];

final List<Map<String, dynamic>> packagemarkup = [
  {
    'id': '1',
    'pid': '11123',
    'pname': 'Shimla',
    'taname': 'Shravan Apte',
    'aprice': '32000',
    'mprice': '2000',
    'madded': 'Yes',
    'sprice': '34000',
  },
  {
    'id': '2',
    'pid': '11123',
    'pname': 'Shimla',
    'taname': 'Shravan Apte',
    'aprice': '32000',
    'mprice': '2000',
    'madded': 'Yes',
    'sprice': '34000',
  },
  {
    'id': '3',
    'pid': '11123',
    'pname': 'Shimla',
    'taname': 'Shravan Apte',
    'aprice': '32000',
    'mprice': '2000',
    'madded': 'Yes',
    'sprice': '34000',
  },
  {
    'id': '4',
    'pid': '11123',
    'pname': 'Shimla',
    'taname': 'Shravan Apte',
    'aprice': '32000',
    'mprice': '2000',
    'madded': 'Yes',
    'sprice': '34000',
  },
  {
    'id': '5',
    'pid': '11123',
    'pname': 'Shimla',
    'taname': 'Shravan Apte',
    'aprice': '32000',
    'mprice': '2000',
    'madded': 'Yes',
    'sprice': '34000',
  },
];

final List<Map<String, dynamic>> verQuo = [
  {
    'id': '1',
    'name': 'Cinetta Dsouza',
    'email': 'cinetta1991@gmail.com',
    'destination': 'Maldives',
    'date': '2022-04-24',
  },
  {
    'id': '2',
    'name': 'Mahendra Choudhary',
    'email': 'mc218071@gmail.com',
    'destination': 'Bangalore',
    'date': '2022-09-03',
  },
];

final List<Map<String, dynamic>> tcorders = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210',
    'jd': '10/01/2022',
    'status': 'Approved',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '0123456789',
    'jd': '11/06/2025',
    'status': 'Pending',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Cancelled',
  },
];

final List<Map<String, dynamic>> tcorders1 = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'rid': '1',
    'rname': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '0123456789',
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
];

final List<Map<String, dynamic>> tcvieworders1 = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'rid': '1',
    'rname': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Completed',
    'ps': '4'
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '15/03/2021', // Changed from "JD" to "jd"
    'status': 'Completed',
    'ps': '4'
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '0123456789',
    'jd': '11/06/2025',
    'status': 'Completed',
    'ps': '4'
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'rid': '1',
    'rname': 'Savio Vaz',
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
    'ps': '4'
  },
];

final List<Map<String, dynamic>> orders1 = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'design': 'BM',
    'jd': '10/01/2022',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Pandurang Naik', // Changed from "JD" to "jd"
    'design': 'BM',
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'design': 'BM',
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Shravan Apte',
    'design': 'BM',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
];

final List<Map<String, dynamic>> orders1BM = [
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/1.jpg',
    'id': '1',
    'name': 'Savio Vaz',
    'phone': '9876543210',
    'phone1': 'Savio Vaz',
    'jd': '10/01/2022',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/2.jpg',
    'id': '2', // Changed from "Id" to "id"
    'name': 'Pandurang Naik', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Pandurang Naik', // Changed from "JD" to "jd"
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/3.jpg',
    'id': '3',
    'name': 'Nishant C M',
    'phone': '0123456789',
    'phone1': 'Nishant C M',
    'jd': '11/06/2025',
    'status': 'Completed',
  },
  {
    'profilePicture': 'https://randomuser.me/api/portraits/men/4.jpg',
    'id': '4', // Changed from "Id" to "id"
    'name': 'Shravan Apte', // Changed from "Name" to "name"
    'phone': '9876543210', // Changed from "Phone/Email" to "phone"
    'phone1': 'Shravan Apte',
    'jd': '01/03/2025', // Changed from "JD" to "jd"
    'status': 'Completed',
  },
];

final List<Map<String, String>> packages = [
  {
    'id': '1',
    'uid': 'BH24040',
    'name': 'Darjeeling',
    'aprice': '24361',
    'cprice': '24361',
    'ptype': 'Domestic',
  },
  {
    'id': '2',
    'uid': 'BH24041',
    'name': 'USA',
    'aprice': '24361',
    'cprice': '24361',
    'ptype': 'International',
  },
  {
    'id': '3',
    'uid': 'BH24042',
    'name': 'Sri Lanka',
    'aprice': '24361',
    'cprice': '24361',
    'ptype': 'International',
  },
  {
    'id': '4',
    'uid': 'BH24045',
    'name': 'Delhi',
    'aprice': '24361',
    'cprice': '24361',
    'ptype': 'Domestic',
  },
];

final List<Map<String, String>> viewpackages = [
  {
    'id': '1',
    'name': 'Darjeeling',
    'aprice': '24361',
    'cprice': '24361',
    'sprice': '24361',
  },
  {
    'id': '2',
    'name': 'USA',
    'aprice': '24361',
    'cprice': '24361',
    'sprice': '24361',
  },
  {
    'id': '3',
    'name': 'Sri Lanka',
    'aprice': '24361',
    'cprice': '24361',
    'sprice': '24361',
  },
  {
    'id': '4',
    'name': 'Delhi',
    'aprice': '24361',
    'cprice': '24361',
    'sprice': '24361',
  },
];

final List<Map<String, String>> packagehist = [
  {
    'id': '1',
    'date': '13-Feb-2025',
    'name': 'CU240002 Tovino Thomas',
    'pname': 'Leh Ladakh',
    'amount': '32023.95',
    'status': 'Pending',
  },
  {
    'id': '2',
    'date': '13-Feb-2025',
    'name': 'CU240002 Tovino Thomas',
    'pname': 'Leh Ladakh',
    'amount': '32023.95',
    'status': 'Completed',
  },
  {
    'id': '3',
    'date': '13-Feb-2025',
    'name': 'CU240002 Tovino Thomas',
    'pname': 'Leh Ladakh',
    'amount': '32023.95',
    'status': 'Pending',
  },
  {
    'id': '4',
    'date': '13-Feb-2025',
    'name': 'CU240002 Tovino Thomas',
    'pname': 'Leh Ladakh',
    'amount': '32023.95',
    'status': 'Pending',
  },
];

final List<Map<String, String>> aminitiesstay = [
  {
    'id': '1',
    'name': '1 Star',
  },
  {
    'id': '2',
    'name': '2 Star',
  },
  {
    'id': '3',
    'name': '3 Star',
  },
  {
    'id': '4',
    'name': '4 Star',
  },
  {
    'id': '5',
    'name': '5 Star',
  },
  {
    'id': '6',
    'name': 'Villa',
  },
  {
    'id': '7',
    'name': 'Apartment',
  },
  {
    'id': '8',
    'name': 'Mansion',
  },
];

final List<Map<String, String>> category = [
  {
    'name': 'International',
  },
  {
    'name': 'Domestic',
  },
];

final List<Map<String, String>> aminitiesmeals = [
  {
    'id': '1',
    'name': 'Breakfast',
  },
  {
    'id': '2',
    'name': 'Breakfast + Dinner',
  },
  {
    'id': '3',
    'name': 'Breakfast + Lunch + Dinner',
  },
  {
    'id': '4',
    'name': 'No Meals',
  },
];

final List<Map<String, String>> recruitmentpayout = [
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'amount': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Done',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'amount': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Done',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'amount': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Done',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'amount': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Done',
  },
];

final List<Map<String, String>> tCrecruitmentpayout = [
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'markup': 'Details xyz',
    'prodpay': '23000',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'markup': 'Details xyz',
    'prodpay': '23000',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Pending',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'markup': 'Details xyz',
    'prodpay': '23000',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'markup': 'Details xyz',
    'prodpay': '23000',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Pending',
  },
];

final List<Map<String, String>> bMrecruitmentpayout = [
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
  {
    'date': '13-Feb-2025',
    'name': 'Details xyz',
    'total': '23000',
    'tds': '200',
    'payable': '23200',
    'remark': 'Completed',
  },
];

final List<Map<String, String>> aminitiesvehicles = [
  {
    'id': '1',
    'name': 'Car',
  },
  {
    'id': '2',
    'name': 'Bus',
  },
  {
    'id': '3',
    'name': 'Train',
  },
  {
    'id': '4',
    'name': 'Volvo Bus',
  },
];

final List<Map<String, String>> aminitiesoccupancy = [
  {
    'id': '1',
    'name': 'Single',
  },
  {
    'id': '2',
    'name': 'Double',
  },
  {
    'id': '3',
    'name': 'Triple',
  },
  {
    'id': '4',
    'name': 'Quad',
  },
  {
    'id': '5',
    'name': 'Extra Bed',
  },
];

final List<Map<String, String>> pendingMentors = [
  {
    'id': '1',
    'name': 'Rahul Shet',
    'phone': '+91 998524125',
    'email': 'rahul@gmail.com',
    'address': 'Mapusa, Goa',
    'dob': '14-02-1980',
    'joining_date': '14-02-2025',
  },
  {
    'id': '2',
    'name': 'Amit Verma',
    'phone': '+91 9876543210',
    'email': 'amit@gmail.com',
    'address': 'Panjim, Goa',
    'dob': '10-05-1985',
    'joining_date': '20-06-2023',
  },
  {
    'id': '3',
    'name': 'Sneha Joshi',
    'phone': '+91 9871234560',
    'email': 'sneha@gmail.com',
    'address': 'Margao, Goa',
    'dob': '23-07-1990',
    'joining_date': '01-08-2022',
  },
  {
    'id': '4',
    'name': 'Rajesh Kumar',
    'phone': '+91 8888888888',
    'email': 'rajesh@gmail.com',
    'address': 'Vasco, Goa',
    'dob': '05-11-1975',
    'joining_date': '12-09-2021',
  },
  {
    'id': '5',
    'name': 'Priya Sharma',
    'phone': '+91 9999999999',
    'email': 'priya@gmail.com',
    'address': 'Calangute, Goa',
    'dob': '14-12-1993',
    'joining_date': '22-03-2020',
  },
  {
    'id': '6',
    'name': 'Vikram Patel',
    'phone': '+91 9000000000',
    'email': 'vikram@gmail.com',
    'address': 'Baga, Goa',
    'dob': '02-04-1988',
    'joining_date': '05-07-2023',
  },
  {
    'id': '7',
    'name': 'Anjali Mehta',
    'phone': '+91 7777777777',
    'email': 'anjali@gmail.com',
    'address': 'Candolim, Goa',
    'dob': '19-09-1995',
    'joining_date': '10-10-2019',
  },
  {
    'id': '8',
    'name': 'Sandeep Rao',
    'phone': '+91 6666666666',
    'email': 'sandeep@gmail.com',
    'address': 'Siolim, Goa',
    'dob': '06-06-1982',
    'joining_date': '17-11-2021',
  },
  {
    'id': '9',
    'name': 'Neha Kapoor',
    'phone': '+91 5555555555',
    'email': 'neha@gmail.com',
    'address': 'Anjuna, Goa',
    'dob': '11-03-1998',
    'joining_date': '02-05-2024',
  },
  {
    'id': '10',
    'name': 'Arjun Singh',
    'phone': '+91 4444444444',
    'email': 'arjun@gmail.com',
    'address': 'Colva, Goa',
    'dob': '27-08-1991',
    'joining_date': '28-08-2023',
  },
  {
    'id': '11',
    'name': 'Pooja Nair',
    'phone': '+91 3333333333',
    'email': 'pooja@gmail.com',
    'address': 'Betalbatim, Goa',
    'dob': '22-01-1986',
    'joining_date': '14-02-2022',
  },
  {
    'id': '12',
    'name': 'Saurabh Gupta',
    'phone': '+91 2222222222',
    'email': 'saurabh@gmail.com',
    'address': 'Palolem, Goa',
    'dob': '15-10-1990',
    'joining_date': '05-06-2021',
  },
  {
    'id': '13',
    'name': 'Ritika Sen',
    'phone': '+91 1111111111',
    'email': 'ritika@gmail.com',
    'address': 'Agonda, Goa',
    'dob': '30-12-1992',
    'joining_date': '11-09-2023',
  },
  {
    'id': '14',
    'name': 'Kunal Sharma',
    'phone': '+91 1234567890',
    'email': 'kunal@gmail.com',
    'address': 'Chapora, Goa',
    'dob': '17-07-1984',
    'joining_date': '20-12-2020',
  },
  {
    'id': '15',
    'name': 'Meera Das',
    'phone': '+91 1098765432',
    'email': 'meera@gmail.com',
    'address': 'Arambol, Goa',
    'dob': '08-05-1996',
    'joining_date': '15-01-2023',
  },
];

class MyBMCustPendingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBMCustPendingDataSource(this.data, this.context);
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBDMCustPendingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBDMCustPendingDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBCHCustPendingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBCHCustPendingDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyEmployeeRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyEmployeeRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['design']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        const PopupMenuItem(
          value: 'unregister',
          child: ListTile(
            leading: Icon(Icons.app_registration,
                color: Color.fromARGB(255, 0, 238, 127)),
            title: Text('Un-Register'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBCHCustRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBCHCustRegDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBDMCustRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBDMCustRegDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBMCustRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBMCustRegDataSource(this.data, this.context);
  final BuildContext context; // Pass context from parent widget

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case 'add_ref':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case 'edit':
            break;
          case 'delete':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'add_ref',
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text('Add Ref'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class ViewMyBMRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  ViewMyBMRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyTCDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyTCDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['rid']?.toString() ?? 'N/A')),
        DataCell(Text(order['rname']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        const PopupMenuItem(
          value: 'register',
          child: ListTile(
            leading: Icon(Icons.app_registration,
                color: Color.fromARGB(255, 43, 29, 240)),
            title: Text('Register'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyViewTCDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyViewTCDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['rid']?.toString() ?? 'N/A')),
        DataCell(Text(order['rname']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyPackageMarkupApprovedDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyPackageMarkupApprovedDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['pid']?.toString() ?? 'N/A')),
        DataCell(Text(order['pname']?.toString() ?? 'N/A')),
        DataCell(Text(order['taname']?.toString() ?? 'N/A')),
        DataCell(
          Text("₹ ${order["aprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(
          Text("₹ ${order["mprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(Text(order['madded']?.toString() ?? 'N/A')),
        DataCell(
          Text("₹ ${order["sprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'disapprove',
          child: ListTile(
            leading: Icon(Icons.close, color: Color.fromARGB(255, 255, 5, 5)),
            title: Text('Disapprove'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyPackageMarkupDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyPackageMarkupDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['pid']?.toString() ?? 'N/A')),
        DataCell(Text(order['pname']?.toString() ?? 'N/A')),
        DataCell(Text(order['taname']?.toString() ?? 'N/A')),
        DataCell(
          Text("₹ ${order["aprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(
          Text("₹ ${order["mprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(Text(order['madded']?.toString() ?? 'N/A')),
        DataCell(
          Text("₹ ${order["sprice"]?.toString() ?? "N/A"}"),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'approve',
          child: ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text('Approve'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyAmenityStarTypeDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyAmenityStarTypeDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.green),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyAmenityMealsTypeDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyAmenityMealsTypeDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.green),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyAmenityVehiclesTypeDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyAmenityVehiclesTypeDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.green),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyAmenityOccupancyTypeDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyAmenityOccupancyTypeDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.green),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyCategoryDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyCategoryDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.green),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyQuotationsDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyQuotationsDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(
          Text(order['email']?.toString() ?? 'N/A'),
        ),
        DataCell(
          Text(order['destination']?.toString() ?? 'N/A'),
        ),
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'pending',
          child: ListTile(
            leading: Icon(Icons.rotate_right, color: Colors.blue),
            title: Text('Pending'),
          ),
        ),
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye,
                color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'onhold',
          child: ListTile(
            leading: Icon(Icons.motion_photos_pause_sharp,
                color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('On Hold'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyQuotationsApprovedDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyQuotationsApprovedDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(
          Text(order['email']?.toString() ?? 'N/A'),
        ),
        DataCell(
          Text(order['destination']?.toString() ?? 'N/A'),
        ),
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'verified',
          child: ListTile(
            leading: Icon(Icons.verified, color: Colors.green[400]),
            title: const Text('Verified'),
          ),
        ),
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye,
                color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('View'),
          ),
        ),
        PopupMenuItem(
          value: 'sold',
          child: ListTile(
            leading: Icon(Icons.currency_exchange_outlined,
                color: Colors.green[400]),
            title: const Text('Sold'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyPackageDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyPackageDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['uid']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['aprice']?.toString() ?? 'N/A')),
        DataCell(Text(order['cprice']?.toString() ?? 'N/A')),
        DataCell(Text(order['ptype']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyPackageOrderHistDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyPackageOrderHistDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['pname']?.toString() ?? 'N/A')),
        DataCell(
          Text("₹ ${order["amount"]?.toString() ?? "N/A"}"),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyRecruitmentPayoutDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyRecruitmentPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['amount']?.toString() ?? 'N/A')),
        DataCell(Text(order['tds']?.toString() ?? 'N/A')),
        DataCell(Text(order['payable']?.toString() ?? 'N/A')),
        DataCell(Text(order['remark']?.toString() ?? 'N/A')),
      ],
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyProductionPayoutDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyProductionPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['amount']?.toString() ?? 'N/A')),
        DataCell(Text(order['tds']?.toString() ?? 'N/A')),
        DataCell(Text(order['payable']?.toString() ?? 'N/A')),
        DataCell(Text(order['remark']?.toString() ?? 'N/A')),
      ],
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyBMProductionPayoutDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyBMProductionPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['total']?.toString() ?? 'N/A')),
        DataCell(Text(order['tds']?.toString() ?? 'N/A')),
        DataCell(Text(order['payable']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['remark']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['remark']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyTCProductionPayoutDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyTCProductionPayoutDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order['date']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['markup']?.toString() ?? 'N/A')),
        DataCell(Text(order['prodpay']?.toString() ?? 'N/A')),
        DataCell(Text(order['total']?.toString() ?? 'N/A')),
        DataCell(Text(order['tds']?.toString() ?? 'N/A')),
        DataCell(Text(order['payable']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['remark']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['remark']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyTCRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyTCRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['rid']?.toString() ?? 'N/A')),
        DataCell(Text(order['rname']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

var dummyPayoutData = [
  CustReferralPayoutModel(
    date: '2025-07-14',
    payoutDetails:
        'Niranjan asdGaowkar (ID: CU250048) has earned ₹250 for referring Dhanraj Sahu (ID: CU250049) as a Level 1 referrer.',
    amount: '250',
    tds: '5',
    totalPayable: '245',
    status: 'Pending',
  ),
  CustReferralPayoutModel(
    date: '2025-07-14',
    payoutDetails:
        'Niranjan Gaowkar (ID: CU250048) has gained 250 booking points for referring Dhanraj Sahu (ID: CU250049) as a Level 1 referrer.',
    amount: '250',
    tds: 'NA',
    totalPayable: '250',
    status: 'Credited',
  ),
];

class MyViewTCRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyViewTCRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['rid']?.toString() ?? 'N/A')),
        DataCell(Text(order['rname']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(Text(order['ps']?.toString() ?? 'N/A')),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

// Custom DataTable Source for Pagination
class MyTechnoPendingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyTechnoPendingDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        const PopupMenuItem(
          value: 'register',
          child: ListTile(
            leading: Icon(Icons.app_registration, color: Colors.purple),
            title: Text('Register'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyTechnoRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyTechnoRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        const PopupMenuItem(
          value: 'un-register',
          child: ListTile(
            leading: Icon(Icons.app_registration, color: Colors.green),
            title: Text('Un-register'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class MyViewTechnoRegDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  MyViewTechnoRegDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(order['profilePicture']),
            ),
          ),
        ),
        DataCell(Text(order['id']?.toString() ?? 'N/A')),
        DataCell(Text(order['name']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone']?.toString() ?? 'N/A')),
        DataCell(Text(order['phone1']?.toString() ?? 'N/A')),
        DataCell(Text(order['jd']?.toString() ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']?.toString() ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order['status']?.toString() ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class ViewPackagePage extends StatefulWidget {
  const ViewPackagePage({super.key});

  @override
  State<ViewPackagePage> createState() => _ViewPackagePageState();
}

class _ViewPackagePageState extends State<ViewPackagePage> {
  int _rowsPerPage = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Packages',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(thickness: 1, color: Colors.black26),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Current Packages:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(thickness: 1, color: Colors.black26),
              Row(
                children: [
                  const SizedBox(width: 530),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // No border line
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: (_rowsPerPage * dataRowHeight) +
                      headerHeight +
                      paginationHeight,
                  child: PaginatedDataTable(
                    columnSpacing: 36,
                    dataRowMinHeight: 40,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Package Name')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Commission')),
                      DataColumn(label: Text('Selling Price')),
                    ],
                    source: TEViewPackageDataSource(viewpackages),
                    rowsPerPage: _rowsPerPage,
                    availableRowsPerPage: const [5, 10, 15, 20, 25],
                    onRowsPerPageChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rowsPerPage = value;
                        });
                      }
                    },
                    arrowHeadColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTAcustPage extends StatefulWidget {
  final bool isHidden;
  const AddTAcustPage({super.key, required this.isHidden});

  @override
  State<AddTAcustPage> createState() => _AddTAcustPageState();
}

class _AddTAcustPageState extends State<AddTAcustPage> {
  late bool isHidden;
  Map<String, String?> selectedFiles = {
    'Profile Picture': null,
    'Aadhar Card': null,
    'Pan Card': null,
    'Bank Passbook': null,
    'Voting Card': null,
  };

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  String _selectedCountryCode = '+91'; // Default country code

  Future<void> _pickFile(String fileType) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        setState(() {
          selectedFiles[fileType] = file.name; // 🔥 Save selected file name
        });

        Logger.info('Picked file for $fileType: ${file.name}');
      }
    } catch (e) {
      Logger.error('Error picking file: $e');
    }
  }

  void _removeFile(String fileType) {
    setState(() {
      selectedFiles[fileType] = null; // 🔥 Remove selected file
    });
  }

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
  void initState() {
    super.initState();
    isHidden = widget.isHidden; // Store isHidden in state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Visibility(
                    visible: !isHidden,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Customer Reference ID',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !isHidden, child: const SizedBox(height: 15)),
                  Visibility(
                    visible: !isHidden,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Customer Reference Name',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !isHidden, child: const SizedBox(height: 15)),
                  _buildTextField('TA Reference ID *'),
                  const SizedBox(height: 15),
                  _buildTextField('TA Reference Name *'),
                  const SizedBox(height: 15),
                  _buildTextField('First Name*'),
                  const SizedBox(height: 15),
                  _buildTextField('Last Name*'),
                  const SizedBox(height: 15),
                  _buildTextField('Nominee Name*'),
                  const SizedBox(height: 15),
                  _buildTextField('Nominee Relation*'),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        // Country code dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCountryCode = newValue!;
                              });
                            },
                            items: ['+91', '+1', '+44', '+61', '+971']
                                .map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  width:
                                      50, // Adjust this value to reduce the width of each item
                                  alignment: Alignment.center,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                              );
                            }).toList(),
                            dropdownColor:
                                const Color.fromARGB(255, 83, 83, 83),
                            underline:
                                const SizedBox(), // Hides the default underline
                          ),
                        ),
                        // Phone number text field
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            maxLength:
                                10, // Limit to typical phone number length
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
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
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Email *'),
                  const SizedBox(height: 15),
                  _buildDropdown('Gender *', ['Male', 'Female', 'Other']),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true, // Makes the TextFormField non-editable
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth *',
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
                  _buildDropdown('Country *', ['India', 'Pakistan', 'Other']),
                  const SizedBox(height: 10),
                  _buildDropdown('State *', ['Goa', 'Delhi', 'Other']),
                  const SizedBox(height: 10),
                  _buildDropdown('City *', ['Margao', 'Panjim', 'Other']),
                  const SizedBox(height: 10),
                  _buildTextField('Pincode *'),
                  const SizedBox(height: 15),
                  _buildTextField('Address *'),
                  const SizedBox(height: 20),
                  Text(
                    'Attachments',
                    style: Appwidget.normalSubTitle(),
                  ),
                  const SizedBox(height: 10),
                  _buildUploadButton('Profile Picture'),
                  _buildUploadButton('Aadhar Card'),
                  _buildUploadButton('Pan Card'),
                  _buildUploadButton('Bank Passbook'),
                  _buildUploadButton('Voting Card'),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String fileType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // 🔥 Add spacing
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _pickFile(fileType),
            icon: const Icon(Icons.upload_file),
            label: Text('Upload $fileType'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(
              width: 10), // 🔥 Ensure spacing between button & file name

          if (selectedFiles[fileType] !=
              null) // 🔥 Show file name & remove button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedFiles[fileType]!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis, // 🔥 Avoid overflow issues
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeFile(fileType), // 🔥 Remove file
                ),
              ],
            ),
        ],
      ),
    );
  }
}
