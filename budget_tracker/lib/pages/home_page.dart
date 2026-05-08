import 'package:flutter/material.dart';
import '../controllers/budget_controller.dart';
import '../controllers/compensate_controller.dart';
import '../models/budget_model.dart';
import './setup_page.dart';
import './needs_page.dart';
import './wants_page.dart';
import './savings_page.dart';
import 'compensate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BudgetModel? _budget;
  double _compensateOwed = 0;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final budget = await BudgetController.loadBudget();
    final compensate = CompensateController();
    await compensate.loadCards();
    setState(() {
      _budget = budget;
      _compensateOwed = compensate.totalOwed;
    });
  }

  Widget _compensateCard() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompensatePage()),
        );
        _loadBudget();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16162A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compensate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE8E8F5),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track money to recover',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B6B8A)),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF6B6B8A),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_budget == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF7B7BCC)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        title: const Text(
          'Spndwell',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE8E8F5),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B6B8A)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SetupPage()),
              );
              _loadBudget();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalCard(),
            const SizedBox(height: 28),
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B6B8A),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            _sectionCard(
              label: 'Needs',
              total: _budget!.needs,
              remaining: _budget!.needs,
              percent: _budget!.needsPercent,
              color: const Color(0xFFCC8A3E),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NeedsPage(budget: _budget!),
                  ),
                );
                _loadBudget(); // reloads fresh when you come back
              },
            ),
            const SizedBox(height: 12),
            _sectionCard(
              label: 'Wants',
              total: _budget!.wants,
              remaining: _budget!.wants,
              percent: _budget!.wantsPercent,
              color: const Color(0xFFCC5A7A),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WantsPage(budget: _budget!),
                  ),
                );
                _loadBudget();
              },
            ),
            const SizedBox(height: 12),
            _sectionCard(
              label: 'Savings',
              total: _budget!.savings,
              remaining: _budget!.savings,
              percent: _budget!.savingsPercent,
              color: const Color(0xFF2EB89A),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SavingsPage(budget: _budget!),
                  ),
                );
                _loadBudget();
              },
            ),
            const SizedBox(height: 28),
            const Divider(color: Color(0xFF2A2A40)),
            const SizedBox(height: 20),
            _compensateCard(),
          ],
        ),
      ),
    );
  }

  Widget _totalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Income',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B6B8A),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${_budget!.total.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE8E8F5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String label,
    required double total,
    required double remaining,
    required double percent,
    required Color color,
    required VoidCallback onTap,
  }) {
    // final spent = total - remaining;
    final progress = remaining / total;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16162A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE8E8F5),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B6B8A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${remaining.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'of',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B6B8A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B6B8A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: const Color(0xFF2A2A40),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
