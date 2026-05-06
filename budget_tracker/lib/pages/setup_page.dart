import 'package:flutter/material.dart';
import '../controllers/setup_controller.dart';
import 'home_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController totalController = TextEditingController();
  final TextEditingController savingsController = TextEditingController();
  final TextEditingController needsController = TextEditingController();
  final TextEditingController wantsController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    totalController.removeListener(_onFieldChanged);
    savingsController.removeListener(_onFieldChanged);
    needsController.removeListener(_onFieldChanged);
    wantsController.removeListener(_onFieldChanged);
    totalController.dispose();
    savingsController.dispose();
    needsController.dispose();
    wantsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    totalController.addListener(_onFieldChanged);
    savingsController.addListener(_onFieldChanged);
    needsController.addListener(_onFieldChanged);
    wantsController.addListener(_onFieldChanged);
  }

  double _parse(String val) => double.tryParse(val) ?? 0;
  String _percent(TextEditingController controller) {
    final total = _parse(totalController.text);
    final value = _parse(controller.text);
    if (total <= 0) return '0%';
    final pct = (value / total * 100).toStringAsFixed(1);
    return '$pct%';
  }

  void _onFieldChanged() {
    final total = _parse(totalController.text);
    final needs = _parse(needsController.text);
    final wants = _parse(wantsController.text);
    final savings = _parse(savingsController.text);

    // count how many of the 3 fields are filled
    final filledFields = [
      needsController.text.isNotEmpty,
      wantsController.text.isNotEmpty,
      savingsController.text.isNotEmpty,
    ].where((f) => f).length;

    // autofill the last empty field when 2 are filled
    if (total > 0 && filledFields == 2) {
      final remaining = total - needs - wants - savings;
      if (remaining >= 0) {
        if (needsController.text.isEmpty) {
          needsController.text = remaining.toStringAsFixed(0);
          needsController.selection = TextSelection.collapsed(
            offset: needsController.text.length,
          );
        } else if (wantsController.text.isEmpty) {
          wantsController.text = remaining.toStringAsFixed(0);
          wantsController.selection = TextSelection.collapsed(
            offset: wantsController.text.length,
          );
        } else if (savingsController.text.isEmpty) {
          savingsController.text = remaining.toStringAsFixed(0);
          savingsController.selection = TextSelection.collapsed(
            offset: savingsController.text.length,
          );
        }
      }
    }

    // validation
    setState(() {
      final sum = needs + wants + savings;
      if (total > 0 && sum > total) {
        _errorMessage =
            'Total exceeds income by ${(sum - total).toStringAsFixed(0)}';
      } else {
        _errorMessage = null;
      }
    });
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B6B8A),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE8E8F5),
                  ),
                  decoration: const InputDecoration(
                    // isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 90, 90, 139),
                    ),
                    fillColor: Color.fromARGB(0, 18, 18, 18),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _percent(controller),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValid() {
    final total = _parse(totalController.text);
    final sum =
        _parse(needsController.text) +
        _parse(wantsController.text) +
        _parse(savingsController.text);
    return total > 0 && sum == total && _errorMessage == null;
  }

  void _showSummaryDialog() {
    final total = _parse(totalController.text);
    final needs = _parse(needsController.text);
    final wants = _parse(wantsController.text);
    final savings = _parse(savingsController.text);

    String pct(double val) => '${(val / total * 100).toStringAsFixed(1)}%';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF16162A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Budget',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '₹${totalController.text}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE8E8F5),
                ),
              ),
              const SizedBox(height: 24),
              _summaryRow('Needs', needs, pct(needs), const Color(0xFFCC8A3E)),
              const SizedBox(height: 12),
              _summaryRow('Wants', wants, pct(wants), const Color(0xFFCC5A7A)),
              const SizedBox(height: 12),
              _summaryRow(
                'Savings',
                savings,
                pct(savings),
                const Color(0xFF2EB89A),
              ),
              const SizedBox(height: 28),
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
                          border: Border.all(color: const Color(0xFF2A2A40)),
                        ),
                        child: const Text(
                          'Edit',
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
                      onTap: () async {
                        await SetupController.confirmBudget(
                          total: _parse(totalController.text),
                          needs: _parse(needsController.text),
                          wants: _parse(wantsController.text),
                          savings: _parse(savingsController.text),
                        );
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF7B7BCC)),
                        ),
                        child: const Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB0B0D0),
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
      ),
    );
  }

  Widget _summaryRow(String label, double amount, String percent, Color color) {
    return Row(
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
              style: const TextStyle(fontSize: 14, color: Color(0xFFB0B0D0)),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE8E8F5),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                percent,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Budget Setup',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Set your budget',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE8E8F5),
                ),
              ),
              const SizedBox(height: 32),
              // input fields will go here next
              _buildInput(
                'Total income',
                totalController,
                const Color(0xFF7B7BCC),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Color(0xFF2A2A40)),
              ),
              _buildInput('Needs', needsController, const Color(0xFFCC8A3E)),
              _buildInput('Wants', wantsController, const Color(0xFFCC5A7A)),
              _buildInput(
                'Savings',
                savingsController,
                const Color(0xFF2EB89A),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Color(0xFFCC5A7A),
                      fontSize: 13,
                    ),
                  ),
                ),
              const Spacer(),
              GestureDetector(
                onTap: _isValid() ? _showSummaryDialog : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isValid()
                        ? const Color(0xFF2A2A40)
                        : const Color(0xFF1A1A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isValid()
                          ? const Color(0xFF7B7BCC)
                          : const Color(0xFF2A2A40),
                    ),
                  ),
                  child: Text(
                    'Budget',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _isValid()
                          ? const Color(0xFFB0B0D0)
                          : const Color(0xFF3A3A5A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
