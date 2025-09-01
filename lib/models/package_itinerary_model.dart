class PackageItinerary {
  final String packageId;
  final String inclusion;
  final String exclusion;
  final String remark;

  PackageItinerary({
    required this.packageId,
    required this.inclusion,
    required this.exclusion,
    required this.remark,
  });

  factory PackageItinerary.fromJson(Map<String, dynamic> json) {
    return PackageItinerary(
      packageId: json['package_id']?.toString() ?? '',
      inclusion: json['inclusion']?.toString() ?? '',
      exclusion: json['exclusion']?.toString() ?? '',
      remark: json['remark']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_id': packageId,
      'inclusion': inclusion,
      'exclusion': exclusion,
      'remark': remark,
    };
  }

  // Helper methods to parse inclusions and exclusions into lists
  List<String> get inclusionList {
    if (inclusion.isEmpty) return [];
    return inclusion
        .split('.')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  List<String> get exclusionList {
    if (exclusion.isEmpty) return [];
    return exclusion
        .split('.')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  // Get cancellation policy details
  Map<String, String> get cancellationPolicy {
    final policy = <String, String>{};
    if (remark.isEmpty) return policy;

    // Parse cancellation policy from remarks
    final lines = remark.split('.');
    for (String line in lines) {
      line = line.trim();
      if (line.contains('more than 30 days')) {
        policy['30+ days'] = _extractPercentage(line);
      } else if (line.contains('between 15 and 30 days')) {
        policy['15-30 days'] = _extractPercentage(line);
      } else if (line.contains('within 15 days')) {
        policy['0-15 days'] = _extractPercentage(line);
      }
    }
    return policy;
  }

  String _extractPercentage(String text) {
    final regex = RegExp(r'(\d+)%');
    final match = regex.firstMatch(text);
    return match != null ? '${match.group(1)}%' : '';
  }

  // Check if has cancellation policy
  bool get hasCancellationPolicy {
    return remark.toLowerCase().contains('cancellation');
  }

  // Get terms and conditions indicator
  bool get hasTermsAndConditions {
    return remark.toLowerCase().contains('t&c') ||
        remark.toLowerCase().contains('terms');
  }

  @override
  String toString() {
    return 'PackageItinerary(packageId: $packageId, inclusionsCount: ${inclusionList.length})';
  }
}
