// lib/models/expense.dart

class Expense {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
  });

  // Convert Expense object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(), // store date as string in ISO format
    };
  }

  // Create Expense object from Map fetched from database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      amount: map['amount'] is int
          ? (map['amount'] as int).toDouble()
          : map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, category: $category, amount: $amount, date: $date}';
  }
}
