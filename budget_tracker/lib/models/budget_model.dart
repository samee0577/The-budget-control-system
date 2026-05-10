class BudgetModel {
  final double total;
  final double needs;
  final double wants;
  final double savings;
  final double unallocated;

  BudgetModel({
    required this.total,
    required this.needs,
    required this.wants,
    required this.savings,
    this.unallocated = 0,
  });

  double get needsPercent => (needs / total * 100);
  double get wantsPercent => (wants / total * 100);
  double get savingsPercent => (savings / total * 100);

  Map<String, dynamic> toMap() => {
    'total': total,
    'needs': needs,
    'wants': wants,
    'savings': savings,
    'unallocated': unallocated,
  };

  factory BudgetModel.fromMap(Map<String, dynamic> map) => BudgetModel(
    total: map['total'],
    needs: map['needs'],
    wants: map['wants'],
    savings: map['savings'],
    unallocated: map['unallocated'] ?? 0,
  );

  factory BudgetModel.defaultBudget(double total) => BudgetModel(
    total: total,
    needs: total * 0.50,
    wants: total * 0.30,
    savings: total * 0.20,
    unallocated: 0,
  );

  BudgetModel copyWith({
    double? total,
    double? needs,
    double? wants,
    double? savings,
    double? unallocated,
  }) {
    return BudgetModel(
      total: total ?? this.total,
      needs: needs ?? this.needs,
      wants: wants ?? this.wants,
      savings: savings ?? this.savings,
      unallocated: unallocated ?? this.unallocated,
    );
  }
}