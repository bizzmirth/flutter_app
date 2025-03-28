import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/business_mentor/add_business_mentor.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBMDataSource extends DataTableSource {
  final List<PendingBusinessMentorModel> data;
  MyBMDataSource(this.data);

  Widget getProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return Center(
        child: Container(
          width: 40,
          height: 40,
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

    String extractPathSegment(String fullPath, String folderPrefix) {
      int index = fullPath.lastIndexOf(folderPrefix);
      if (index != -1) {
        return fullPath.substring(index);
      }
      return fullPath;
    }

    final String imageUrl;
    if (profilePicture.contains('https://testca.uniqbizz.com/uploading/')) {
      imageUrl = profilePicture;
    } else {
      final newpath = extractPathSegment(profilePicture, 'profile_pic/');
      imageUrl = "https://testca.uniqbizz.com/uploading/$newpath";
    }

    Logger.success("Final image URL: $imageUrl");
// Action Menu Widget

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Logger.error("Failed to load image: $error");S
            return Image.asset(
              "assets/default_profile.png",
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return "N/A"; // Handle null/empty cases
    }

    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      return DateFormat("dd-MM-yyyy").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final businessMentor = data[index];
    var newStatus = "";
    final status = businessMentor.status.toString();
    if (status == '2') {
      newStatus = "Pending";
    } else if (status == '0') {
      newStatus = "Deleted";
    }

    return DataRow(
      cells: [
        DataCell(
          Center(
            child: CircleAvatar(
              // backgroundImage: NetworkImage(order["profilePicture"]),
              radius: 20,
              child: getProfileImage(businessMentor.profilePicture),
            ),
          ),
        ),
        DataCell(Text(businessMentor.id.toString())),
        DataCell(Text(businessMentor.name ?? "N/A")),
        DataCell(Text(businessMentor.phoneNumber ?? "N/A")),
        DataCell(Text(businessMentor.refName ?? "N/A")),
        DataCell(Text(formatDate(businessMentor.dob))),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(businessMentor.status.toString()),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              newStatus,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(_buildActionMenu(businessMentor)),
      ],
    );
  }

  String _getStatusText(dynamic status) {
    if (status == null) return "Unknown";

    if (status is String) {
      if (status.isEmpty) return "Unknown";
      return status;
    }

    if (status is int || status is double) {
      switch (status) {
        case 1:
          return "Completed";
        case 2:
          return "Pending";
        case 0:
          return "Cancelled";
        default:
          return "Unknown";
      }
    }

    return status.toString();
  }

  Color _getStatusColor(String status) {
    String statusText = _getStatusText(status).toLowerCase();
    switch (statusText) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.grey;
      case "pending":
        return Colors.orange;
      case "0":
        return Colors.red;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.yellowAccent;
    }
  }

// Action Menu Widget
  Widget _buildActionMenu(PendingBusinessMentorModel businessMentor) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu actions
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "view",
          child: ListTile(
              leading: Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
              title: Text("View"),
              onTap: () {
                // Logger.success(technoEnterprise.name!);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddbmPage(
                      isViewMode: true,
                      pendingBusinessMentor: businessMentor,
                    ),
                  ),
                );
              }),
        ),
        PopupMenuItem(
          value: "edit",
          child: ListTile(
            leading:
                Icon(Icons.edit, color: const Color.fromARGB(255, 0, 105, 190)),
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
        PopupMenuItem(
          value: "register",
          child: ListTile(
            leading: Icon(Icons.app_registration,
                color: const Color.fromARGB(255, 43, 29, 240)),
            title: Text("Register"),
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
