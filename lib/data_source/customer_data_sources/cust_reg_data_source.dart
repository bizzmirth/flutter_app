import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyrefCustRegDataSource extends DataTableSource {
  final List<RegisteredCustomer> data;
  final BuildContext context;
  final VoidCallback? onDataChanged; // Add callback for data changes

  MyrefCustRegDataSource(this.data, this.context, {this.onDataChanged});

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
          return 'Unknown';
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

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              child: getProfileImage(regCustomer.profilePicture),
            ),
          ),
        ),
        DataCell(Text(regCustomer.caCustomerId!)),
        DataCell(Text(regCustomer.name ?? 'N/A')),
        DataCell(Text(regCustomer.taReferenceNo ?? 'N/A')),
        DataCell(Text(regCustomer.taReferenceName ?? 'N/A')),
        DataCell(Text(regCustomer.registerDate ?? 'N/A')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(regCustomer.status!).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    getStatusColor(regCustomer.status!).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              getStatusText(regCustomer.status!),
              style: TextStyle(
                color: getStatusColor(regCustomer.status!),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(_buildActionMenu(context, regCustomer)),
      ],
    );
  }

  // Action Menu Widget
  Widget _buildActionMenu(
      BuildContext context, RegisteredCustomer regCustomer) {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    return Consumer<CustomerController>(builder: (context, controller, child) {
      return PopupMenuButton<String>(
        onSelected: (value) async {
          // Handle menu actions
          switch (value) {
            case 'add_ref':
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTAcustPage(isHidden: false),
                ),
              );
              if (result == true) {
                await _refreshData();
              }
              break;
            case 'edit':
              // This case is handled by onTap in PopupMenuItem
              break;
            case 'delete':
              // This case is handled by onTap in PopupMenuItem
              break;
            case 'restore':
              await customerController.apiRestoreCustomer(context, regCustomer);
              await _refreshData();
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) {
          final List<PopupMenuEntry<String>> menuItems = [];

          if (regCustomer.status == '1') {
            menuItems.addAll([
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blueAccent),
                  title: const Text('Edit'),
                  onTap: () async {
                    // Close the popup menu first
                    Navigator.pop(context);

                    // Navigate to edit page and wait for result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReferralCustomer(
                          registeredCustomer: regCustomer,
                          isEditMode: true,
                        ),
                      ),
                    );

                    if (result == true) {
                      await _refreshData();
                    }
                  },
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete'),
                  onTap: () async {
                    Navigator.pop(context);
                    await customerController.apiDeleteCustomer(
                        context, regCustomer);
                    await _refreshData();
                  },
                ),
              ),
            ]);
          } else if (regCustomer.status == '3') {
            menuItems.add(
              PopupMenuItem(
                value: 'restore',
                child: ListTile(
                  leading: const Icon(Icons.restore, color: Colors.green),
                  title: const Text('Restore'),
                  onTap: () async {
                    Navigator.pop(context);
                    await customerController.apiRestoreCustomer(
                        context, regCustomer);
                    await _refreshData();
                  },
                ),
              ),
            );
          }

          return menuItems;
        },
        icon: const Icon(Icons.more_vert, color: Colors.black54),
      );
    });
  }

  Future<void> _refreshData() async {
    try {
      final customerController = context.read<CustomerController>();

      await Future.wait([
        customerController.apiGetRegisteredCustomers(),
        customerController.apiGetPendingCustomers(),
      ]);

      onDataChanged?.call();
      notifyListeners();
    } catch (e) {
      Logger.error('Error refreshing data: $e');
    }
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
