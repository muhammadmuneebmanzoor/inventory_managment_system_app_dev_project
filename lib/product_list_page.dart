import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'add_product_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Product List Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
