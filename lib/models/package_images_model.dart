class PackagePicture {
  final String packageId;
  final String image;

  PackagePicture({
    required this.packageId,
    required this.image,
  });

  factory PackagePicture.fromJson(Map<String, dynamic> json) {
    return PackagePicture(
      packageId: json['package_id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_id': packageId,
      'image': image,
    };
  }

  // Helper methods
  String get fileName {
    if (image.isEmpty) return '';
    return image.split('/').last;
  }

  String get fileExtension {
    if (image.isEmpty) return '';
    return image.split('.').last.toLowerCase();
  }

  bool get isValidImage {
    final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return validExtensions.contains(fileExtension);
  }

  // Get full URL if needed (assuming base URL)
  String getFullImageUrl({String baseUrl = 'https://ca.uniqbizz.com/'}) {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return '$baseUrl$image';
  }

  // Get thumbnail URL (if your API supports thumbnails)
  String getThumbnailUrl({String baseUrl = 'https://tca.uniqbizz.com/'}) {
    final fullUrl = getFullImageUrl(baseUrl: baseUrl);
    if (fullUrl.isEmpty) return '';

    // Example: Replace the filename with thumbnail version
    final parts = fullUrl.split('/');
    if (parts.isNotEmpty) {
      final fileName = parts.last;
      final nameWithoutExt = fileName.split('.').first;
      final ext = fileName.split('.').last;
      parts[parts.length - 1] = '${nameWithoutExt}_thumb.$ext';
      return parts.join('/');
    }
    return fullUrl;
  }

  @override
  String toString() {
    return 'PackagePicture(packageId: $packageId, image: $image)';
  }
}
