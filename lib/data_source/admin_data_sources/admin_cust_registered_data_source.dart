import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/customer/add_customer.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';

class MyAdminCustRegDataSource extends DataTableSource {
  final BuildContext context;
  final List<RegisteredCustomer> data;
  MyAdminCustRegDataSource(this.context, this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final customer = data[index];

    String getStatusText(dynamic status) {
      if (status == null) return 'Unknown';

      final String statusStr = status.toString();

      switch (statusStr) {
        case '1':
          return 'Completed';
        case '2':
          return 'Pending';
        case '0':
          return 'Cancelled';
        default:
          return 'Unknown';
      }
    }

    Color getStatusColor(String status) {
      switch (status) {
        case '1':
          return Colors.green;
        case '2':
          return Colors.orange;
        case '0':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String extractPathSegment(String fullPath, String folderPrefix) {
      final int index = fullPath.lastIndexOf(folderPrefix);
      if (index != -1) {
        return fullPath.substring(index);
      }
      return fullPath;
    }

    Widget getProfileImage(String? profilePicture) {
      if (profilePicture == null || profilePicture.isEmpty) {
        return Center(
          child: Container(
            width: 40,
            height: 40,
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

      Logger.success('Final image URL: $imageUrl');

      return Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Logger.error("Failed to load image: $error");S
              return Image.asset(
                'assets/default_profile.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    }

    final statusValue = customer.status.toString();
    final statusText = getStatusText(statusValue);
    final statusColor = getStatusColor(statusValue);

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              radius: 20,
              child: getProfileImage(customer.profilePicture),
            ),
          ),
        ),
        DataCell(Text(customer.caCustomerId.toString())),
        DataCell(Text(customer.name ?? 'N/A')),
        DataCell(Text(customer.taReferenceNo ?? 'N/A')),
        DataCell(Text(customer.taReferenceName ?? 'N/A')),
        DataCell(Text(customer.customerType ?? 'N/A')),
        DataCell(Text(customer.dob ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu(context, customer)),
      ],
    );
  }

// Action Menu Widget
  Widget _buildActionMenu(BuildContext context, RegisteredCustomer customer) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            title: Text('View'),
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading:
                const Icon(Icons.edit, color: Color.fromARGB(255, 0, 105, 190)),
            title: const Text('Edit'),
            onTap: () {
              Logger.success(customer.name!);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddcustPage(
                            registeredCustomer: customer,
                            isEditMode: true,
                          )));
            },
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        const PopupMenuItem(
          value: 'unregister',
          child: ListTile(
            leading: Icon(Icons.app_registration,
                color: Color.fromARGB(255, 0, 238, 127)),
            title: Text('Un-Register'),
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
