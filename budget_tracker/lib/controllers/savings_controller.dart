import '../models/expense_item.dart';
import '../models/transaction_model.dart';

class SavingsController {
  static const List<ExpenseItem> savingsItems = [
    ExpenseItem(id: 'Bissi', name: 'Bissi', basePrice: 2000, emoji: '💵'),
  ];

  List<TransactionEntry> buildTransactions() {
    return droppedItems
        .map(
          (d) => TransactionEntry(
            id: '${d.item.id}_${DateTime.now().millisecondsSinceEpoch}',
            emoji: d.item.emoji,
            name: d.displayName,
            amount: d.totalPrice,
            dateTime: DateTime.now(),
          ),
        )
        .toList();
  }

  final List<DroppedExpense> droppedItems = [];

  void dropItem(ExpenseItem item) {
    final existing = droppedItems
        .where((d) => d.item.id == item.id)
        .firstOrNull;
    if (existing != null) {
      existing.quantity++;
    } else {
      droppedItems.add(DroppedExpense(item: item));
    }
  }

  void removeItem(String itemId) {
    droppedItems.removeWhere((d) => d.item.id == itemId);
  }

  void updateItem(String itemId, {int? quantity, double? price}) {
    final item = droppedItems.where((d) => d.item.id == itemId).firstOrNull;
    if (item == null) return;
    if (quantity != null) item.quantity = quantity;
    if (price != null) item.priceOverride = price;
  }

  double get totalExpense =>
      droppedItems.fold(0, (sum, d) => sum + d.totalPrice);
}
