import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'welcome_page.dart';

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
      theme: AppTheme.theme,
      home: const WelcomePage(),
    );
  }
}
