import 'package:bizzmirth_app/controllers/tc_controller/tc_customer_controller.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/models/tc_models/tc_customer/tc_registered_customer_model.dart';
import 'package:bizzmirth_app/screens/dashboards/travel_consultant/customers/add_customer_tc.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcRegisteredCustomerDataSource extends DataTableSource {
  final List<TcRegisteredCustomerModel> data;
  TcRegisteredCustomerDataSource({required this.data, required this.context});
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final regCus = data[index];
    final parts = (regCus.taReference ?? '').split(' ');

    Widget getProfileImage(String? profilePicture) {
      const double imageSize = 40;

      if (profilePicture == null || profilePicture.isEmpty) {
        return Center(
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: const BoxDecoration(shape: BoxShape.circle),
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
        DataCell(getProfileImage(regCus.profilePic)),
        DataCell(Text(regCus.caCustomerId ?? 'N/A')),
        DataCell(Text(regCus.name ?? 'N/A')),
        DataCell(Text(parts.isNotEmpty ? parts.first : 'N/A')), // TA Code
        DataCell(Text(parts.length > 1 ? parts.sublist(1).join(' ') : 'N/A')),
        DataCell(Text(formatDate(regCus.registerDate ?? ''))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getStatusColor(regCus.statusCode ?? ''),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              regCus.status!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu(regCus)),
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
  Widget _buildActionMenu(TcRegisteredCustomerModel customer) {
    return PopupMenuButton<String>(
      onSelected: (value) {
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
            // Handle edit action
            break;
          case 'delete':

            // controller.apiDeleteRegisteredCustomer(context, customer);
            break;
          case 'restore':
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) {
        if (customer.status == '3') {
          // Inactive - show only restore option
          return [
            PopupMenuItem(
              value: 'restore',
              child: ListTile(
                leading: const Icon(Icons.restore, color: Colors.green),
                title: const Text('Restore'),
                onTap: () {
                  final controller =
                      Provider.of<TcCustomerController>(context, listen: false);
                  Logger.success(
                      'data to be send ${customer.status} ${customer.firstname} ${customer.caCustomerId}');
                  Navigator.pop(context);
                  controller.apiRestoreRegisteredCustomer(context, customer);
                },
              ),
            ),
          ];
        } else if (customer.status == '1') {
          // Active - show all options
          return [
            const PopupMenuItem(
              value: 'add_ref',
              child: ListTile(
                leading: Icon(Icons.person_add_alt_1, color: Colors.blue),
                title: Text('Add Ref'),
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCustomerTc(
                        customer: customer,
                        isEditMode: true,
                      ),
                    ),
                  );
                  // Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  final controller =
                      Provider.of<TcCustomerController>(context, listen: false);
                  Navigator.pop(context);
                  Logger.warning(
                      'Deleting customer: ${customer.status} ${customer.id} ${customer.taReferenceName} ${customer.taReferenceNo} ${customer.caCustomerId}');
                  controller.apiDeleteRegisteredCustomer(context, customer);
                },
              ),
            ),
          ];
        } else {
          // Unknown status - no options
          return [];
        }
      },
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
