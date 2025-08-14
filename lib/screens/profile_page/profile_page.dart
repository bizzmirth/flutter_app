import 'package:bizzmirth_app/controllers/profile_controller.dart';
import 'package:bizzmirth_app/models/coupons_data_model.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPersonalDetails();
    });
  }

  void getPersonalDetails() async {
    final controller = Provider.of<ProfileController>(context, listen: false);
    controller.apiGetPersonalDetails();
    controller.getCouponDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CouponData> sampleCoupons = [
    CouponData(
      id: "94",
      userId: "CU250044",
      paymentId: "PAID20250620110449",
      code: "20250311BA7790E",
      couponAmt: "3000",
      usageStatus: "1",
      confirmStatus: "1",
      createdDate: "2025-06-20 16:34:49",
      usedDate: null,
      expiryDate: "2035-06-20 16:34:49",
    ),
    CouponData(
      id: "95",
      userId: "CU250045",
      paymentId: "PAID20250721125530",
      code: "20250412CD8891F",
      couponAmt: "1500",
      usageStatus: "0",
      confirmStatus: "1",
      createdDate: "2025-07-21 18:25:30",
      usedDate: "2025-07-25 14:20:15",
      expiryDate: "2025-12-21 18:25:30",
    ),
    CouponData(
      id: "96",
      userId: "CU250046",
      paymentId: "PAID20250815093025",
      code: "20250513EF9902G",
      couponAmt: "5000",
      usageStatus: "1",
      confirmStatus: "1",
      createdDate: "2025-08-15 14:50:25",
      usedDate: null,
      expiryDate: "2026-02-15 14:50:25",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileController>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: controller.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Sidebar
                    SizedBox(
                      width: isTablet
                          ? 180
                          : (isMobile ? screenWidth * 0.35 : 250),
                      child: _buildSidebar(isTablet, controller),
                    ),
                    SizedBox(width: isTablet ? 32 : 16),
                    // Main Content Area
                    Expanded(
                      child: _buildMainContent(isTablet, isMobile, controller),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSidebar(bool isTablet, ProfileController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey[400],
                      size: isTablet ? 20 : 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'user-profile',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey[400],
                      size: isTablet ? 20 : 18,
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 24 : 16),
                Text(
                  '${controller.firstName} ${controller.lastName}',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50), // circular image
                  child: controller.profilePic != null &&
                          controller.profilePic!.isNotEmpty
                      ? Image.network(
                          controller.profilePic!,
                          height: isTablet ? 80 : 60,
                          width: isTablet ? 80 : 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person,
                                size: isTablet ? 80 : 60, color: Colors.grey);
                          },
                        )
                      : Icon(Icons.person,
                          size: isTablet ? 80 : 60, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Profile Pic',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 24 : 16),
          // Document Cards
          _buildDocumentCard('Pan Card', controller.panCard, isTablet),
          SizedBox(height: isTablet ? 16 : 12),
          _buildDocumentCard('Pass Book', controller.bankPassbook, isTablet),
          SizedBox(height: isTablet ? 16 : 12),
          _buildDocumentCard('Aadhar Card', controller.aadharCard, isTablet),
          SizedBox(height: isTablet ? 16 : 12),
          _buildDocumentCard('Voting Card', controller.votingCard, isTablet),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    String title,
    String? documentUrl,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: isTablet ? 120 : 80,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: documentUrl != null && documentUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      documentUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_outlined,
                        color: Colors.grey[400],
                        size: isTablet ? 24 : 20,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Photo\nNot Yet\nUploaded',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: isTablet ? 12 : 10,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey[400],
                        size: isTablet ? 20 : 18,
                      ),
                    ],
                  ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      bool isTablet, bool isMobile, ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue[600],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue[600],
              indicatorWeight: 3,
              labelStyle: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(
                  icon: Icon(Icons.home_outlined),
                  text: 'Personal Details',
                ),
                Tab(
                  icon: Icon(Icons.local_offer_outlined),
                  text: 'Coupons',
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalDetailsTab(isTablet, isMobile, controller),
                _buildCouponsTab(isTablet, controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsTab(
      bool isTablet, bool isMobile, ProfileController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          // Personal Information Form
          _buildFormSection(isTablet, isMobile, controller),
        ],
      ),
    );
  }

  Widget _buildFormSection(
      bool isTablet, bool isMobile, ProfileController controller) {
    return Column(
      children: [
        if (controller.compCheck == "1")
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "Complimentary Membership",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        // Name Fields
        isMobile
            ? Column(
                children: [
                  _buildFormField(
                      'First Name', controller.firstName!, isTablet),
                  SizedBox(height: 16),
                  _buildFormField('Last Name', controller.lastName!, isTablet),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                        'First Name', controller.firstName!, isTablet),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                        'Last Name', controller.lastName!, isTablet),
                  ),
                ],
              ),
        SizedBox(height: 20),
        // Contact Fields
        isMobile
            ? Column(
                children: [
                  _buildFormField('Phone Number', controller.phone!, isTablet),
                  SizedBox(height: 16),
                  _buildFormField('Email Address', controller.email!, isTablet),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                        'Phone Number', controller.phone!, isTablet),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                        'Email Address', controller.email!, isTablet),
                  ),
                ],
              ),
        SizedBox(height: 20),
        // Gender and DOB
        isMobile
            ? Column(
                children: [
                  _buildGenderSection(isTablet, controller),
                  SizedBox(height: 16),
                  _buildFormField(
                      'Date of Birth', formatDate(controller.dob), isTablet,
                      isDate: true),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildGenderSection(isTablet, controller)),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                        'Date of Birth', controller.dob!, isTablet,
                        isDate: true),
                  ),
                ],
              ),
        SizedBox(height: 20),
        // Location Fields
        isMobile
            ? Column(
                children: [
                  _buildDropdownField('Country', controller.country!, isTablet),
                  SizedBox(height: 16),
                  _buildDropdownField('State', controller.state!, isTablet),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                        'Country', controller.country!, isTablet),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildDropdownField(
                        'State', controller.state!, isTablet),
                  ),
                ],
              ),
        SizedBox(height: 20),
        // City and Zip
        isMobile
            ? Column(
                children: [
                  _buildDropdownField('City', controller.city!, isTablet),
                  SizedBox(height: 16),
                  _buildFormField('Zip Code', '403 ', isTablet),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child:
                        _buildDropdownField('City', controller.city!, isTablet),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildFormField(
                        'Zip Code', controller.zipCode!, isTablet),
                  ),
                ],
              ),
        SizedBox(height: 20),
        // Full Address
        _buildFormField('Full Address', controller.fullAddress!, isTablet,
            maxLines: 3),
      ],
    );
  }

  Widget _buildFormField(String label, String value, bool isTablet,
      {bool isDate = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.black87,
                  ),
                  maxLines: maxLines,
                ),
              ),
              if (isDate)
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[400],
                  size: isTablet ? 20 : 18,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[400],
                size: isTablet ? 24 : 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSection(bool isTablet, ProfileController controller) {
    final selectedGender = controller.gender?.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: isTablet ? 24 : 16,
          runSpacing: 8,
          children: [
            _buildRadioOption('Male', selectedGender == 'male', isTablet),
            _buildRadioOption('Female', selectedGender == 'female', isTablet),
            _buildRadioOption('Others', selectedGender == 'others', isTablet),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, bool isSelected, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: true,
          groupValue: isSelected,
          onChanged: (value) {},
          activeColor: Colors.blue[600],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponsTab(bool isTablet, ProfileController controller) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Coupons (${controller.couponsData.length})',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),

          // Unified horizontal scroll for header and data
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Coupon Code',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Created Date',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Expiry Date',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: isTablet ? 12 : 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.sort,
                                color: Colors.grey[400],
                                size: isTablet ? 14 : 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Coupon list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: controller.couponsData
                            .map((coupon) => _buildCouponRow(coupon, isTablet))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponRow(CouponData coupon, bool isTablet) {
    String formatDate(String dateString) {
      try {
        DateTime date = DateTime.parse(dateString);
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (e) {
        return dateString;
      }
    }

    String getStatus() {
      if (coupon.usageStatus == "1") return "Used";

      DateTime expiryDate = DateTime.parse(coupon.expiryDate);
      DateTime now = DateTime.now();

      if (expiryDate.isBefore(now)) return "Expired";
      return "Unused";
    }

    Color getStatusColor() {
      String status = getStatus();
      switch (status) {
        case "Unused":
          return Colors.green;
        case "Expired":
          return Colors.orange;
        case "Used":
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: isTablet ? 16 : 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  coupon.code,
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 9,
                    color: Colors.grey[800],
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: Text(
                  '₹${coupon.couponAmt}',
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 9,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: Text(
                  formatDate(coupon.createdDate),
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 9,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: Text(
                  formatDate(coupon.expiryDate),
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 9,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 70,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    getStatus(),
                    style: TextStyle(
                      fontSize: isTablet ? 10 : 8,
                      color: getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
