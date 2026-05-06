import '../models/expense_item.dart';

class NeedsController {
  static const List<ExpenseItem> needsItems = [
    ExpenseItem(id: 'recharge', name: 'Mobile Recharge', basePrice: 300, emoji: '📱'),
    ExpenseItem(id: 'petrol', name: 'Petrol', basePrice: 500, emoji: '⛽'),
    ExpenseItem(id: 'grooming', name: 'Grooming', basePrice: 170, emoji: '✂️'),
    ExpenseItem(id: 'manual', name: 'Custom', basePrice: 0, emoji: '➕'),
  ];

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
    final item = droppedItems
        .where((d) => d.item.id == itemId)
        .firstOrNull;
    if (item == null) return;
    if (quantity != null) item.quantity = quantity;
    if (price != null) item.priceOverride = price;
  }

  double get totalExpense =>
      droppedItems.fold(0, (sum, d) => sum + d.totalPrice);
}