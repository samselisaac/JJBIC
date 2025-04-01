import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
