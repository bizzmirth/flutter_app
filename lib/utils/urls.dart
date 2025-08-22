enum Environment { testing, live }

class AppUrls {
//  Change this to switch environments
  static const Environment _currentEnvironment = Environment.testing;

  static const Map<Environment, String> _baseUrls = {
    Environment.testing: "https://testca.uniqbizz.com/api",
    Environment.live: "https://ca.uniqbizz.com/api"
  };

  static String get baseUrl => _baseUrls[_currentEnvironment]!;

  // ==================== AUTHENTICATION ENDPOINTS ====================
  static String get login => "$baseUrl/login.php";
  static String get getAllUserTypes => "$baseUrl/user_type";

  // ==================== PROFILE PAGE ENDPOINTS ====================
  static String get getPersonalDetails => "$baseUrl/customers/profile_page.php";

  // ==================== CONTACT US ENDPOINTS ====================
  static String get contactUs => "$baseUrl/contact_us.php";

  // ==================== CUSTOMER DASHBOARD ENDPOINTS ====================
  static String get registeredCustomers =>
      "$baseUrl/customers/customers.php?action=registered_cust"; // to get the registered customers
  static String get pendingCustomers =>
      "$baseUrl/customers/customers.php?action=pending_cust";
  static String get dashboardCounts =>
      "$baseUrl/customers/dashboard_counts.php";
  static String get dashboardChartsData => "$baseUrl/dashboard/chartData.php";
  static String get topCustomerReferrals =>
      "$baseUrl/dashboard/top_customer_refereral.php";
  static String get uploadImage => "$baseUrl/upload_mobile.php";
  static String get addCustomer => "$baseUrl/customers/add_customers_data.php";
  static String get editCustomers =>
      "$baseUrl/customers/edit_customers_data.php";
  static String get deleteCustomers =>
      "$baseUrl/customers/delete_customers_data.php";

  // ==================== CUSTOMER PRODUCT PAYOUTS ENDPOINTS ====================
  static String get getAllPayoutsProduct =>
      "$baseUrl/payouts/product_payouts/customer_all_payouts.php";

  static String get getPayoutsProduct =>
      "$baseUrl/payouts/product_payouts/customer_payouts.php"; // this is used to call all previous,next and all

  // ==================== CUSTOMER REFERRAL PAYOUTS ENDPOINTS ====================

  static String get getAllPayoutsReference =>
      "$baseUrl/payouts/reference_payouts/customer_all_payouts.php";

  static String get getPreviousPayoutsReference =>
      "$baseUrl/payouts/reference_payouts/customer_prev_payouts.php";

  static String get getNextPayoutReference =>
      "$baseUrl/payouts/reference_payouts/customer_next_payouts.php";

  static String get getTotalPayoutsReference =>
      "$baseUrl/payouts/reference_payouts/customer_total_payouts.php";
}
