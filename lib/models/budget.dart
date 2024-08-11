class Budget {
  final int? id;
  final String category;
  final double budgetLimit;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    this.id,
    required this.category,
    required this.budgetLimit,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      budgetLimit: json['budget_limit'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}
