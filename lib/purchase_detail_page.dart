import 'package:flutter/material.dart';

class PurchaseDetailPage extends StatelessWidget {
  const PurchaseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Detail'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer & Order Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 12),

              // Customer & Order Form / Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Order ID:', value: 'ORD-5001'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Customer Name:', value: 'Ali Khan'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Contact No:', value: '+92 300 1234567'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Address:', value: 'House 12, Street 4, Islamabad'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Product Name:', value: 'Blue Pen'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Quantity:', value: '10 Units'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Total Price:', value: '\$45.00'),
                    SizedBox(height: 8),
                    _DetailRow(label: 'Date:', value: '24/10/2026'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget to keep detail rows clean and aligned
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}