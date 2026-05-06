import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../models/expense_item.dart';
import '../controllers/needs_controller.dart';
import '../controllers/budget_controller.dart';

class NeedsPage extends StatefulWidget {
  final BudgetModel budget;
  const NeedsPage({super.key, required this.budget});

  @override
  State<NeedsPage> createState() => _NeedsPageState();
}

class _NeedsPageState extends State<NeedsPage> {
  final NeedsController _controller = NeedsController();
  bool _isDragOver = false;

  void _showEditPopup(DroppedExpense dropped) {
    final priceController = TextEditingController(
      text: dropped.priceOverride.toStringAsFixed(0),
    );
    final qtyController = TextEditingController(
      text: dropped.quantity.toString(),
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
              Row(
                children: [
                  Text(
                    dropped.item.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dropped.item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE8E8F5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Price (₹)',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
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
              const SizedBox(height: 16),
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B6B8A),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
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
                      onTap: () {
                        final newPrice = double.tryParse(priceController.text);
                        final newQty = int.tryParse(qtyController.text);
                        setState(() {
                          _controller.updateItem(
                            dropped.item.id,
                            price: newPrice,
                            quantity: newQty,
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCC8A3E)),
                        ),
                        child: const Text(
                          'Update',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFCC8A3E),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF6B6B8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Needs',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE8E8F5),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _remainingBar(),
          const SizedBox(height: 24),
          const Spacer(),
          _dropZone(),
          const Spacer(),
          _draggableItemsRow(),
          const SizedBox(height: 18),
          _doneButton(),
        ],
      ),
    );
  }

  Widget _remainingBar() {
    final remaining = widget.budget.needs - _controller.totalExpense;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCC8A3E),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'This session',
                style: TextStyle(fontSize: 11, color: Color(0xFF6B6B8A)),
              ),
              const SizedBox(height: 4),
              Text(
                '- ₹${_controller.totalExpense.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 15, color: Color(0xFFCC5A7A)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _draggableItemsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Your expenses',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B6B8A),
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: NeedsController.needsItems.length,
            itemBuilder: (context, index) {
              final item = NeedsController.needsItems[index];
              return _draggableCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _draggableCard(ExpenseItem item) {
    return Draggable<ExpenseItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: _itemCard(item, isDragging: true),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: _itemCard(item)),
      child: _itemCard(item),
    );
  }

  Widget _itemCard(ExpenseItem item, {bool isDragging = false}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDragging ? const Color(0xFF2A2A40) : const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            item.name,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B6B8A)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.basePrice > 0
                ? '₹${item.basePrice.toStringAsFixed(0)}'
                : 'custom',
            style: const TextStyle(fontSize: 10, color: Color(0xFFCC8A3E)),
          ),
        ],
      ),
    );
  }

  Widget _dropZone() {
    return DragTarget<ExpenseItem>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isDragOver = true);
        return true;
      },
      onLeave: (_) => setState(() => _isDragOver = false),
      onAcceptWithDetails: (details) {
        setState(() {
          _isDragOver = false;
          if (details.data.id == 'manual') {
            _controller.droppedItems.add(DroppedExpense(item: details.data));
            final dropped = _controller.droppedItems.last;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showEditPopup(dropped);
            });
          } else {
            _controller.dropItem(details.data);
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 160),
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
              style: BorderStyle.solid,
            ),
          ),
          child: _controller.droppedItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text('⬆️', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 8),
                      Text(
                        'Drag your expenses here',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B6B8A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'then press Done to log them',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF3A3A5A),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _controller.droppedItems
                        .map((d) => _droppedChip(d))
                        .toList(),
                  ),
                ),
        );
      },
    );
  }

  Widget _droppedChip(DroppedExpense dropped) {
    return GestureDetector(
      onLongPress: () => _showEditPopup(dropped),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E3A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dropped.item.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dropped.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE8E8F5),
                  ),
                ),
                Text(
                  '₹${dropped.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFCC8A3E),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () =>
                  setState(() => _controller.removeItem(dropped.item.id)),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Color(0xFF6B6B8A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doneButton() {
    final hasItems = _controller.droppedItems.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: GestureDetector(
        onTap: hasItems
            ? () async {
                final newNeeds = widget.budget.needs - _controller.totalExpense;
                final updated = widget.budget.copyWith(needs: newNeeds);
                await BudgetController.saveBudget(updated);
                if (!mounted) return;
                Navigator.pop(context, updated);
              }
            : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: hasItems ? const Color(0xFF2A2A40) : const Color(0xFF1A1A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasItems
                  ? const Color(0xFFCC8A3E)
                  : const Color(0xFF2A2A40),
            ),
          ),
          child: Text(
            hasItems
                ? 'Done  ₹${_controller.totalExpense.toStringAsFixed(0)}'
                : 'Done',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: hasItems
                  ? const Color(0xFFCC8A3E)
                  : const Color(0xFF3A3A5A),
            ),
          ),
        ),
      ),
    );
  }
}
