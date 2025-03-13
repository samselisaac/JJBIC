import 'package:flutter/material.dart';
import 'screens/list_screen.dart';

void main() {
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26),
      ),
      
      home: ListScreen(),
    );
  }
}
