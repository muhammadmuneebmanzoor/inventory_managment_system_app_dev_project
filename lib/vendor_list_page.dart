import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'add_vendor_page.dart';

class VendorListPage extends StatelessWidget {
  const VendorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVendorPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Vendor List Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
