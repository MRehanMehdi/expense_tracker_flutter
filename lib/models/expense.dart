// lib/models/expense.dart

class Expense {
  final int? id;
  final String category;
  final double amount;
  final String date;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, category: $category, amount: $amount, date: $date}';
  }
}
