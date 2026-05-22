import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/borrow_model.dart';
import '../models/transaction_model.dart';
import '../controllers/transaction_controller.dart';

class BorrowController {
  static const String _cardsKey = 'borrow_cards';
  List<BorrowCard> cards = [];

  Future<void> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cardsKey);
    if (data == null) return;
    final list = jsonDecode(data) as List;
    cards = list.map((e) => BorrowCard.fromMap(e)).toList();
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cardsKey,
      jsonEncode(cards.map((c) => c.toMap()).toList()),
    );
  }

  Future<void> addCard(BorrowCard card) async {
    cards.add(card);
    await _saveCards();
  }

  Future<void> deleteCard(String id) async {
    cards.removeWhere((c) => c.id == id);
    await _saveCards();
  }

  Future<TransactionEntry?> repayAmount({
    required String cardId,
    required double repaidAmount,
  }) async {
    final card = cards.where((c) => c.id == cardId).firstOrNull;
    if (card == null) return null;

    card.remainingAmount -= repaidAmount;

    final entry = TransactionEntry(
      id: '${cardId}_${DateTime.now().millisecondsSinceEpoch}',
      emoji: '📥',
      name: 'Repaid ${card.personName} for ${card.itemName}',
      amount: repaidAmount,
      dateTime: DateTime.now(),
    );

    if (card.isFullyRepaid) {
      cards.removeWhere((c) => c.id == cardId);
    }

    await _saveCards();
    await TransactionController.saveTransaction(
      section: 'borrow',
      entry: entry,
    );

    return entry;
  }

  double get totalBorrowed =>
      cards.fold(0, (sum, c) => sum + c.remainingAmount);
}