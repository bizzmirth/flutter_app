import 'package:provider/provider.dart';

import 'package:bizzmirth_app/services/api_service.dart';

// controllers
import 'package:bizzmirth_app/controllers/common_controllers/home_page_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/login_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/profile_controller.dart';
import 'package:bizzmirth_app/controllers/common_controllers/contact_us_controller.dart';

import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_wallet_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_order_history_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_product_payout_controller.dart';
import 'package:bizzmirth_app/controllers/customer_controller/cust_referral_payout_controller.dart';

import 'package:bizzmirth_app/controllers/admin_controller/admin_employee_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_busniess_mentor_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_designation_department_controller.dart';
import 'package:bizzmirth_app/controllers/admin_controller/admin_customer_controller.dart';

import 'package:bizzmirth_app/controllers/all_packages_controllers/tour_packages_controller.dart';
import 'package:bizzmirth_app/controllers/all_packages_controllers/package_details_controller.dart';

import 'package:bizzmirth_app/controllers/tc_controller/tc_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_customer_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_markup_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_cu_payout_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_topup_wallet_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_product_payout_controller.dart';
import 'package:bizzmirth_app/controllers/tc_controller/tc_order_history_controller.dart';

import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_customer_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_product_payouts_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_cu_payouts_controller.dart';
import 'package:bizzmirth_app/controllers/franchise_controller/franchisee_tc_recruitment_controller.dart';
import 'package:provider/single_child_widget.dart';

/// 👇 JUST EXPORT THIS
final List<SingleChildWidget> appProviders = [
  // --------------------
  // Core
  // --------------------
  Provider<ApiService>(
    create: (_) => ApiService(),
  ),

  // --------------------
  // Common
  // --------------------
  ChangeNotifierProvider(create: (_) => HomePageController()),
  ChangeNotifierProvider(create: (_) => LoginController()),
  ChangeNotifierProvider(create: (_) => ProfileController()),
  ChangeNotifierProvider(create: (_) => ContactUsController()),

  // --------------------
  // Customer
  // --------------------
  ChangeNotifierProvider(create: (_) => CustomerController()),
  ChangeNotifierProvider(create: (_) => CustWalletController()),
  ChangeNotifierProvider(create: (_) => CustOrderHistoryController()),
  ChangeNotifierProvider(create: (_) => CustProductPayoutController()),
  ChangeNotifierProvider(create: (_) => CustReferralPayoutController()),

  // --------------------
  // Admin
  // --------------------
  ChangeNotifierProvider(create: (_) => AdminEmployeeController()),
  ChangeNotifierProvider(create: (_) => AdminBusniessMentorController()),
  ChangeNotifierProvider(
      create: (_) => AdminDesignationDepartmentController()),
  ChangeNotifierProvider(create: (_) => AdminCustomerController()),

  // --------------------
  // Packages
  // --------------------
  ChangeNotifierProvider(create: (_) => TourPackagesController()),
  ChangeNotifierProvider(create: (_) => PackageDetailsController()),

  // --------------------
  // TC
  // --------------------
  ChangeNotifierProvider(create: (_) => TcController()),
  ChangeNotifierProvider(create: (_) => TcCustomerController()),
  ChangeNotifierProvider(create: (_) => TcMarkupController()),
  ChangeNotifierProvider(create: (_) => TcCuPayoutController()),
  ChangeNotifierProvider(create: (_) => TcTopupWalletController()),
  ChangeNotifierProvider(create: (_) => TcProductPayoutController()),
  ChangeNotifierProvider(create: (_) => TcOrderHistoryController()),

  // --------------------
  // Franchisee (depends on ApiService)
  // --------------------
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeController(apiService: context.read<ApiService>()),
  ),
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeTcController(apiService: context.read<ApiService>()),
  ),
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeCustomerController(apiService: context.read<ApiService>()),
  ),
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeProductPayoutsController(apiService: context.read<ApiService>()),
  ),
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeCuPayoutsController(apiService: context.read<ApiService>()),
  ),
  ChangeNotifierProvider(
    create: (context) =>
        FranchiseeTcRecruitmentController(apiService: context.read<ApiService>()),
  ),
];
