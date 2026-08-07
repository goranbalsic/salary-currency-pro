/// A named needs/wants/savings percentage split.
class BudgetSplit {
  final String id;
  final String label;
  final double needsPercent;
  final double wantsPercent;
  final double savingsPercent;

  const BudgetSplit({
    required this.id,
    required this.label,
    required this.needsPercent,
    required this.wantsPercent,
    required this.savingsPercent,
  });
}

/// Three common presets. "Custom" is handled by the UI directly (any three
/// percentages that sum to 100), not listed here.
const kBudgetPresets = <BudgetSplit>[
  BudgetSplit(
    id: 'classic',
    label: '50 / 30 / 20',
    needsPercent: 50,
    wantsPercent: 30,
    savingsPercent: 20,
  ),
  BudgetSplit(
    id: 'lean',
    label: '60 / 20 / 20',
    needsPercent: 60,
    wantsPercent: 20,
    savingsPercent: 20,
  ),
  BudgetSplit(
    id: 'aggressive-save',
    label: '50 / 20 / 30',
    needsPercent: 50,
    wantsPercent: 20,
    savingsPercent: 30,
  ),
];

class BudgetAllocation {
  final double needs;
  final double wants;
  final double savings;

  const BudgetAllocation({
    required this.needs,
    required this.wants,
    required this.savings,
  });
}

class BudgetPlanner {
  BudgetPlanner._();

  static BudgetAllocation allocate(double monthlyIncome, BudgetSplit split) {
    return BudgetAllocation(
      needs: monthlyIncome * split.needsPercent / 100,
      wants: monthlyIncome * split.wantsPercent / 100,
      savings: monthlyIncome * split.savingsPercent / 100,
    );
  }
}
