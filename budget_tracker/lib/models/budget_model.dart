class BudgetModel {
  final double total; // original total income
  final double needs; // original needs allocation
  final double wants; // original wants allocation
  final double savings; // original savings allocation
  final double needsRemaining; // decreases as expenses logged
  final double wantsRemaining; // decreases as expenses logged
  final double savingsRemaining; // decreases as expenses logged
  final double unallocated;

  BudgetModel({
    required this.total,
    required this.needs,
    required this.wants,
    required this.savings,
    double? needsRemaining,
    double? wantsRemaining,
    double? savingsRemaining,
    this.unallocated = 0,
  }) : needsRemaining = needsRemaining ?? needs,
       wantsRemaining = wantsRemaining ?? wants,
       savingsRemaining = savingsRemaining ?? savings;

  // how much spent in each section
  double get needsSpent => needs - needsRemaining;
  double get wantsSpent => wants - wantsRemaining;
  double get savingsSpent => savings - savingsRemaining;

  // total spent across all sections
  double get totalSpent => needsSpent + wantsSpent + savingsSpent;

  // progress per section
  double get needsProgress => needs > 0 ? needsRemaining / needs : 0;
  double get wantsProgress => wants > 0 ? wantsRemaining / wants : 0;
  double get savingsProgress => savings > 0 ? savingsRemaining / savings : 0;

  double get needsPercent => (needs / total * 100);
  double get wantsPercent => (wants / total * 100);
  double get savingsPercent => (savings / total * 100);

  Map<String, dynamic> toMap() => {
    'total': total,
    'needs': needs,
    'wants': wants,
    'savings': savings,
    'needsRemaining': needsRemaining,
    'wantsRemaining': wantsRemaining,
    'savingsRemaining': savingsRemaining,
    'unallocated': unallocated,
  };

  factory BudgetModel.fromMap(Map<String, dynamic> map) => BudgetModel(
    total: map['total'],
    needs: map['needs'],
    wants: map['wants'],
    savings: map['savings'],
    needsRemaining: map['needsRemaining'] ?? map['needs'],
    wantsRemaining: map['wantsRemaining'] ?? map['wants'],
    savingsRemaining: map['savingsRemaining'] ?? map['savings'],
    unallocated: map['unallocated'] ?? 0,
  );

  factory BudgetModel.defaultBudget(double total) => BudgetModel(
    total: total,
    needs: total * 0.50,
    wants: total * 0.30,
    savings: total * 0.20,
  );

  BudgetModel copyWith({
    double? total,
    double? needs,
    double? wants,
    double? savings,
    double? needsRemaining,
    double? wantsRemaining,
    double? savingsRemaining,
    double? unallocated,
  }) {
    return BudgetModel(
      total: total ?? this.total,
      needs: needs ?? this.needs,
      wants: wants ?? this.wants,
      savings: savings ?? this.savings,
      needsRemaining: needsRemaining ?? this.needsRemaining,
      wantsRemaining: wantsRemaining ?? this.wantsRemaining,
      savingsRemaining: savingsRemaining ?? this.savingsRemaining,
      unallocated: unallocated ?? this.unallocated,
    );
  }
}
