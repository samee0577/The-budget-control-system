import 'package:flutter/material.dart';

class WantsPage extends StatelessWidget {
  const WantsPage({super.key});

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
          'Wants',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE8E8F5),
          ),
        ),
      ),
    );
  }
}
