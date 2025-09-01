class CouponData {
  final String id;
  final String userId;
  final String paymentId;
  final String code;
  final String couponAmt;
  final String usageStatus;
  final String confirmStatus;
  final String createdDate;
  final String? usedDate;
  final String? deletedDate;
  final String expiryDate;

  CouponData({
    required this.id,
    required this.userId,
    required this.paymentId,
    required this.code,
    required this.couponAmt,
    required this.usageStatus,
    required this.confirmStatus,
    required this.createdDate,
    this.usedDate,
    this.deletedDate,
    required this.expiryDate,
  });
}
