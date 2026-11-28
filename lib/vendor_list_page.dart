import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';

class Vendor {
  final String id;
  final String name;
  final String company;
  final String address;
  final String contact;
  final File? imageFile;

  Vendor({
    required this.id,
    required this.name,
    required this.company,
    required this.address,
    required this.contact,
    this.imageFile,
  });
}

class VendorListPage extends StatelessWidget {
  const VendorListPage({
    super.key,
    this.vendors = const [],
    this.onAddVendor,
  });

  final List<Vendor> vendors;
  final VoidCallback? onAddVendor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: vendors.isEmpty
                  ? const Center(
                child: Text(
                  'No vendors added yet.',
                  style: TextStyle(fontSize: 18, color: AppColors.textMuted),
                ),
              )
                  : ListView.builder(
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final Vendor vendor = vendors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.ochre,
                        backgroundImage: vendor.imageFile != null
                            ? FileImage(vendor.imageFile!)
                            : null,
                        child: vendor.imageFile == null
                            ? const Icon(Icons.person, color: AppColors.onPrimary)
                            : null,
                      ),
                      title: Text(
                        vendor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${vendor.company}  \vert{}${vendor.contact}',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddVendor,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Vendor'),
            ),
          ],
        ),
      ),
    );
  }
}