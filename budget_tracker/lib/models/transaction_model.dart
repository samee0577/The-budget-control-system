class TransactionEntry {
  final String id;
  final String emoji;
  final String name;
  final double amount;
  final DateTime dateTime;

  TransactionEntry({
    required this.id,
    required this.emoji,
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'emoji': emoji,
    'name': name,
    'amount': amount,
    'dateTime': dateTime.toIso8601String(),
  };

  factory TransactionEntry.fromMap(Map<String, dynamic> map) => TransactionEntry(
    id: map['id'],
    emoji: map['emoji'],
    name: map['name'],
    amount: map['amount'],
    dateTime: DateTime.parse(map['dateTime']),
  );
}