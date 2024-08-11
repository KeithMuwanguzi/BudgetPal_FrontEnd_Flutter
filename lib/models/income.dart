class Income {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;
  final String description;

  Income({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
