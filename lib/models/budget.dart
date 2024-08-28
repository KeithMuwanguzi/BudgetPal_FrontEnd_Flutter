class Budget {
  final int id;
  final String name;
  final double amount;
  final double spent;
  final String category;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.spent,
    required this.category,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      amount: double.parse(json['amount']),
      spent: json['spent'].toDouble(),
      category: json['category'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}

// Goal model
class Goal {
  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
  });
}

// Report model
class Report {
  final int id;
  final String title;
  final DateTime generatedDate;
  final String type;
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.title,
    required this.generatedDate,
    required this.type,
    required this.data,
  });
}
