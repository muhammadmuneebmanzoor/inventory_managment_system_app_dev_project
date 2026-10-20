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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF00ACC1)),
                      columns: const [
                        DataColumn(
                          label: Text('No.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Product Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Quantity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Supplier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Description', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],

                      rows: const [],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Bottom Right Export Button Layout
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {

                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}