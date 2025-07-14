import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyrefCustRegDataSource extends DataTableSource {
  final List<RegisteredCustomer> data;
  MyrefCustRegDataSource(this.data, this.context);
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final regCustomer = data[index];

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

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              child: getProfileImage(regCustomer.profilePicture),
            ),
          ),
        ),
        DataCell(Text(regCustomer.id.toString())),
        DataCell(Text(regCustomer.name ?? "N/A")),
        DataCell(Text(regCustomer.taReferenceNo ?? "N/A")),
        DataCell(Text(regCustomer.taReferenceName ?? "N/A")),
        DataCell(Text(regCustomer.registerDate ?? "N/A")),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(regCustomer.status!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStatusColor(regCustomer.status!).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getStatusText(regCustomer.status!),
              style: TextStyle(
                color: _getStatusColor(regCustomer.status!),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(_buildActionMenu()),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
        switch (value) {
          case "add_ref":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTAcustPage(isHidden: false),
              ),
            );
            break;
          case "edit":
            break;
          case "delete":
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "add_ref",
          child: ListTile(
            leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
            title: Text("Add Ref"),
          ),
        ),
        PopupMenuItem(
          value: "edit",
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text("Edit"),
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete"),
          ),
        ),
      ],
      icon: Icon(Icons.more_vert, color: Colors.black54),
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
