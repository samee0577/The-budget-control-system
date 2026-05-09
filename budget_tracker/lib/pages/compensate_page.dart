import 'package:flutter/material.dart';
import '../models/compensate_model.dart';
import '../models/transaction_model.dart';
import '../controllers/compensate_controller.dart';
import '../controllers/transaction_controller.dart';

class CompensatePage extends StatefulWidget {
  const CompensatePage({super.key});

  @override
  State<CompensatePage> createState() => _CompensatePageState();
}

class _CompensatePageState extends State<CompensatePage> {
  final CompensateController _controller = CompensateController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isDragOver = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _itemController.addListener(_update);
    _personController.addListener(_update);
    _amountController.addListener(_update);
  }

  void _update() => setState(() {});

  Future<void> _load() async {
    await _controller.loadCards();
    setState(() => _isLoading = false);
  }

  bool get _canAdd =>
      _itemController.text.isNotEmpty &&
      _personController.text.isNotEmpty &&
      _amountController.text.isNotEmpty &&
      (double.tryParse(_amountController.text) ?? 0) > 0;

  @override
  void dispose() {
    _itemController.removeListener(_update);
    _personController.removeListener(_update);
    _amountController.removeListener(_update);
    _itemController.dispose();
    _personController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF6B6B8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Compensate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE8E8F5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalOwedCard(),
            const SizedBox(height: 24),
            _createCardForm(),
            const SizedBox(height: 24),
            if (_controller.cards.isNotEmpty) ...[
              const Text(
                'Active IOUs',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              _draggableCardsRow(),
              const SizedBox(height: 24),
            ],
            _dropZone(),
            const SizedBox(height: 24),
            _transactionLog(),
          ],
        ),
      ),
    );
  }

  Widget _totalOwedCard() {
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
            'Total to recover',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B6B8A),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _controller.totalOwed > 0
                ? '₹${_controller.totalOwed.toStringAsFixed(0)}'
                : '₹0',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: _controller.totalOwed > 0
                  ? const Color(0xFFCC5A7A)
                  : const Color(0xFF2EB89A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New IOU',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B6B8A),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _formField('Item', _itemController, 'e.g. Groceries'),
          const SizedBox(height: 10),
          _formField('Person', _personController, 'e.g. Mum'),
          const SizedBox(height: 10),
          _formField('Amount', _amountController, 'e.g. 500',
              isNumber: true),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _canAdd ? _addCard : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _canAdd
                    ? const Color(0xFF2A2A40)
                    : const Color(0xFF1A1A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _canAdd
                      ? const Color(0xFF7B7BCC)
                      : const Color(0xFF2A2A40),
                ),
              ),
              child: Text(
                'Add IOU',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _canAdd
                      ? const Color(0xFFB0B0D0)
                      : const Color(0xFF3A3A5A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B6B8A)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Color(0xFFE8E8F5)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF3A3A5A)),
            filled: true,
            fillColor: const Color(0xFF0F0F1A),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      ],
    );
  }

  Future<void> _addCard() async {
    final card = CompensateCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: _itemController.text,
      personName: _personController.text,
      originalAmount: double.parse(_amountController.text),
      remainingAmount: double.parse(_amountController.text),
    );
    await _controller.addCard(card);
    _itemController.clear();
    _personController.clear();
    _amountController.clear();
    setState(() {});
  }

  Widget _draggableCardsRow() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.cards.length,
        itemBuilder: (context, index) {
          final card = _controller.cards[index];
          return _draggableCard(card);
        },
      ),
    );
  }

  Widget _draggableCard(CompensateCard card) {
    return Draggable<CompensateCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: _iouCard(card, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _iouCard(card),
      ),
      child: Stack(
        children: [
          _iouCard(card),
          Positioned(
            top: 0,
            right: 8,
            child: GestureDetector(
              onTap: () async {
                await _controller.deleteCard(card.id);
                setState(() {});
              },
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 11, color: Color(0xFF6B6B8A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iouCard(CompensateCard card, {bool isDragging = false}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDragging ? const Color(0xFF2A2A40) : const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.personName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE8E8F5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            card.itemName,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B6B8A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '₹${card.remainingAmount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFCC5A7A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropZone() {
    return DragTarget<CompensateCard>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isDragOver = true);
        return true;
      },
      onLeave: (_) => setState(() => _isDragOver = false),
      onAcceptWithDetails: (details) {
        setState(() => _isDragOver = false);
        _showReturnPopup(details.data);
      },
      builder: (context, candidate, rejected) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          decoration: BoxDecoration(
            color: _isDragOver
                ? const Color(0xFF1E1E3A)
                : const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isDragOver
                  ? const Color(0xFF7B7BCC)
                  : const Color(0xFF2A2A40),
              width: _isDragOver ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text('💸', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                const Text(
                  'Drag here when money is returned',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B6B8A)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'full or partial return supported',
                  style: TextStyle(fontSize: 11, color: Color(0xFF3A3A5A)),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReturnPopup(CompensateCard card) {
    final returnController = TextEditingController(
      text: card.remainingAmount.toStringAsFixed(0),
    );

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
              Text(
                card.personName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE8E8F5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card.itemName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B6B8A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Remaining: ₹${card.remainingAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFCC5A7A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Amount returned',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: returnController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFE8E8F5)),
                decoration: InputDecoration(
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
                          border: Border.all(color: const Color(0xFF2A2A40)),
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
                      onTap: () async {
                        final amount =
                            double.tryParse(returnController.text) ?? 0;
                        if (amount <= 0) return;
                        await _controller.returnAmount(
                          cardId: card.id,
                          returnedAmount: amount,
                        );
                        setState(() {});
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A40),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: const Color(0xFF2EB89A)),
                        ),
                        child: const Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2EB89A),
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

  Widget _transactionLog() {
    return FutureBuilder<List<TransactionEntry>>(
      future: TransactionController.loadTransactions(section: 'compensate'),
      builder: (context, snapshot) {
        final transactions = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Returns log',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B6B8A),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 220),
              decoration: BoxDecoration(
                color: const Color(0xFF16162A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A40)),
              ),
              child: transactions.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No returns yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3A3A5A),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: Color(0xFF2A2A40),
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final t = transactions[index];
                        return _transactionRow(t);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _transactionRow(TransactionEntry t) {
    final now = DateTime.now();
    final isToday = t.dateTime.day == now.day &&
        t.dateTime.month == now.month &&
        t.dateTime.year == now.year;
    final dateLabel = isToday
        ? 'Today ${_formatTime(t.dateTime)}'
        : '${t.dateTime.day}/${t.dateTime.month}/${t.dateTime.year} ${_formatTime(t.dateTime)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(t.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFE8E8F5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B6B8A),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+ ₹${t.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2EB89A),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $period';
  }
}