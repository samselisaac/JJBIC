import 'package:flutter/material.dart';
import 'screens/lists_overview_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

const primaryGreen = Color(0xFF7ABB5E);
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseDatabase database = FirebaseDatabase.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Inventory App',
          themeMode: currentTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
            dividerTheme: DividerThemeData(
              color: Colors.grey.shade300,
              thickness: 1,
              space: 0,
            ),
            scaffoldBackgroundColor: Colors.grey[200]!,
            canvasColor: Colors.grey[200]!,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[200]!,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
            ),
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
            ),
            cardTheme: const CardTheme(
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: primaryGreen,
              onPrimary: Colors.black,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.black,
              ),
            ),
            dividerTheme: DividerThemeData(
              color: Colors.grey.shade800,
              thickness: 1,
              space: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFF0F0F0F),
            canvasColor: const Color(0xFF0F0F0F),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F0F0F),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color(0xFF242424),
            ),
            dialogTheme: const DialogTheme(
              backgroundColor: Color(0xFF242424),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            cardColor: const Color(0xFF2D2D2D),
            cardTheme: const CardTheme(
              color: Color(0xFF2D2D2D),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
          ),
          home: const ListScreen(),
        );
      },
    );
  }
}
