class TcOrderHistoryRecentBooking {
  final String? title;
  final String? start;
  final String? orderId;
  final String? customerName;
  final String? status;
  final String? confirmStatus;
  final String? packageImage;
  final String? profilePic;
  final String? packageName;

  TcOrderHistoryRecentBooking({
    this.title,
    this.start,
    this.orderId,
    this.customerName,
    this.status,
    this.confirmStatus,
    this.packageImage,
    this.profilePic,
    this.packageName,
  });

  factory TcOrderHistoryRecentBooking.fromJson(Map<String, dynamic> json) {
    final props = json['extendedProps'] ?? {};

    return TcOrderHistoryRecentBooking(
      title: json['title'],
      start: json['start'],
      orderId: props['order_id'],
      customerName: props['customer_name'],
      status: props['status'],
      confirmStatus: props['confirm_status'],
      packageImage: props['package_image'],
      profilePic: props['profile_pic'],
      packageName: props['package_name'],
    );
  }
}
