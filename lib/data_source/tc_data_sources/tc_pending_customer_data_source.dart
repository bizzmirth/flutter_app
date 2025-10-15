import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_pending_customer_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TcPendingCustomerDataSource extends DataTableSource {
  final List<TcPendingCustomerModel> data;
  TcPendingCustomerDataSource({required this.data, required this.context});
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final pendingCus = data[index];
    final String fullName =
        '${pendingCus.firstname ?? ''} ${pendingCus.lastname ?? ''}';

    Widget getProfileImage(String? profilePicture) {
      const double imageSize = 40;

      if (profilePicture == null || profilePicture.isEmpty) {
        return Center(
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/default_profile.png', fit: BoxFit.cover),
          ),
        );
      }
      final String imageUrl;
      if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
        imageUrl = profilePicture;
      } else {
        final newPath = extractPathSegment(profilePicture, 'profile_pic/');
        imageUrl = 'https://testca.uniqbizz.com/uploading/$newPath';
      }

      // Logger.success('Final image URL: $imageUrl');
      return Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/default_profile.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return DataRow(
      cells: [
        DataCell(getProfileImage(pendingCus.profilePic)),
        DataCell(Text(pendingCus.id ?? 'N/A')),
        DataCell(Text(fullName)),
        DataCell(Text(pendingCus.referenceNo ?? 'N/A')),
        DataCell(Text(pendingCus.taReferenceName ?? 'N/A')),
        DataCell(Text(pendingCus.addedOn ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getStatusColor(pendingCus.status ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              getStatusText(pendingCus.status!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Active';
      case '3':
        return 'Inactive';
      default:
        return 'Pending';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '3':
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
