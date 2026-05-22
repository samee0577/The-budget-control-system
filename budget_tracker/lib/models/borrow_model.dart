class BorrowCard {
  final String id;
  final String itemName;
  final String personName;
  final double originalAmount;
  double remainingAmount;

  BorrowCard({
    required this.id,
    required this.itemName,
    required this.personName,
    required this.originalAmount,
    required this.remainingAmount,
  });

  bool get isFullyRepaid => remainingAmount <= 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'itemName': itemName,
    'personName': personName,
    'originalAmount': originalAmount,
    'remainingAmount': remainingAmount,
  };

  factory BorrowCard.fromMap(Map<String, dynamic> map) => BorrowCard(
    id: map['id'],
    itemName: map['itemName'],
    personName: map['personName'],
    originalAmount: map['originalAmount'],
    remainingAmount: map['remainingAmount'],
  );
}