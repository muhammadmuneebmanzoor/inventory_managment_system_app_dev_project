import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(const MKInventoryApp());
}

class MKInventoryApp extends StatelessWidget {
  const MKInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M&K Inventory Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const DashboardPage(),
    );
  }
}