import 'package:bizzmirth_app/controllers/customer_controller/customer_controller.dart';
import 'package:bizzmirth_app/entities/pending_customer/pending_customer_model.dart';
import 'package:bizzmirth_app/entities/registered_customer/registered_customer_model.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/customer.dart';
import 'package:bizzmirth_app/screens/dashboards/customer/referral_customers/add_referral_customer.dart';
import 'package:bizzmirth_app/services/my_navigator.dart';
import 'package:bizzmirth_app/utils/constants.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:bizzmirth_app/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MobileViewReferralCustomer extends StatefulWidget {
  const MobileViewReferralCustomer({super.key});

  @override
  State<MobileViewReferralCustomer> createState() =>
      _MobileViewReferralCustomerState();
}

class _MobileViewReferralCustomerState
    extends State<MobileViewReferralCustomer> {
  bool showLoader = true;

  TextEditingController searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? fromDateError;
  String? toDateError;

  // Change to proper type
  List<RegisteredCustomer> filteredCustomers = [];
  List<PendingCustomer> filteredPendingCustomers = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showLoader = false;
        });
      }
    });

    searchController.addListener(_applyFilters);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerController = context.read<CustomerController>();
      customerController.apiGetRegisteredCustomers().then((_) {
        // Initialize filtered customers after data is loaded
        _initializeFilteredCustomers();
      });
      customerController.apiGetPendingCustomers().then((_) {
        _initializePendingFilteredCustomers();
      });
    });
  }

  Future<void> _onRefresh() async {
    try {
      final customerController = context.read<CustomerController>();

      // Call the same API methods as in initState
      await customerController.apiGetRegisteredCustomers();
      await customerController.apiGetPendingCustomers();

      // Re-initialize filtered customers after data is refreshed
      _initializeFilteredCustomers();

      // Optional: Reset the loader state if needed
      if (mounted) {
        setState(() {
          showLoader = false;
        });
      }
    } catch (e) {
      // Handle any errors during refresh
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget getProfileImage(String? profilePicture) {
    const double imageSize = 40;

    if (profilePicture == null || profilePicture.isEmpty) {
      return Container(
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

    return Container(
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
    );
  }

  void _initializeFilteredCustomers() {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    setState(() {
      filteredCustomers =
          List<RegisteredCustomer>.from(customerController.registeredCustomers);
    });
  }

  Future<void> _initializePendingFilteredCustomers() async {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    setState(() {
      filteredPendingCustomers = List.from(customerController.pendingCustomers);
    });
  }

  void _onPendingSearchChanged(String searchTerm) {
    setState(() {
      searchController.text = searchTerm;
    });
    _applyPendingFilters(searchTerm: searchTerm);
  }

  void _onPendingDateRangeChanged(DateTime? from, DateTime? to) {
    setState(() {
      fromDate = from; // ✅ Update the state variables
      toDate = to;
    });
    _applyPendingFilters(fromDate: from, toDate: to);
  }

  void _initializeFilteredPendingCustomers() {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);
    setState(() {
      filteredPendingCustomers = List.from(customerController.pendingCustomers);
    });
  }

  void _onPendingClearFilters() {
    setState(() {
      searchController.clear(); // ✅ Clear the controller
      fromDate = null; // ✅ Clear the variables
      toDate = null;
    });
    _initializeFilteredPendingCustomers();
  }

  void _applyPendingFilters(
      {String? searchTerm, DateTime? fromDate, DateTime? toDate}) {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);

    if (customerController.pendingCustomers.isEmpty) {
      return;
    }

    setState(() {
      filteredPendingCustomers =
          customerController.pendingCustomers.where((customer) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final String searchTermLower = searchTerm.toLowerCase();
          matchesSearch = customer.firstname
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.referenceNo?.toLowerCase().contains(searchTermLower) ==
                  true ||
              customer.taReferenceName
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.taReferenceNo?.toLowerCase().contains(searchTermLower) ==
                  true;
        }

        // Date range filter
        if (fromDate != null || toDate != null) {
          if (customer.registerDate != null &&
              customer.registerDate!.isNotEmpty) {
            try {
              final DateFormat inputFormat = DateFormat('dd-MM-yyyy');
              final DateTime customerDate =
                  inputFormat.parse(customer.registerDate!);

              if (fromDate != null && customerDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  customerDate.isAfter(toDate.add(const Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              Logger.error(
                  'Error parsing pending customer date: ${customer.registerDate} - $e');
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  void _applyFilters(
      {String? searchTerm, DateTime? fromDate, DateTime? toDate}) {
    final customerController =
        Provider.of<CustomerController>(context, listen: false);

    // Check if data is available
    if (customerController.registeredCustomers.isEmpty) {
      return;
    }

    setState(() {
      filteredCustomers =
          customerController.registeredCustomers.where((customer) {
        bool matchesSearch = true;
        bool matchesDateRange = true;

        // Search filter
        if (searchTerm != null && searchTerm.isNotEmpty) {
          final String searchTermLower = searchTerm.toLowerCase();
          matchesSearch = customer.firstName
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.referenceNo?.toLowerCase().contains(searchTermLower) ==
                  true ||
              customer.taReferenceName
                      ?.toLowerCase()
                      .contains(searchTermLower) ==
                  true ||
              customer.taReferenceNo?.toLowerCase().contains(searchTermLower) ==
                  true;
        }

        // Date range filter
        if (fromDate != null || toDate != null) {
          if (customer.registerDate != null &&
              customer.registerDate!.isNotEmpty) {
            try {
              final DateFormat inputFormat = DateFormat('dd-MM-yyyy');
              final DateTime customerDate =
                  inputFormat.parse(customer.registerDate!);

              if (fromDate != null && customerDate.isBefore(fromDate)) {
                matchesDateRange = false;
              }
              if (toDate != null &&
                  customerDate.isAfter(toDate.add(const Duration(days: 1)))) {
                matchesDateRange = false;
              }
            } catch (e) {
              Logger.error('Error parsing date: ${customer.registerDate} - $e');
              if (fromDate != null || toDate != null) {
                matchesDateRange = false;
              }
            }
          } else {
            if (fromDate != null || toDate != null) {
              matchesDateRange = false;
            }
          }
        }

        return matchesSearch && matchesDateRange;
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void navigateWithLoader(BuildContext context, Widget nextPage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AppLoader(),
    );

    Future.delayed(const Duration(seconds: 7), () {
      MyNavigator.pop();
      MyNavigator.pushWidget(nextPage);
    });
  }

  void _onRegisteredSearchChanged(String searchTerm) {
    _applyFilters(searchTerm: searchTerm);
  }

  void _onRegisteredDateRangeChanged(DateTime? from, DateTime? to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
    _applyFilters(fromDate: from, toDate: to);
  }

  void _onRegisteredClearFilters() {
    searchController.clear();
    _initializeFilteredCustomers();
  }

  // Helper method to check if the device is a tablet
  bool get isTablet {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide > 600;
  }

  // Build list view for pending customers (for mobile)
  Widget _buildPendingCustomersList(CustomerController customerController) {
    final customers = filteredPendingCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.pendingCustomers
        : filteredPendingCustomers;

    if (customers.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No pending customers found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildPendingCustomerCard(customer);
      },
    );
  }

  // Build card for a single pending customer
  Widget _buildPendingCustomerCard(PendingCustomer customer) {
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                getProfileImage(customer.profilePicture),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('ID: ${customer.id}'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ref. ID: ${customer.taReferenceNo ?? "N/A"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ref. Name: ${customer.taReferenceName ?? "N/A"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        getStatusColor(customer.status!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: getStatusColor(customer.status!)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    getStatusText(customer.status!),
                    style: TextStyle(
                      color: getStatusColor(customer.status!),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Joining Date: ${formatDate(customer.addedOn)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Build list view for registered customers (for mobile)
  Widget _buildRegisteredCustomersList(CustomerController customerController) {
    final customers = filteredCustomers.isEmpty &&
            (searchController.text.isEmpty &&
                fromDate == null &&
                toDate == null)
        ? customerController.registeredCustomers
        : filteredCustomers;

    if (customers.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No registered customers found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildRegisteredCustomerCard(customer, customerController);
      },
    );
  }

  // Build card for a single registered customer
  Widget _buildRegisteredCustomerCard(
      RegisteredCustomer customer, CustomerController customerController) {
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                getProfileImage(customer.profilePicture),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Customer ID: ${customer.caCustomerId}'),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        break;
                      case 'delete':
                        break;
                      case 'restore':
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    final List<PopupMenuEntry<String>> menuItems = [];

                    if (customer.status == '1') {
                      menuItems.addAll([
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                            title: const Text('Edit'),
                            onTap: () async {
                              final customerCustomerr =
                                  context.read<CustomerController>();
                              Navigator.pop(context);

                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReferralCustomer(
                                    registeredCustomer: customer,
                                    isEditMode: true,
                                  ),
                                ),
                              );

                              await customerCustomerr
                                  .apiGetRegisteredCustomers();
                              await customerCustomerr.apiGetPendingCustomers();
                              Logger.warning('result after edit: $result');
                              if (result == true) {
                                await _onRefresh();
                              }
                            },
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading:
                                const Icon(Icons.delete, color: Colors.red),
                            title: const Text('Delete'),
                            onTap: () async {
                              Navigator.pop(context);
                              await customerController.apiDeleteCustomer(
                                  context, customer);
                              await _onRefresh();
                            },
                          ),
                        ),
                      ]);
                    } else if (customer.status == '3') {
                      menuItems.add(
                        PopupMenuItem(
                          value: 'restore',
                          child: ListTile(
                            leading:
                                const Icon(Icons.restore, color: Colors.green),
                            title: const Text('Restore'),
                            onTap: () async {
                              Navigator.pop(context);
                              await customerController.apiRestoreCustomer(
                                  context, customer);
                              await _onRefresh();
                            },
                          ),
                        ),
                      );
                    }

                    return menuItems;
                  },
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reg. ID: ${customer.taReferenceNo ?? "N/A"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reg. Name: ${customer.taReferenceName ?? "N/A"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        getStatusColor(customer.status!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: getStatusColor(customer.status!)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    getStatusText(customer.status!),
                    style: TextStyle(
                      color: getStatusColor(customer.status!),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Joining Date: ${customer.registerDate ?? "N/A"}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerController>(
      builder: (context, customerController, child) {
        final String userCount = filteredCustomers.isEmpty &&
                (searchController.text.isEmpty &&
                    fromDate == null &&
                    toDate == null)
            ? customerController.registeredCustomers.length.toString()
            : filteredCustomers.length.toString();
        final String pendingUserCount = filteredPendingCustomers.isEmpty &&
                (searchController.text.isEmpty &&
                    fromDate == null &&
                    toDate == null)
            ? customerController.pendingCustomers.length.toString()
            : filteredPendingCustomers.length.toString();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CDashboardPage(),
              ),
            );
          },
          child: showLoader
              ? const AppLoader()
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Divider(thickness: 1, color: Colors.black26),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "All Pending Referral Customer's List:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.black26),
                          FilterBar(
                            userCount: pendingUserCount,
                            onSearchChanged: _onPendingSearchChanged,
                            onDateRangeChanged: _onPendingDateRangeChanged,
                            onClearFilters: _onPendingClearFilters,
                          ),
                          _buildPendingCustomersList(customerController),
                          const SizedBox(height: 35),
                          const Divider(thickness: 1, color: Colors.black26),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "All Registered Referral Customer's List:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.black26),
                          FilterBar(
                            userCount: userCount,
                            onSearchChanged: _onRegisteredSearchChanged,
                            onDateRangeChanged: _onRegisteredDateRangeChanged,
                            onClearFilters: _onRegisteredClearFilters,
                          ),
                          // Error Messages
                          if (fromDateError != null || toDateError != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  if (fromDateError != null)
                                    Text(
                                      fromDateError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  if (fromDateError != null &&
                                      toDateError != null)
                                    const Text(' | ',
                                        style: TextStyle(color: Colors.red)),
                                  if (toDateError != null)
                                    Text(
                                      toDateError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          _buildRegisteredCustomersList(customerController),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
