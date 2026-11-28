import 'package:flutter/material.dart';
import 'app_theme.dart';

class SaleTransaction {
  final String id;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String date;
  final String time;
  final String customerName;
  final String customerContact;

  SaleTransaction({
    required this.id,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.customerName,
    required this.customerContact,
  });
}

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({
    super.key,
    this.transactions = const [],
  });

  final List<SaleTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: transactions.isEmpty
          ? const Center(
        child: Text(
          'No transactions recorded yet.',
          style: TextStyle(fontSize: 18, color: AppColors.textMuted),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final SaleTransaction tx = transactions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.dusk,
                child: const Icon(Icons.receipt_long, color: AppColors.onPrimary),
              ),
              title: Text(
                '\$${tx.totalPrice.toStringAsFixed(2)}  •  ${tx.productName} (x${tx.quantity})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Date: ${tx.date}  |  Time: ${tx.time}\nCustomer: ${tx.customerName} (${tx.customerContact})',
                style: const TextStyle(color: AppColors.textMuted),
              ),
              isThreeLine: true,
              trailing: Text(
                '\$${tx.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.terracotta,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}