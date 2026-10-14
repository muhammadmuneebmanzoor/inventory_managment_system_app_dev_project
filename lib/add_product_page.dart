import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedSupplier;
  // Supplier list is now empty; it will be populated dynamically later.
  final List<String> _suppliers = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProduct,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFB2EBF2),
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                          : const Icon(Icons.inventory_2, size: 48, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF64B5F6),
                        foregroundColor: Colors.black87,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: const Text(
                        'ADD IMAGE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Name',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Pen',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Product Price',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'Ex: 4.50',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (double.tryParse(v.trim()) == null) return 'Enter a valid price';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 5',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: const InputDecoration(
                          hintText: 'Tap to select',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Supplier',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedSupplier,
                        hint: const Text('Select Supplier', style: TextStyle(color: Colors.grey)),
                        items: _suppliers.isEmpty
                            ? null
                            : _suppliers.map((String supplier) {
                          return DropdownMenuItem<String>(
                            value: supplier,
                            child: Text(supplier),
                          );
                        }).toList(),
                        onChanged: _suppliers.isEmpty
                            ? null
                            : (newValue) {
                          setState(() {
                            _selectedSupplier = newValue;
                          });
                        },
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Blue Pen',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}