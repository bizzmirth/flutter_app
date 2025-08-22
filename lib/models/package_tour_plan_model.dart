class PackageTourPlan {
  final String day;
  final String title;
  final String dayDetails;
  final String dayTransport;
  final String mealPlan;

  PackageTourPlan({
    required this.day,
    required this.title,
    required this.dayDetails,
    required this.dayTransport,
    required this.mealPlan,
  });

  factory PackageTourPlan.fromJson(Map<String, dynamic> json) {
    return PackageTourPlan(
      day: json['day']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      dayDetails: json['day_details']?.toString() ?? '',
      dayTransport: json['day_tansport']?.toString() ??
          '', // Note: API has typo "tansport"
      mealPlan: json['meal_plan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'title': title,
      'day_details': dayDetails,
      'day_tansport': dayTransport, // Keeping API's original key with typo
      'meal_plan': mealPlan,
    };
  }

  // Helper methods
  int get dayNumber {
    final match = RegExp(r'Day (\d+)').firstMatch(day);
    return match != null ? int.tryParse(match.group(1) ?? '0') ?? 0 : 0;
  }

  List<String> get mealsList {
    if (mealPlan.isEmpty) return [];
    return mealPlan
        .split(' and ')
        .map((meal) => meal.trim())
        .where((meal) => meal.isNotEmpty)
        .toList();
  }

  bool get hasBreakfast => mealPlan.toLowerCase().contains('breakfast');
  bool get hasLunch => mealPlan.toLowerCase().contains('lunch');
  bool get hasDinner => mealPlan.toLowerCase().contains('dinner');

  // Extract places to visit from day details
  List<String> get placesToVisit {
    final places = <String>[];
    final text = dayDetails.toLowerCase();

    final patterns = [
      RegExp(r'visit\s+([^,\.]+?)(?:,|\.|temple|mandir|ghat)',
          caseSensitive: false),
      RegExp(r'proceed\s+to\s+([^,\.]+?)(?:,|\.)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(dayDetails);
      for (final match in matches) {
        final place = match.group(1)?.trim();
        if (place != null && place.isNotEmpty) {
          places.add(place);
        }
      }
    }

    return places.toSet().toList(); // Remove duplicates
  }

  // Check if it's departure day
  bool get isDepartureDay {
    return dayDetails.toLowerCase().contains('departure') ||
        dayDetails.toLowerCase().contains('check out') ||
        title.toLowerCase().contains('departure');
  }

  // Check if it's arrival day
  bool get isArrivalDay {
    return dayDetails.toLowerCase().contains('arrival') ||
        dayDetails.toLowerCase().contains('check in') ||
        dayNumber == 1;
  }

  // Extract travel distance if mentioned
  String get travelDistance {
    final match =
        RegExp(r'\((\d+\s*kms?)', caseSensitive: false).firstMatch(dayDetails);
    return match?.group(1) ?? '';
  }

  // Extract travel time if mentioned
  String get travelTime {
    final match = RegExp(r'(\d+\s*hours?\s*approx)', caseSensitive: false)
        .firstMatch(dayDetails);
    return match?.group(1) ?? '';
  }

  @override
  String toString() {
    return 'PackageTourPlan(day: $day, title: $title)';
  }
}
