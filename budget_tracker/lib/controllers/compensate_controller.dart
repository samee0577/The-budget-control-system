import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/transaction_controller.dart';
import '../models/compensate_model.dart';
import '../models/transaction_model.dart';

class CompensateController {
  static const String _cardsKey = 'compensate_cards';
  List<CompensateCard> cards = [];

  Future<void> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cardsKey);
    if (data == null) return;
    final list = jsonDecode(data) as List;
    cards = list.map((e) => CompensateCard.fromMap(e)).toList();
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cardsKey,
      jsonEncode(cards.map((c) => c.toMap()).toList()),
    );
  }

  Future<void> addCard(CompensateCard card) async {
    cards.add(card);
    await _saveCards();
  }

  Future<void> deleteCard(String id) async {
    cards.removeWhere((c) => c.id == id);
    await _saveCards();
  }

  Future<TransactionEntry?> returnAmount({
    required String cardId,
    required double returnedAmount,
  }) async {
    final card = cards.where((c) => c.id == cardId).firstOrNull;
    if (card == null) return null;

    card.remainingAmount -= returnedAmount;

    TransactionEntry entry = TransactionEntry(
      id: '${cardId}_${DateTime.now().millisecondsSinceEpoch}',
      emoji: '💸',
      name: '${card.personName} returned for ${card.itemName}',
      amount: returnedAmount,
      dateTime: DateTime.now(),
    );

    if (card.isFullyReturned) {
      cards.removeWhere((c) => c.id == cardId);
    }

    await _saveCards();
    await TransactionController.saveTransaction(
      section: 'compensate',
      entry: entry,
    );

    return entry;
  }

  double get totalOwed => cards.fold(0, (sum, c) => sum + c.remainingAmount);
}