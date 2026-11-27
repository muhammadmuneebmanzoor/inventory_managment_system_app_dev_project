import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'sale_product_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({
    super.key,
    this.products = const [],
    this.onAddProduct,
  });

  final List<Product> products;
  final VoidCallback? onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddProduct,
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
        child: Text(
          'Product List Page (Coming Soon)',
          style: TextStyle(fontSize: 18, color: AppColors.textMuted),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final Product item = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.oasis,
                child: const Icon(Icons.inventory_2, color: AppColors.onPrimary),
              ),
              title: Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Price: ${item.price.toStringAsFixed(2)}  |  Stock: ${item.quantity}',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          );
        },
      ),
    );
  }
}