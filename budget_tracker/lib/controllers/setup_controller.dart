import '../models/budget_model.dart';
import 'budget_controller.dart';

class SetupController {
  static Future<void> confirmBudget({
    required double total,
    required double needs,
    required double wants,
    required double savings,
  }) async {
    final budget = BudgetModel(
      total: total,
      needs: needs,
      wants: wants,
      savings: savings,
    );
    await BudgetController.saveBudget(budget);
  }
}