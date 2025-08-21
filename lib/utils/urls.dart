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
}
