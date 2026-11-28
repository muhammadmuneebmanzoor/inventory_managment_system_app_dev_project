import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'transaction_history_page.dart';

class _ProductSalesSummary {
  final String productName;
  int monthlySales;
  int yearlySales;
  double totalRevenue;

  _ProductSalesSummary({
    required this.productName,
    required this.monthlySales,
    required this.yearlySales,
    required this.totalRevenue,
  });
}

class SalesDetailPage extends StatelessWidget {
  const SalesDetailPage({
    super.key,
    this.transactions = const [],
  });

  final List<SaleTransaction> transactions;

  List<_ProductSalesSummary> _buildSummary() {
    final Map<String, _ProductSalesSummary> map = {};
    final DateTime now = DateTime.now();

    for (final SaleTransaction tx in transactions) {
      final List<String> parts = tx.date.split('/');
      final int? month = parts.length == 3 ? int.tryParse(parts[1]) : null;
      final int? year = parts.length == 3 ? int.tryParse(parts[2]) : null;

      final bool isSameYear = year != null ? year == now.year : true;
      final bool isSameMonth = isSameYear && month != null ? month == now.month : isSameYear;

      final _ProductSalesSummary summary = map.putIfAbsent(
        tx.productName,
            () => _ProductSalesSummary(
          productName: tx.productName,
          monthlySales: 0,
          yearlySales: 0,
          totalRevenue: 0.0,
        ),
      );

      if (isSameMonth) {
        summary.monthlySales += tx.quantity;
      }
      if (isSameYear) {
        summary.yearlySales += tx.quantity;
      }
      summary.totalRevenue += tx.totalPrice;
    }

    return map.values.toList();
  }

  String _escapePdfText(String text) {
    return text.replaceAll('\\', '\\\\').replaceAll('(', '\\(').replaceAll(')', '\\)');
  }

  Uint8List _buildPdfBytes(List<_ProductSalesSummary> summaries) {
    final List<String> lines = [
      'M&K Inventory Sales Report',
      'Generated: ${DateTime.now()}',
      '----------------------------------------',
    ];

    double grandTotal = 0.0;
    for (int i = 0; i < summaries.length; i++) {
      final _ProductSalesSummary item = summaries[i];
      grandTotal += item.totalRevenue;
      lines.add(
        '${i + 1}. ${item.productName} | Monthly: ${item.monthlySales} | Yearly: ${item.yearlySales} | Revenue: \$${item.totalRevenue.toStringAsFixed(2)}',
      );
    }

    lines.add('----------------------------------------');
    lines.add('Total Revenue: \$${grandTotal.toStringAsFixed(2)}');

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

  void _exportReport(BuildContext context, List<_ProductSalesSummary> summaries) {
    final Uint8List pdfBytes = _buildPdfBytes(summaries);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Report Ready'),
        content: Text(
          'sales_report.pdf generated (${pdfBytes.length} bytes) with ${summaries.length} product row(s).',
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
    final List<_ProductSalesSummary> summaries = _buildSummary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Detail'),
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
                        label: Text('Monthly Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Yearly Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Total Revenue', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: List<DataRow>.generate(summaries.length, (index) {
                      final _ProductSalesSummary item = summaries[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(item.productName)),
                          DataCell(Text('${item.monthlySales}')),
                          DataCell(Text('${item.yearlySales}')),
                          DataCell(Text('\$${item.totalRevenue.toStringAsFixed(2)}')),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _exportReport(context, summaries),
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ],
        ),
      ),
    );
  }
}