import 'package:bizzmirth_app/entities/top_customer_refereral/top_customer_refereral_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustTopReferralCustomers extends DataTableSource {
  final List<TopCustomerRefereralModel> customers;

  CustTopReferralCustomers({required this.customers});

  @override
  DataRow? getRow(int index) {
    if (index >= customers.length) return null;
    final customer = customers[index];

    Widget getProfileImage(String? profilePicture) {
      const double imageSize = 40;

      if (profilePicture == null || profilePicture.isEmpty) {
        return Center(
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              "assets/default_profile.png",
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      final String imageUrl;
      if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
        imageUrl = profilePicture;
      } else {
        final newpath = extractPathSegment(profilePicture, 'profile_pic/');
        imageUrl = "https://testca.uniqbizz.com/uploading/$newpath";
      }

      Logger.success("Final image URL: $imageUrl");

      return Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/default_profile.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return DataRow(cells: [
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (index + 1) <= 3
                ? Colors.amber.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: (index + 1) <= 3 ? Colors.amber[800] : Colors.grey[700],
            ),
          ),
        ),
      ),

      // Profile Picture
      DataCell(Center(
        child: CircleAvatar(
          radius: 20,
          child: getProfileImage(customer.profilePic),
        ),
      )),

      // Full Name
      DataCell(
        Text(
          customer.name ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),

      // Joining Date
      DataCell(
        Text(
          customer.registeredDate ?? 'N/A',
          style: TextStyle(fontSize: 13),
        ),
      ),

      // Count
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${customer.totalReferals ?? 0}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
      ),

      // Status
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(customer.status!).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(customer.status!).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            _getStatusText(customer.status!),
            style: TextStyle(
              color: _getStatusColor(customer.status!),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),

      // Is Active
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${customer.activeReferrals}",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: " / ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: "${customer.inActiveReferrals ?? 0}",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  String _getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Active';
      case '3':
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

// Helper method to get status color from numeric value
  Color _getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  int get rowCount => customers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
