import 'package:flutter/material.dart';

class AddVendorPage extends StatefulWidget {
  const AddVendorPage({super.key});

  @override
  State<AddVendorPage> createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  void _saveVendor() {
    if (_formKey.currentState!.validate()) {
     
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vendor'),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveVendor,
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
                const Text(
                  'Supplier Name',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: James',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Company',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Piano',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Address',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Jordan',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Contact No',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Ex: +9232148...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 8) return 'Enter a valid contact number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}