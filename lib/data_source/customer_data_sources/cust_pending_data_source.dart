import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyrefCustPendingDataSource extends DataTableSource {
  final List<PendingCustomer> data;
  MyrefCustPendingDataSource(this.data, this.context);
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final pendingCustomer = data[index];
    final parts = (pendingCustomer.taReference ?? '').split(' ');

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
            child: Image.asset(
              'assets/default_profile.png',
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
        imageUrl = 'https://testca.uniqbizz.com/uploading/$newpath';
      }

      // Logger.success('Final image URL: $imageUrl');

      return Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: const BoxDecoration(
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
              'assets/default_profile.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
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
          return Colors.orange.shade800;
      }
    }

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              child: getProfileImage(pendingCustomer.profilePicture),
            ),
          ),
        ),
        DataCell(Text(pendingCustomer.id.toString())),
        DataCell(Text(pendingCustomer.name ?? 'N/A')),
        DataCell(Text(parts.isNotEmpty ? parts[0] : 'N/A')),
        DataCell(Text(parts.length > 1 ? parts.sublist(1).join(' ') : 'N/A')),
        DataCell(Text(pendingCustomer.registerDate ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(pendingCustomer.status!)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: getStatusColor(pendingCustomer.status!)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              getStatusText(pendingCustomer.status!),
              style: TextStyle(
                color: getStatusColor(pendingCustomer.status!),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        // DataCell(_buildActionMenu(context, pendingCustomer)),
      ],
    );
  }

// Action Menu Widget
  // Widget _buildActionMenu(context, PendingCustomer pendingCustomer) {
  //   return PopupMenuButton<String>(
  //     onSelected: (value) {
  //       // Handle menu actions
  //       switch (value) {
  //         case "add_ref":
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => AddTAcustPage(isHidden: false),
  //             ),
  //           );
  //           break;
  //         case "edit":
  //           break;
  //         case "delete":
  //           break;
  //         default:
  //           break;
  //       }
  //     },
  //     itemBuilder: (BuildContext context) => [
  //       PopupMenuItem(
  //         value: "add_ref",
  //         child: ListTile(
  //           leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
  //           title: Text("Add Ref"),
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: "edit",
  //         child: ListTile(
  //           leading: Icon(Icons.edit, color: Colors.blueAccent),
  //           title: Text("Edit"),
  //           onTap: () {
  //             Logger.success(pendingCustomer.name!);
  //             Navigator.pop(context);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => AddReferralCustomer(
  //                           pendingCustomer: pendingCustomer,
  //                           isEditMode: true,
  //                         )));
  //           },
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: "delete",
  //         child: ListTile(
  //           leading: Icon(Icons.delete, color: Colors.red),
  //           title: Text("Delete"),
  //         ),
  //       ),
  //     ],
  //     icon: Icon(Icons.more_vert, color: Colors.black54),
  //   );
  // }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
