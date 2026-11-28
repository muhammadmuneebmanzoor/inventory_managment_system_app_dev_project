import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'sale_product_page.dart';

class PurchaseDetailPage extends StatelessWidget {
  const PurchaseDetailPage({
    super.key,
    this.products = const [],
  });

  final List<Product> products;

  String _escapePdfText(String text) {
    return text.replaceAll('\\', '\\\\').replaceAll('(', '\\(').replaceAll(')', '\\)');
  }

  Uint8List _buildPdfBytes() {
    final List<String> lines = [
      'M&K Inventory Purchase Report',
      'Generated: ${DateTime.now()}',
      '----------------------------------------',
    ];

    for (int i = 0; i < products.length; i++) {
      final Product item = products[i];
      lines.add(
        '${i + 1}. ${item.name} | Price: \$${item.price.toStringAsFixed(2)} | Qty: ${item.quantity} | Supplier: ${item.supplier} | Date: ${item.date}',
      );
    }

    final StringBuffer content = StringBuffer();
    content.writeln('BT');
    content.writeln('/F1 12 Tf');
    content.writeln('50 780 Td');
    content.writeln('16 TL');
    for (int i = 0; i < lines.length; i++) {
      final String escaped = _escapePdfText(lines[i]);
      if (i == 0) {
        content.writeln('($escaped) Tj');
      } else {
        content.writeln('T* ($escaped) Tj');
      }
    }
    content.writeln('ET');

    final String streamData = content.toString();
    final List<String> objects = [
      '1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n',
      '2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n',
      '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n',
      '4 0 obj\n<< /Length ${streamData.length} >>\nstream\n$streamData\nendstream\nendobj\n',
      '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
    ];

    final StringBuffer pdf = StringBuffer();
    pdf.write('%PDF-1.4\n');
    final List<int> offsets = [0];

    for (final String obj in objects) {
      offsets.add(pdf.toString().length);
      pdf.write(obj);
    }

    final int xrefStart = pdf.toString().length;
    pdf.write('xref\n0 ${objects.length + 1}\n');
    pdf.write('0000000000 65535 f \n');
    for (int i = 1; i < offsets.length; i++) {
      pdf.write('${offsets[i].toString().padLeft(10, '0')} 00000 n \n');
    }
    pdf.write(
      'trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n$xrefStart\n%%EOF',
    );

    return Uint8List.fromList(utf8.encode(pdf.toString()));
  }

  void _exportReport(BuildContext context) {
    final Uint8List pdfBytes = _buildPdfBytes();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Report Ready'),
        content: Text(
          'purchase_report.pdf generated (${pdfBytes.length} bytes) with ${products.length} product row(s).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    border: TableBorder.all(color: AppColors.border),
                    headingRowColor: WidgetStateProperty.all(AppColors.surface),
                    columns: const [
                      DataColumn(
                        label: Text('No.', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Supplier', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: List<DataRow>.generate(products.length, (index) {
                      final Product item = products[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(item.name)),
                          DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                          DataCell(Text('${item.quantity}')),
                          DataCell(Text(item.date)),
                          DataCell(Text(item.supplier)),
                          DataCell(Text(item.description)),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _exportReport(context),
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ],
        ),
      ),
    );
  }
}