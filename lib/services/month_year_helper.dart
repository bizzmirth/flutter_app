Map<String, String> resolveMonthYear({
  required String type,
  DateTime? baseDate,
}) {
  final DateTime referenceDate = baseDate ?? DateTime.now();

  late DateTime targetDate;

  if (type == 'previous') {
    targetDate = DateTime(
      referenceDate.year,
      referenceDate.month - 1,
    );
  } else if (type == 'next') {
    targetDate = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
    );
  } else {
    targetDate = referenceDate;
  }

  return {
    'month': targetDate.month.toString().padLeft(2, '0'),
    'year': targetDate.year.toString(),
  };
}
