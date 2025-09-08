import 'package:bizzmirth_app/controllers/common_controllers/profile_controller.dart';
import 'package:bizzmirth_app/models/coupons_data_model.dart';
import 'package:bizzmirth_app/services/shared_pref.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
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
  String custtype = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPersonalDetails();
    });

    // Run async work separately
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await getCustomerType();
      final profileController = context.read<ProfileController>();

      if (profileController.customerType != null &&
          profileController.customerType!.isNotEmpty) {
        // Use the fresh customer_type from API instead of SharedPreferences
        custtype = profileController.customerType!;
        // Save it to SharedPreferences for future use
        await SharedPrefHelper().saveCustomerType(custtype);
        Logger.success("Using customer_type from API: $custtype");
      }
    } catch (e) {
      Logger.error('Error initializing dashboard: $e');
    }
  }

  Future<void> getCustomerType() async {
    try {
      custtype = await SharedPrefHelper().getCustomerType() ?? '';
      Logger.success("customer type: $custtype");
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Logger.error('Error getting customer type: $e');
    }
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
    final isMobile = !isTablet;

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
                padding: EdgeInsets.all(isTablet ? 24.0 : 12.0),
                child: isTablet
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Sidebar (Tablet only)
                          SizedBox(
                            width: 180,
                            child: _buildSidebar(isTablet, controller),
                          ),
                          SizedBox(width: 32),
                          // Main Content Area (Tablet only)
                          Expanded(
                            child: _buildMainContent(
                                isTablet, isMobile, controller),
                          ),
                        ],
                      )
                    : Column(
                        // Mobile layout - single column
                        children: [
                          // Profile Section (Mobile)
                          _buildMobileProfileSection(controller),
                          SizedBox(height: 16),
                          // Document Cards (Mobile - horizontal scroll)
                          _buildMobileDocumentsSection(controller),
                          SizedBox(height: 16),
                          // Main Content (Mobile)
                          Expanded(
                            child: _buildMainContent(
                                isTablet, isMobile, controller),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }

  Widget _buildMobileProfileSection(ProfileController controller) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: controller.profilePic != null &&
                    controller.profilePic!.isNotEmpty
                ? Image.network(
                    controller.profilePic!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 60, color: Colors.grey);
                    },
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://testca.uniqbizz.com/uploading/not_uploaded.png",
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.firstName} ${controller.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  controller.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  controller.phone ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.grey[400]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDocumentsSection(ProfileController controller) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 8),
          _buildDocumentCard('Pan Card', controller.panCard, false,
              isMobile: true),
          SizedBox(width: 12),
          _buildDocumentCard('Pass Book', controller.bankPassbook, false,
              isMobile: true),
          SizedBox(width: 12),
          _buildDocumentCard('Aadhar Card', controller.aadharCard, false,
              isMobile: true),
          SizedBox(width: 12),
          _buildDocumentCard('Voting Card', controller.votingCard, false,
              isMobile: true),
          SizedBox(width: 8),
        ],
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
                SizedBox(height: isTablet ? 16 : 16),
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
                            return Image.network(
                              "https://testca.uniqbizz.com/uploading/not_uploaded.png",
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://testca.uniqbizz.com/uploading/not_uploaded.png",
                            fit: BoxFit.cover,
                          ),
                        ),
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
    bool isTablet, {
    bool isMobile = false,
  }) {
    final cardWidth = isMobile ? 120.0 : (isTablet ? double.infinity : 150.0);

    return Container(
      width: isMobile ? cardWidth : null,
      padding: EdgeInsets.all(isTablet ? 20 : 12),
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
            width: isMobile ? double.infinity : null,
            height: isTablet ? 120 : (isMobile ? 80 : 70),
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
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://testca.uniqbizz.com/uploading/not_uploaded.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://testca.uniqbizz.com/uploading/not_uploaded.png",
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(height: isTablet ? 16 : 8),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 16 : (isMobile ? 12 : 14),
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
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
            padding: EdgeInsets.all(isTablet ? 20 : 12),
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
                  icon: Icon(Icons.home_outlined, size: isTablet ? 24 : 20),
                  text: isTablet ? 'Personal Details' : 'Personal',
                ),
                Tab(
                  icon: Icon(Icons.local_offer_outlined,
                      size: isTablet ? 24 : 20),
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
        Column(
          children: [
            _buildFormField('First Name', controller.firstName ?? "", isTablet),
            SizedBox(height: 16),
            _buildFormField('Last Name', controller.lastName ?? "", isTablet),
          ],
        ),
        SizedBox(height: 20),
        // Contact Fields
        Column(
          children: [
            _buildFormField('Phone Number', controller.phone ?? "", isTablet),
            SizedBox(height: 16),
            _buildFormField('Email Address', controller.email ?? "", isTablet),
          ],
        ),
        SizedBox(height: 20),
        // Gender and DOB
        Column(
          children: [
            _buildGenderSection(isTablet, controller),
            SizedBox(height: 16),
            _buildFormField(
                'Date of Birth', formatDate(controller.dob), isTablet,
                isDate: true),
          ],
        ),
        SizedBox(height: 20),
        // Location Fields
        Column(
          children: [
            _buildDropdownField('Country', controller.country ?? "", isTablet),
            SizedBox(height: 16),
            _buildDropdownField('State', controller.state ?? "", isTablet),
          ],
        ),
        SizedBox(height: 20),
        // City and Zip
        Column(
          children: [
            _buildDropdownField('City', controller.city ?? "", isTablet),
            SizedBox(height: 16),
            _buildFormField('Zip Code', controller.zipCode ?? '', isTablet),
          ],
        ),
        SizedBox(height: 20),
        // Full Address
        _buildFormField('Full Address', controller.fullAddress ?? '', isTablet,
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
          spacing: isTablet ? 24 : 12,
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
      padding: EdgeInsets.all(isTablet ? 24 : 12),
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
          SizedBox(height: isTablet ? 32 : 16),

          // Coupon list with horizontal scrolling
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: isTablet ? 20 : 12,
                  horizontalMargin: isTablet ? 24 : 12,
                  headingRowHeight: isTablet ? 48 : 40,
                  dataRowHeight: isTablet ? 48 : 40,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Coupon Code',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Coupon',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Created Date',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Expiry Date',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  rows: controller.couponsData.map((coupon) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          coupon.code,
                          style: TextStyle(fontSize: isTablet ? 14 : 12),
                        )),
                        DataCell(Text(
                          custtype,
                          style: TextStyle(fontSize: isTablet ? 14 : 12),
                        )),
                        DataCell(Text(
                          '₹${coupon.couponAmt}',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                        DataCell(Text(
                          _formatDate(coupon.createdDate),
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey[600],
                          ),
                        )),
                        DataCell(Text(
                          _formatDate(coupon.expiryDate),
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey[600],
                          ),
                        )),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(coupon).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getStatus(coupon),
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                color: _getStatusColor(coupon),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getStatus(CouponData coupon) {
    if (coupon.usageStatus == "1") return "Used";

    DateTime expiryDate = DateTime.parse(coupon.expiryDate);
    DateTime now = DateTime.now();

    if (expiryDate.isBefore(now)) return "Expired";
    return "Unused";
  }

  Color _getStatusColor(CouponData coupon) {
    String status = _getStatus(coupon);
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
}
