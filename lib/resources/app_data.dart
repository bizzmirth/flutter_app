class AppData {
  static const String customerUserType = '10';
  static const String tcUserType = '11';
  static const String franchiseeUserType = '29';
  static const List<String> paymentFeeOptions = [
    'Free',
    'Prime: ₹ 10,000',
    'Premium: ₹ 30,000',
    'Premium Plus: ₹ 35,000',
    'Premium Select: ₹ 35,000',
    'Premium Select Lite: ₹ 21,000',
    'Neo Select: ₹ 11,000',
  ];

  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  static const List<String> countryCodeOptions = [
    '+91',
    '+1',
    '+44',
    '+61',
    '+971'
  ];

  static const List<int> availableRowsPerPage = [5, 10, 15, 20, 25];

  static const List<String> travelTypes = ['ALL', 'International', 'Domestic'];

  static const List<String> orderHistoryFilterOptions = [
    'All',
    'Pending',
    'Booked',
    'Cancelled',
    'Refund'
  ];
}
