class Income {
  final int id;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;

  Income({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'],
    );
  }
}
