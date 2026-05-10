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

  void _showTopUpPopup() {
    final totalController = TextEditingController();
    final needsController = TextEditingController();
    final wantsController = TextEditingController();
    final savingsController = TextEditingController();
    bool isAutoDistribute = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          double topUpAmount = double.tryParse(totalController.text) ?? 0;
          double allocated =
              (double.tryParse(needsController.text) ?? 0) +
              (double.tryParse(wantsController.text) ?? 0) +
              (double.tryParse(savingsController.text) ?? 0);
          double unallocatedPreview = topUpAmount - allocated;

          return Dialog(
            backgroundColor: const Color(0xFF16162A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE8E8F5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Amount to add',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B6B8A),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color(0xFFE8E8F5)),
                    onChanged: (_) => setDialogState(() {}),
                    decoration: InputDecoration(
                      hintText: '₹0',
                      hintStyle: const TextStyle(color: Color(0xFF3A3A5A)),
                      filled: true,
                      fillColor: const Color(0xFF0F0F1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF2A2A40)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF2A2A40)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Distribute',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B6B8A),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            setDialogState(() => isAutoDistribute = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !isAutoDistribute
                                ? const Color(0xFF2A2A40)
                                : const Color(0xFF0F0F1A),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: !isAutoDistribute
                                  ? const Color(0xFF7B7BCC)
                                  : const Color(0xFF2A2A40),
                            ),
                          ),
                          child: Text(
                            'Manual',
                            style: TextStyle(
                              fontSize: 12,
                              color: !isAutoDistribute
                                  ? const Color(0xFFB0B0D0)
                                  : const Color(0xFF6B6B8A),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setDialogState(() => isAutoDistribute = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isAutoDistribute
                                ? const Color(0xFF2A2A40)
                                : const Color(0xFF0F0F1A),
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: isAutoDistribute
                                  ? const Color(0xFF7B7BCC)
                                  : const Color(0xFF2A2A40),
                            ),
                          ),
                          child: Text(
                            'Auto 50/30/20',
                            style: TextStyle(
                              fontSize: 12,
                              color: isAutoDistribute
                                  ? const Color(0xFFB0B0D0)
                                  : const Color(0xFF6B6B8A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!isAutoDistribute) ...[
                    _topUpField(
                      'Needs',
                      needsController,
                      const Color(0xFFCC8A3E),
                      setDialogState,
                    ),
                    const SizedBox(height: 10),
                    _topUpField(
                      'Wants',
                      wantsController,
                      const Color(0xFFCC5A7A),
                      setDialogState,
                    ),
                    const SizedBox(height: 10),
                    _topUpField(
                      'Savings',
                      savingsController,
                      const Color(0xFF2EB89A),
                      setDialogState,
                    ),
                    const SizedBox(height: 16),
                    if (topUpAmount > 0 && unallocatedPreview > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF2A2A40)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Unallocated',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B6B8A),
                              ),
                            ),
                            Text(
                              '₹${unallocatedPreview.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB0B0D0),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2A2A40),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B6B8A),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: topUpAmount > 0
                              ? () async {
                                  double addNeeds = 0;
                                  double addWants = 0;
                                  double addSavings = 0;

                                  if (isAutoDistribute) {
                                    addNeeds = topUpAmount * 0.50;
                                    addWants = topUpAmount * 0.30;
                                    addSavings = topUpAmount * 0.20;
                                  } else {
                                    addNeeds =
                                        double.tryParse(needsController.text) ??
                                        0;
                                    addWants =
                                        double.tryParse(wantsController.text) ??
                                        0;
                                    addSavings =
                                        double.tryParse(
                                          savingsController.text,
                                        ) ??
                                        0;
                                  }

                                  final newUnallocated =
                                      _budget!.unallocated +
                                      (topUpAmount -
                                          addNeeds -
                                          addWants -
                                          addSavings);

                                  final updated = _budget!.copyWith(
                                    total: _budget!.total + topUpAmount,
                                    needs: _budget!.needs + addNeeds,
                                    wants: _budget!.wants + addWants,
                                    savings: _budget!.savings + addSavings,
                                    unallocated: newUnallocated,
                                  );

                                  await BudgetController.saveBudget(updated);
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  _loadBudget();
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: topUpAmount > 0
                                  ? const Color(0xFF2A2A40)
                                  : const Color(0xFF1A1A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: topUpAmount > 0
                                    ? const Color(0xFF2EB89A)
                                    : const Color(0xFF2A2A40),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: topUpAmount > 0
                                    ? const Color(0xFF2EB89A)
                                    : const Color(0xFF3A3A5A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topUpField(
    String label,
    TextEditingController controller,
    Color color,
    StateSetter setDialogState,
  ) {
    return Row(
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
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, color: Color(0xFFE8E8F5)),
            onChanged: (_) => setDialogState(() {}),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Color(0xFF3A3A5A)),
              filled: true,
              fillColor: const Color(0xFF0F0F1A),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2A2A40)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2A2A40)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAllocatePopup(double unallocated) {
    final needsController = TextEditingController();
    final wantsController = TextEditingController();
    final savingsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          double allocated =
              (double.tryParse(needsController.text) ?? 0) +
              (double.tryParse(wantsController.text) ?? 0) +
              (double.tryParse(savingsController.text) ?? 0);
          double remaining = unallocated - allocated;
          bool isValid = allocated <= unallocated && allocated > 0;

          return Dialog(
            backgroundColor: const Color(0xFF16162A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Allocate funds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE8E8F5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${unallocated.toStringAsFixed(0)} available',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B6B8A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _topUpField(
                    'Needs',
                    needsController,
                    const Color(0xFFCC8A3E),
                    setDialogState,
                  ),
                  const SizedBox(height: 10),
                  _topUpField(
                    'Wants',
                    wantsController,
                    const Color(0xFFCC5A7A),
                    setDialogState,
                  ),
                  const SizedBox(height: 10),
                  _topUpField(
                    'Savings',
                    savingsController,
                    const Color(0xFF2EB89A),
                    setDialogState,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0F1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: remaining < 0
                            ? const Color(0xFFCC5A7A)
                            : const Color(0xFF2A2A40),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B6B8A),
                          ),
                        ),
                        Text(
                          '₹${remaining.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: remaining < 0
                                ? const Color(0xFFCC5A7A)
                                : const Color(0xFFB0B0D0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2A2A40),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B6B8A),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: isValid && remaining >= 0
                              ? () async {
                                  final addNeeds =
                                      double.tryParse(needsController.text) ??
                                      0;
                                  final addWants =
                                      double.tryParse(wantsController.text) ??
                                      0;
                                  final addSavings =
                                      double.tryParse(savingsController.text) ??
                                      0;
                                  final newUnallocated =
                                      unallocated -
                                      addNeeds -
                                      addWants -
                                      addSavings;
                                  final updated = _budget!.copyWith(
                                    needs: _budget!.needs + addNeeds,
                                    wants: _budget!.wants + addWants,
                                    savings: _budget!.savings + addSavings,
                                    unallocated: newUnallocated,
                                  );
                                  await BudgetController.saveBudget(updated);
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  _loadBudget();
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isValid && remaining >= 0
                                  ? const Color(0xFF2A2A40)
                                  : const Color(0xFF1A1A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isValid && remaining >= 0
                                    ? const Color(0xFF7B7BCC)
                                    : const Color(0xFF2A2A40),
                              ),
                            ),
                            child: Text(
                              'Allocate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isValid && remaining >= 0
                                    ? const Color(0xFFB0B0D0)
                                    : const Color(0xFF3A3A5A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
        backgroundColor: const Color.fromARGB(255, 7, 3, 25),
        elevation: 0,
        title: const Text(
          'Spndwell',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
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
    final unallocated = _budget!.unallocated;
    final totalIncome = _budget!.total;
    final spent = totalIncome - _budget!.needs - _budget!.wants - _budget!.savings;
    final inHandNow = totalIncome - spent - _compensateOwed + unallocated;
    final ifRecovered = _budget!.needs + _budget!.wants + _budget!.savings;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Income',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '₹${totalIncome.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B8A)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'In hand now',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B6B8A),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${inHandNow.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE8E8F5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _showTopUpPopup,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2EB89A).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF2EB89A).withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF2EB89A),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (unallocated > 0) ...[
                GestureDetector(
                  onTap: () => _showAllocatePopup(unallocated),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B7BCC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF7B7BCC).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Unallocated',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF7B7BCC),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${unallocated.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7B7BCC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '₹${spent.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B8A)),
              ),
              const SizedBox(width: 4),
              const Text(
                'Spent',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2A2A40)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '+ if recovered',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B6B8A)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${ifRecovered.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2EB89A),
                    ),
                  ),
                ],
              ),
            ],
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
                        color: Color(0xFFE8E8F5),
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
