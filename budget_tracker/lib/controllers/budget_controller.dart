import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget_model.dart';

class BudgetController {
  static const String _key = 'budget_data';

  static Future<void> saveBudget(BudgetModel budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(budget.toMap()));
  }

  static Future<BudgetModel?> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return null;
    return BudgetModel.fromMap(jsonDecode(data));
  }

  static Future<void> clearBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<bool> hasBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}