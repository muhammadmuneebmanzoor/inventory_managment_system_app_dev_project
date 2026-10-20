import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Transaction History Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}