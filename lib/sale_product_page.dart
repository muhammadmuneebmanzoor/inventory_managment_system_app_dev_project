import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'transaction_history_page.dart';

class Product {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String date;
  final String supplier;
  final String description;
  final File? imageFile;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.date,
    required this.supplier,
    required this.description,
    this.imageFile,
  });
}

class SaleProductPage extends StatefulWidget {
  const SaleProductPage({
    super.key,
    required this.products,
    required this.onSaleCompleted,
  });

  final List<Product> products;
  final void Function(Product product, SaleTransaction transaction) onSaleCompleted;

  @override
  State<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends State<SaleProductPage> {
  Future<void> _openCheckout(Product product) async {
    final SaleTransaction? result = await Navigator.push<SaleTransaction>(
      context,
      MaterialPageRoute(
        builder: (context) => _SaleCheckoutPage(product: product),
      ),
    );

    if (result != null) {
      setState(() {
        widget.onSaleCompleted(product, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Product'),
      ),
      body: widget.products.isEmpty
          ? const Center(
        child: Text(
          'No products saved yet. Add a product first.',
          style: TextStyle(fontSize: 16, color: AppColors.textMuted),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final Product item = widget.products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.terracotta,
                backgroundImage: item.imageFile != null ? FileImage(item.imageFile!) : null,
                child: item.imageFile == null
                    ? const Icon(Icons.inventory_2, color: AppColors.onPrimary)
                    : null,
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
              trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
              onTap: () => _openCheckout(item),
            ),
          );
        },
      ),
    );
  }
}

class _SaleCheckoutPage extends StatefulWidget {
  const _SaleCheckoutPage({required this.product});

  final Product product;

  @override
  State<_SaleCheckoutPage> createState() => _SaleCheckoutPageState();
}

class _SaleCheckoutPageState extends State<_SaleCheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerContactController = TextEditingController();

  int _quantity = 1;

  double get _totalPrice => widget.product.price * _quantity;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _dateController.text = "${now.day}/${now.month}/${now.year}";
  }

  void _incrementQuantity() {
    setState(() {
      if (_quantity < widget.product.quantity) {
        _quantity += 1;
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _completeSale() {
    if (_formKey.currentState!.validate()) {
      final SaleTransaction transaction = SaleTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productName: widget.product.name,
        unitPrice: widget.product.price,
        quantity: _quantity,
        totalPrice: _totalPrice,
        date: _dateController.text.trim(),
        customerName: _customerNameController.text.trim(),
        customerContact: _customerContactController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Sale recorded successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, transaction);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _customerNameController.dispose();
    _customerContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _completeSale,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.terracotta,
                          backgroundImage: widget.product.imageFile != null
                              ? FileImage(widget.product.imageFile!)
                              : null,
                          child: widget.product.imageFile == null
                              ? const Icon(Icons.inventory_2, color: AppColors.onPrimary)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unit Price: ${widget.product.price.toStringAsFixed(2)}  |  Stock: ${widget.product.quantity}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          color: AppColors.terracotta,
                          onPressed: _decrementQuantity,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          color: AppColors.terracotta,
                          onPressed: _incrementQuantity,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Total Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Calculated Total',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        Text(
                          _totalPrice.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.terracotta,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    hintText: 'Tap to select date',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Customer Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: John Doe',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Customer Contact',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _customerContactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Ex: +1234567890',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 8) return 'Enter a valid contact number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _completeSale,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8),
                      Text('Save Sale'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}