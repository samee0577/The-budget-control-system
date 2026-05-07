import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionController {
  static String _key(String section) => 'transactions_$section';

  static Future<void> saveTransaction({
    required String section,
    required TransactionEntry entry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadTransactions(section: section);
    existing.insert(0, entry);
    final encoded = jsonEncode(existing.map((e) => e.toMap()).toList());
    await prefs.setString(_key(section), encoded);
  }

  static Future<List<TransactionEntry>> loadTransactions({
    required String section,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key(section));
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => TransactionEntry.fromMap(e)).toList();
  }
}