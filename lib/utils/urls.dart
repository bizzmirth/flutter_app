enum Environment { testing, live }

class AppUrls {
  static const Environment _currentEnvironment = Environment.testing;

  static const Map<Environment, String> _baseUrls = {
    Environment.testing: 'https://testca.uniqbizz.com/bizzmirth_apis',
    Environment.live: 'https://ca.uniqbizz.com/bizzmirth_apis'
  };

  static String get baseUrl => _baseUrls[_currentEnvironment]!;

  // Base paths
  static String get _homepage => '$baseUrl/homepage';
  static String get _users => '$baseUrl/users';
  static String get _customers => '$_users/customers';
  static String get _travelConsultant => '$_users/travel_consultant';

  // ==================== HOMEPAGE TOUR PACKAGE DETAILS ====================
  static String get getTourPackages =>
      '$_homepage/packages/best_destinations.php';

  static String get getFilteredTourPackages =>
      '$_homepage/packages/filtered_package.php';

  static String get getBestDeals => '$_homepage/packages/best_deals.php';

  static String get getTourPackageDetails =>
      '$_homepage/packages/view_package_details/package_details.php';

  // ==================== BASE URL TO GET IMAGES ====================
  static String get getImageBaseUrl => 'https://testca.uniqbizz.com/';

  // ==================== AUTHENTICATION ENDPOINTS ====================
  static String get login => '$baseUrl/login/login.php';
  static String get getAllUserTypes => '$_homepage/user_type.php';

  // ==================== CONTACT US ENDPOINTS ====================
  static String get contactUs => '$baseUrl/contact_us.php';

  // ==================== CUSTOMER PROFILE PAGE ENDPOINTS ====================
  static String get getPersonalDetails => '$baseUrl/profile.php';

  static String get getCouponDetails =>
      '$_customers/profile_page/coupons/coupons.php';

  // ==================== CUSTOMER DASHBOARD ENDPOINTS ====================
  static String get registeredCustomers =>
      '$_customers/referral_customers/customers.php?action=registered_cust';

  static String get pendingCustomers =>
      '$_customers/referral_customers/customers.php?action=pending_cust';

  static String get dashboardCounts =>
      '$_customers/dashboard/dashboard_counts.php';

  static String get dashboardChartsData =>
      '$_customers/dashboard/chartData.php';

  static String get topCustomerReferrals =>
      '$_customers/dashboard/top_customer_refereral.php';

  static String get uploadImage => '$baseUrl/uploading/upload_mobile.php';

  static String get addCustomer =>
      '$_customers/referral_customers/add_customers.php';

  static String get validateEmail => '$_customers/dashboard/valid_email.php';

  static String get editCustomers =>
      '$_customers/referral_customers/edit_customers.php';

  static String get deleteCustomers =>
      '$_customers/referral_customers/delete_customers.php';

  // ==================== CUSTOMER WALLET ENDPOINTS ====================
  static String get getWalletDetails => '$_customers/wallets/wallets_api.php';

  // ==================== CUSTOMER PRODUCT PAYOUTS ENDPOINTS ====================
  static String get getAllPayoutsProduct =>
      '$_customers/payouts/product_payouts/customer_all_payouts.php';

  static String get getTotalPayoutsProduct =>
      '$_customers/payouts/product_payouts/customer_total_payout.php';

  static String get getPayoutsProduct =>
      '$_customers/payouts/product_payouts/customer_payouts.php';

  // ==================== CUSTOMER REFERRAL PAYOUTS ENDPOINTS ====================
  static String get getAllPayoutsReference =>
      '$_customers/payouts/reference_payouts/customer_all_payouts.php';

  static String get getPreviousPayoutsReference =>
      '$_customers/payouts/reference_payouts/customer_prev_payouts.php';

  static String get getNextPayoutReference =>
      '$_customers/payouts/reference_payouts/customer_next_payouts.php';

  static String get getTotalPayoutsReference =>
      '$_customers/payouts/reference_payouts/customer_total_payouts.php';

  // ==================== CUSTOMER ORDER HISTORY ENDPOINTS ====================
  static String get getOrderHistoryStatCounts =>
      '$_customers/orders/get_counts.php';

  static String get getRecentBookings => '$_customers/orders/fetch_events.php';

  static String get getAllTableData => '$_customers/orders/all_table_data.php';

