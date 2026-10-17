import 'package:flutter/material.dart';

class VendorListPage extends StatelessWidget {
  const VendorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor List'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Vendor List Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}