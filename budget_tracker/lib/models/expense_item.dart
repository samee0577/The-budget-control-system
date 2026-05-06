class ExpenseItem {
  final String id;
  final String name;
  final double basePrice;
  final String emoji;

  const ExpenseItem({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.emoji,
  });
}

class DroppedExpense {
  final ExpenseItem item;
  int quantity;
  double priceOverride;

  DroppedExpense({
    required this.item,
    this.quantity = 1,
    double? priceOverride,
  }) : priceOverride = priceOverride ?? item.basePrice;

  double get totalPrice => priceOverride * quantity;

  String get displayName => quantity > 1 ? '${item.name} x$quantity' : item.name;
}