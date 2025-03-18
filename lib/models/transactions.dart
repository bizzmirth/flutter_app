class Transaction {
  final String title;
  final String whom;
  final String via;
  final String date;
  final double amount;

  Transaction(
      {required this.title,
      required this.whom,
      required this.via,
      required this.date,
      required this.amount});
}