  static String get getPendingTableData =>
      '$_customers/orders/pending_table_data.php';

  static String get getBookedTableData =>
      '$_customers/orders/booked_table_data.php';

  static String get getCancelledTableData =>
      '$_customers/orders/cancelled_table_data.php';

  static String get getRefundTableData =>
      '$_customers/orders/refunded_table_data.php';

  // ==================== TRAVEL CONSULTANT DASHBOARD ENDPOINTS ====================
  static String get getTravelConsultantDashboardCounts =>
      '$_travelConsultant/dashboard/dashboard_count.php';

  static String get getTravelConsultantLineChartData =>
      '$_travelConsultant/dashboard/line_chart.php';

  static String get getTravelConsultantTopReferralCustomers =>
      '$_travelConsultant/dashboard/top_referrals.php';

  static String get getTravelConsultantCurrentBookings =>
      '$_travelConsultant/dashboard/top_bookings.php';

  // ==================== TRAVEL CONSULTANT CUSTOMER ENDPOINTS ====================
  static String get getTcPendingCustomers =>
      '$_travelConsultant/referral_customers/customers.php?action=pending_cust';

  static String get getTcRegisteredCustomers =>
      '$_travelConsultant/referral_customers/customers.php?action=registered_cust';

  static String get addTcCustomer =>
      '$_travelConsultant/referral_customers/add_customers.php';

  static String get deleteTcCustomer =>
      '$_travelConsultant/referral_customers/delete_customers.php';

  static String get updateTcCustomer =>
      '$_travelConsultant/referral_customers/edit_customers.php';

  // ==================== TRAVEL CONSULTANT MARKUP ENDPOINTS ====================
  static String get getTcMarkupDetails =>
      '$_travelConsultant/markup/markup.php';

  static String get getTcUpdateMarkup =>
      '$_travelConsultant/markup/update_markup.php';

  // ==================== TRAVEL CONSULTANT PRODUCT PAYOUT ENDPOINTS ====================
  static String get getTcProductAllPayouts =>
      '$_travelConsultant/payouts/product_payout/travel_consultant_all_payouts.php';

  static String get getTcProductPayouts =>
      '$_travelConsultant/payouts/product_payout/travel_consultant_payouts.php';

  static String get getTcTotalProductPayouts =>
      '$_travelConsultant/payouts/product_payout/travel_consultant_total_payouts.php';

  // ==================== TRAVEL CONSULTANT CU MEMBERSHIP PAYOUT ENDPOINTS ====================
  static String get getTcCuAllPayouts =>
      '$_travelConsultant/payouts/cu_membership_payout/travel_consultant_all_payouts.php';

  static String get getTcCuNextPayouts =>
      '$_travelConsultant/payouts/cu_membership_payout/travel_consultant_next_payouts.php';

  static String get getTcCuTotalPayouts =>
      '$_travelConsultant/payouts/cu_membership_payout/travel_consultant_total_payouts.php';

  static String get getTcCuPreviousPayouts =>
      '$_travelConsultant/payouts/cu_membership_payout/travel_consultant_previous_payouts.php';

  // ==================== TRAVEL CONSULTANT TOPUP WALLET ENDPOINTS ====================

  static String get getTcTopupWalletDetails =>
      '$_travelConsultant/wallets/tc_wallet_balance.php';

  static String get addTcTopupWalletAmount =>
      '$_travelConsultant/wallets/add_tc_topup.php';

  static String get getTcTopupRequestList =>
      '$_travelConsultant/wallets/tc_request_list.php';

  // ==================== TRAVEL CONSULTANT ORDER HISTORY ENDPOINTS ====================
  static String get getTcOrderHistoryStatCount =>
      '$_travelConsultant/orders/get_counts.php';

  static String get getTcRecentBookings =>
      '$_travelConsultant/orders/fetch_events.php';

  static String get getTcAllTableData =>
      '$_travelConsultant/orders/all_table_data.php';

  static String get getTcPendingTableData =>
      '$_travelConsultant/orders/pending_table_data.php';

  static String get getTcBookingTableData =>
      '$_travelConsultant/orders/booked_table_data.php';

  static String get getTcCancelledTableData =>
      '$_travelConsultant/orders/cancelled_table_data.php';

  static String get getTcRefundTableData =>
      '$_travelConsultant/orders/refunded_table_data.php';
}
