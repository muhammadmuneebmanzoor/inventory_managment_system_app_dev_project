import 'package:flutter/material.dart';
import 'app_theme.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: const Center(
        child: Text(
          'Transaction History Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
