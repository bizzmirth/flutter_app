class PackagePrice {
  final String totalPackagePricePerAdult;
  final String totalPackagePricePerChild;

  PackagePrice({
    required this.totalPackagePricePerAdult,
    required this.totalPackagePricePerChild,
  });

  factory PackagePrice.fromJson(Map<String, dynamic> json) {
    return PackagePrice(
      totalPackagePricePerAdult:
          json['total_package_price_per_adult']?.toString() ?? '0',
      totalPackagePricePerChild:
          json['total_package_price_per_child']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_package_price_per_adult': totalPackagePricePerAdult,
      'total_package_price_per_child': totalPackagePricePerChild,
    };
  }

  // Helper methods to get prices as double
  double get adultPrice => double.tryParse(totalPackagePricePerAdult) ?? 0.0;
  double get childPrice => double.tryParse(totalPackagePricePerChild) ?? 0.0;

  // Helper methods for formatted prices
  String get formattedAdultPrice => '₹${adultPrice.toStringAsFixed(2)}';
  String get formattedChildPrice => '₹${childPrice.toStringAsFixed(2)}';

  // Calculate total price for given adults and children
  double calculateTotalPrice(int adults, int children) {
    return (adultPrice * adults) + (childPrice * children);
  }

  String getFormattedTotalPrice(int adults, int children) {
    return '₹${calculateTotalPrice(adults, children).toStringAsFixed(2)}';
  }

  // Calculate discount percentage if child price is less than adult
  double get childDiscountPercentage {
    if (adultPrice == 0) return 0;
    return ((adultPrice - childPrice) / adultPrice) * 100;
  }

  @override
  String toString() {
    return 'PackagePrice(adult: $formattedAdultPrice, child: $formattedChildPrice)';
  }
}
