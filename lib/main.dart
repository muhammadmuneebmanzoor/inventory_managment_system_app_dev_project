import 'package:flutter/material.dart';
import 'auth_page.dart';

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
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const AuthPage(),
    );
  }
}